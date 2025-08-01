{-
(c) The University of Glasgow 2006
(c) The AQUA Project, Glasgow University, 1996-1998


This module contains "tidying" code for *nested* expressions, bindings, rules.
The code for *top-level* bindings is in GHC.Iface.Tidy.
-}


module GHC.Core.Tidy (
        tidyExpr, tidyRules, tidyCbvInfoTop, tidyBndrs
    ) where

import GHC.Prelude

import GHC.Core
import GHC.Core.Type
import GHC.Core.TyCo.Tidy
import GHC.Core.Seq ( seqUnfolding )

import GHC.Types.Id
import GHC.Types.Id.Info
import GHC.Types.Demand ( zapDmdEnvSig, isStrUsedDmd )
import GHC.Types.Var
import GHC.Types.Var.Env
import GHC.Types.Unique (getUnique)
import GHC.Types.Unique.FM
import GHC.Types.Name hiding (tidyNameOcc)
import GHC.Types.Name.Set
import GHC.Types.SrcLoc
import GHC.Types.Tickish

import GHC.Data.Maybe
import GHC.Utils.Misc
import Data.List (mapAccumL)
import GHC.Utils.Outputable
import GHC.Types.RepType (typePrimRep)
import GHC.Utils.Panic
import GHC.Types.Basic (isMarkedCbv, CbvMark (..))
import GHC.Core.Utils (shouldUseCbvForId)

{-
************************************************************************
*                                                                      *
\subsection{Tidying expressions, rules}
*                                                                      *
************************************************************************
-}

tidyBind :: TidyEnv
         -> CoreBind
         ->  (TidyEnv, CoreBind)

tidyBind env (NonRec bndr rhs)
  = -- pprTrace "tidyBindNonRec" (ppr bndr) $
    let cbv_bndr = (tidyCbvInfoLocal bndr rhs)
        (env', bndr') = tidyLetBndr env env cbv_bndr
        tidy_rhs = (tidyExpr env' rhs)
    in (env', NonRec bndr' tidy_rhs)

tidyBind env (Rec prs)
  = -- pprTrace "tidyBindRec" (ppr $ map fst prs) $
    let
       cbv_bndrs = map ((\(bnd,rhs) -> tidyCbvInfoLocal bnd rhs)) prs
       (_bndrs, rhss)  = unzip prs
       (env', bndrs') = mapAccumL (tidyLetBndr env') env cbv_bndrs
    in
    map (tidyExpr env') rhss =: \ rhss' ->
    (env', Rec (zip bndrs' rhss'))


-- Note [Attaching CBV Marks to ids]
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- See Note [CBV Function Ids] for the *why*.
-- Before tidy, we turn all worker functions into worker like ids.
-- This way we can later tell if we can assume the existence of a wrapper. This also applies to
-- specialized versions of functions generated by SpecConstr for which we, in a sense,
-- consider the unspecialized version to be the wrapper.
-- During tidy we take the demands on the arguments for these ids and compute
-- CBV (call-by-value) semantics for each individual argument.
-- The marks themselves then are put onto the function id itself.
-- This means the code generator can get the full calling convention by only looking at the function
-- itself without having to inspect the RHS.
--
-- The actual logic is in computeCbvInfo and takes:
-- * The function id
-- * The functions rhs
-- And gives us back the function annotated with the marks.
-- We call it in:
-- * tidyTopPair for top level bindings
-- * tidyBind for local bindings.
--
-- Not that we *have* to look at the untidied rhs.
-- During tidying some knot-tying occurs which can blow up
-- if we look at the post-tidy types of the arguments here.
-- However we only care if the types are unlifted and that doesn't change during tidy.
-- so we can just look at the untidied types.
--
-- If the id is boot-exported we don't use a cbv calling convention via marks,
-- as the boot file won't contain them. Which means code calling boot-exported
-- ids might expect these ids to have a vanilla calling convention even if we
-- determine a different one here.
-- To be able to avoid this we pass a set of boot exported ids for this module around.
-- For non top level ids we can skip this. Local ids are never boot-exported
-- as boot files don't have unfoldings. So there this isn't a concern.
-- See also Note [CBV Function Ids]


-- See Note [CBV Function Ids]
tidyCbvInfoTop :: HasDebugCallStack => NameSet -> Id -> CoreExpr -> Id
tidyCbvInfoTop boot_exports id rhs
  -- Can't change calling convention for boot exported things
  | elemNameSet (idName id) boot_exports = id
  | otherwise = computeCbvInfo id rhs

-- See Note [CBV Function Ids]
tidyCbvInfoLocal :: HasDebugCallStack => Id -> CoreExpr -> Id
tidyCbvInfoLocal id rhs = computeCbvInfo id rhs

-- | For a binding we:
-- * Look at the args
-- * Mark any argument as call-by-value if:
--   - It's argument to a worker and demanded strictly
--   - Unless it's an unlifted type already
-- * Update the id
-- See Note [CBV Function Ids]
-- See Note [Attaching CBV Marks to ids]

computeCbvInfo :: HasCallStack
               => Id            -- The function
               -> CoreExpr      -- It's RHS
               -> Id
-- computeCbvInfo fun_id rhs = fun_id
computeCbvInfo fun_id rhs
  | is_wkr_like || isJoinPoint mb_join_id
  , valid_unlifted_worker val_args
  = -- pprTrace "computeCbvInfo"
    --   (text "fun" <+> ppr fun_id $$
    --     text "arg_tys" <+> ppr (map idType val_args) $$

    --     text "prim_rep" <+> ppr (map typePrimRep_maybe $ map idType val_args) $$
    --     text "rrarg" <+> ppr (map isRuntimeVar val_args) $$
    --     text "cbv_marks" <+> ppr cbv_marks $$
    --     text "out_id" <+> ppr cbv_bndr $$
    --     ppr rhs)
    cbv_bndr

  | otherwise = fun_id
  where
    mb_join_id  = idJoinPointHood fun_id
    is_wkr_like = isWorkerLikeId fun_id

    val_args = filter isId lam_bndrs
    -- When computing CbvMarks, we limit the arity of join points to
    -- the JoinArity, because that's the arity we are going to use
    -- when calling it. There may be more lambdas than that on the RHS.
    lam_bndrs | JoinPoint join_arity <- mb_join_id
              = fst $ collectNBinders join_arity rhs
              | otherwise
              = fst $ collectBinders rhs

    cbv_marks = -- assert: CBV marks are only set during tidy so none should be present already.
                assertPpr (maybe True null $ idCbvMarks_maybe fun_id)
                          (ppr fun_id <+> (ppr $ idCbvMarks_maybe fun_id) $$ ppr rhs) $
                map mkMark val_args

    cbv_bndr | any isMarkedCbv cbv_marks
             = cbv_marks `seqList` setIdCbvMarks fun_id cbv_marks
               -- seqList: avoid retaining the original rhs

             | otherwise
             = -- pprTraceDebug "computeCbvInfo: Worker seems to take unboxed tuple/sum types!"
               --    (ppr fun_id <+> ppr rhs)
               asNonWorkerLikeId fun_id

    -- We don't set CBV marks on functions which take unboxed tuples or sums as
    -- arguments.  Doing so would require us to compute the result of unarise
    -- here in order to properly determine argument positions at runtime.
    --
    -- In practice this doesn't matter much. Most "interesting" functions will
    -- get a W/W split which will eliminate unboxed tuple arguments, and unboxed
    -- sums are rarely used. But we could change this in the future and support
    -- unboxed sums/tuples as well.
    valid_unlifted_worker args =
      -- pprTrace "valid_unlifted" (ppr fun_id $$ ppr args) $
      all isSingleUnarisedArg args

    isSingleUnarisedArg v
      | isUnboxedSumType ty = False
      | isUnboxedTupleType ty = isSimplePrimRep (typePrimRep ty)
      | otherwise = isSimplePrimRep (typePrimRep ty)
      where
        ty = idType v
        isSimplePrimRep []  = True
        isSimplePrimRep [_] = True
        isSimplePrimRep _   = False

    mkMark arg
      | not $ shouldUseCbvForId arg = NotMarkedCbv
      -- We can only safely use cbv for strict arguments
      | (isStrUsedDmd (idDemandInfo arg))
      , not (isDeadEndId fun_id) = MarkedCbv
      | otherwise = NotMarkedCbv


------------  Expressions  --------------
tidyExpr :: TidyEnv -> CoreExpr -> CoreExpr
tidyExpr env (Var v)       = Var (tidyVarOcc env v)
tidyExpr env (Type ty)     = Type (tidyType env ty)
tidyExpr env (Coercion co) = Coercion (tidyCo env co)
tidyExpr _   (Lit lit)     = Lit lit
tidyExpr env (App f a)     = App (tidyExpr env f) (tidyExpr env a)
tidyExpr env (Tick t e)    = Tick (tidyTickish env t) (tidyExpr env e)
tidyExpr env (Cast e co)   = Cast (tidyExpr env e) (tidyCo env co)

tidyExpr env (Let b e)
  = tidyBind env b      =: \ (env', b') ->
    Let b' (tidyExpr env' e)

tidyExpr env (Case e b ty alts)
  = tidyBndr env b  =: \ (env', b) ->
    Case (tidyExpr env e) b (tidyType env ty)
         (map (tidyAlt env') alts)

tidyExpr env (Lam b e)
  = tidyBndr env b      =: \ (env', b) ->
    Lam b (tidyExpr env' e)

------------  Case alternatives  --------------
tidyAlt :: TidyEnv -> CoreAlt -> CoreAlt
tidyAlt env (Alt con vs rhs)
  = tidyBndrs env vs    =: \ (env', vs) ->
    (Alt con vs (tidyExpr env' rhs))

------------  Tickish  --------------
tidyTickish :: TidyEnv -> CoreTickish -> CoreTickish
tidyTickish env (Breakpoint ext bid ids)
  = Breakpoint ext bid (map (tidyVarOcc env) ids)
tidyTickish _   other_tickish       = other_tickish

------------  Rules  --------------
tidyRules :: TidyEnv -> [CoreRule] -> [CoreRule]
tidyRules _   [] = []
tidyRules env (rule : rules)
  = tidyRule env rule           =: \ rule ->
    tidyRules env rules         =: \ rules ->
    (rule : rules)

tidyRule :: TidyEnv -> CoreRule -> CoreRule
tidyRule _   rule@(BuiltinRule {}) = rule
tidyRule env rule@(Rule { ru_bndrs = bndrs, ru_args = args, ru_rhs = rhs,
                          ru_fn = fn, ru_rough = mb_ns })
  = tidyBndrs env bndrs         =: \ (env', bndrs) ->
    map (tidyExpr env') args    =: \ args ->
    rule { ru_bndrs = bndrs, ru_args = args,
           ru_rhs   = tidyExpr env' rhs,
           ru_fn    = tidyNameOcc env fn,
           ru_rough = map (fmap (tidyNameOcc env')) mb_ns }

{-
************************************************************************
*                                                                      *
\subsection{Tidying non-top-level binders}
*                                                                      *
************************************************************************
-}

tidyNameOcc :: TidyEnv -> Name -> Name
-- In rules and instances, we have Names, and we must tidy them too
-- Fortunately, we can lookup in the VarEnv with a name
tidyNameOcc (_, var_env) n = case lookupUFM_Directly var_env (getUnique n) of
                                Nothing -> n
                                Just v  -> idName v

tidyVarOcc :: TidyEnv -> Var -> Var
tidyVarOcc (_, var_env) v = lookupVarEnv var_env v `orElse` v

-- tidyBndr is used for lambda and case binders
tidyBndr :: TidyEnv -> Var -> (TidyEnv, Var)
tidyBndr env var
  | isTyCoVar var = tidyVarBndr env var
  | otherwise     = tidyIdBndr env var

tidyBndrs :: TidyEnv -> [Var] -> (TidyEnv, [Var])
tidyBndrs env vars = mapAccumL tidyBndr env vars

-- Non-top-level variables, not covars
tidyIdBndr :: TidyEnv -> Id -> (TidyEnv, Id)
tidyIdBndr env@(tidy_env, var_env) id
  = -- Do this pattern match strictly, otherwise we end up holding on to
    -- stuff in the OccName.
    case tidyOccName tidy_env (getOccName id) of { (tidy_env', occ') ->
    let
        -- Give the Id a fresh print-name, *and* rename its type
        -- The SrcLoc isn't important now,
        -- though we could extract it from the Id
        --
        ty'      = tidyType env (idType id)
        mult'    = tidyType env (idMult id)
        name'    = mkInternalName (idUnique id) occ' noSrcSpan
        id'      = mkLocalIdWithInfo name' mult' ty' new_info
        var_env' = extendVarEnv var_env id id'

        -- Note [Tidy IdInfo]
        new_info = vanillaIdInfo `setOccInfo` occInfo old_info
                                 `setUnfoldingInfo` new_unf
                                  -- see Note [Preserve OneShotInfo]
                                 `setOneShotInfo` oneShotInfo old_info
        old_info = idInfo id
        old_unf  = realUnfoldingInfo old_info
        new_unf  = trimUnfolding old_unf  -- See Note [Preserve evaluatedness]
    in
    ((tidy_env', var_env'), id')
   }

tidyLetBndr :: TidyEnv         -- Knot-tied version for unfoldings
            -> TidyEnv         -- The one to extend
            -> Id -> (TidyEnv, Id)
-- Used for local (non-top-level) let(rec)s
-- Just like tidyIdBndr above, but with more IdInfo
tidyLetBndr rec_tidy_env env@(tidy_env, var_env) id
  = case tidyOccName tidy_env (getOccName id) of { (tidy_env', occ') ->
    let
        ty'      = tidyType env (idType id)
        mult'    = tidyType env (idMult id)
        name'    = mkInternalName (idUnique id) occ' noSrcSpan
        details  = idDetails id
        id'      = mkLocalVar details name' mult' ty' new_info
        var_env' = extendVarEnv var_env id id'

        -- Note [Tidy IdInfo]
        -- We need to keep around any interesting strictness and
        -- demand info because later on we may need to use it when
        -- converting to A-normal form.
        -- eg.
        --      f (g x),  where f is strict in its argument, will be converted
        --      into  case (g x) of z -> f z  by CorePrep, but only if f still
        --      has its strictness info.
        --
        -- Similarly for the demand info - on a let binder, this tells
        -- CorePrep to turn the let into a case.
        -- But: Remove the usage demand here
        --      (See Note [Zapping DmdEnv after Demand Analyzer] in GHC.Core.Opt.WorkWrap)
        --
        -- Similarly arity info for eta expansion in CorePrep
        -- Don't attempt to recompute arity here; this is just tidying!
        -- Trying to do so led to #17294
        --
        -- Set inline-prag info so that we preserve it across
        -- separate compilation boundaries
        old_info = idInfo id
        new_info = vanillaIdInfo
                    `setOccInfo`        occInfo old_info
                    `setArityInfo`      arityInfo old_info
                    `setDmdSigInfo`     zapDmdEnvSig (dmdSigInfo old_info)
                    `setDemandInfo`     demandInfo old_info
                    `setInlinePragInfo` inlinePragInfo old_info
                    `setUnfoldingInfo`  new_unf

        old_unf = realUnfoldingInfo old_info
        new_unf = tidyNestedUnfolding rec_tidy_env old_unf

    in
    ((tidy_env', var_env'), id') }

------------ Unfolding  --------------
tidyNestedUnfolding :: TidyEnv -> Unfolding -> Unfolding
tidyNestedUnfolding _ NoUnfolding   = NoUnfolding
tidyNestedUnfolding _ BootUnfolding = BootUnfolding
tidyNestedUnfolding _ (OtherCon {}) = evaldUnfolding

tidyNestedUnfolding tidy_env df@(DFunUnfolding { df_bndrs = bndrs, df_args = args })
  = df { df_bndrs = bndrs', df_args = map (tidyExpr tidy_env') args }
  where
    (tidy_env', bndrs') = tidyBndrs tidy_env bndrs

tidyNestedUnfolding tidy_env
    unf@(CoreUnfolding { uf_tmpl = unf_rhs, uf_src = src, uf_cache = cache })
  | isStableSource src
  = seqIt $ unf { uf_tmpl = tidyExpr tidy_env unf_rhs }    -- Preserves OccInfo
            -- This seqIt avoids a space leak: otherwise the uf_cache
            -- field may retain a reference to the pre-tidied
            -- expression forever (GHC.CoreToIface doesn't look at
            -- them)

  -- Discard unstable unfoldings, but see Note [Preserve evaluatedness]
  | uf_is_value cache = evaldUnfolding
  | otherwise = noUnfolding

  where
    seqIt unf = seqUnfolding unf `seq` unf

{-
Note [Tidy IdInfo]
~~~~~~~~~~~~~~~~~~
All nested Ids now have the same IdInfo, namely vanillaIdInfo, which
should save some space; except that we preserve occurrence info for
two reasons:

  (a) To make printing tidy core nicer

  (b) Because we tidy RULES and unfoldings, which may then propagate
      via --make into the compilation of the next module, and we want
      the benefit of that occurrence analysis when we use the rule or
      or inline the function.  In particular, it's vital not to lose
      loop-breaker info, else we get an infinite inlining loop

Note that tidyLetBndr puts more IdInfo back.

Note [Preserve evaluatedness]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Consider
  data T = MkT !Bool
  ....(case v of MkT y ->
       let z# = case y of
                  True -> 1#
                  False -> 2#
       in ...)

The z# binding is ok because the RHS is ok-for-speculation,
but Lint will complain unless it can *see* that.  So we
preserve the evaluated-ness on 'y' in tidyBndr.

(Another alternative would be to tidy unboxed lets into cases,
but that seems more indirect and surprising.)

Note [Preserve OneShotInfo]
~~~~~~~~~~~~~~~~~~~~~~~~~~~
We keep the OneShotInfo because we want it to propagate into the interface.
Not all OneShotInfo is determined by a compiler analysis; some is added by a
call of GHC.Exts.oneShot, which is then discarded before the end of the
optimisation pipeline, leaving only the OneShotInfo on the lambda. Hence we
must preserve this info in inlinings. See Note [oneShot magic] in GHC.Types.Id.Make.

This applies to lambda binders only, hence it is stored in IfaceLamBndr.
-}

(=:) :: a -> (a -> b) -> b
m =: k = m `seq` k m
