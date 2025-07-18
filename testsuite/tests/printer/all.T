req_ppr_deps = req_hadrian_deps(['test:check-ppr','test:check-exact'])

test('Ppr001', [ignore_stderr,req_ppr_deps], makefile_test, ['ppr001'])
test('Ppr002', [ignore_stderr,req_ppr_deps], makefile_test, ['ppr002'])
test('Ppr002a', [ignore_stderr,req_ppr_deps], makefile_test, ['ppr002a'])
test('Ppr003', [ignore_stderr,req_ppr_deps], makefile_test, ['ppr003'])
test('Ppr004', [ignore_stderr,req_ppr_deps], makefile_test, ['ppr004'])
test('Ppr005', [ignore_stderr,req_ppr_deps], makefile_test, ['ppr005'])
test('Ppr006', [ignore_stderr,req_ppr_deps], makefile_test, ['ppr006'])
test('Ppr007', [ignore_stderr,req_ppr_deps], makefile_test, ['ppr007'])

# These tests have CPP, and as of 2021-03-15 the processing on the
# darwin and windows platforms is slightly different.
#test('Ppr008', [ignore_stderr,expect_fail,req_ppr_deps], makefile_test, ['ppr008'])
#test('Ppr010', [ignore_stderr,expect_fail,req_ppr_deps], makefile_test, ['ppr010'])

test('Ppr009', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr009'])
test('Ppr011', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr011'])
test('Ppr012', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr012'])
test('Ppr013', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr013'])
test('Ppr014', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr014'])
test('Ppr015', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr015'])
test('Ppr016', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr016'])
test('Ppr017', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr017'])
test('Ppr018', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr018'])
test('Ppr019', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr019'])
test('Ppr020', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr020'])
test('Ppr021', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr021'])
test('Ppr022', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr022'])
test('Ppr023', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr023'])
test('Ppr024', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr024'])
test('Ppr025', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr025'])
test('Ppr026', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr026'])
test('Ppr027', [ignore_stderr, req_th,req_ppr_deps], makefile_test, ['ppr027'])
test('Ppr028', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr028'])
test('Ppr029', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr029'])
test('Ppr030', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr030'])
test('Ppr031', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr031'])
test('Ppr032', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr032'])
test('Ppr033', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr033'])
test('Ppr034', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr034'])
test('Ppr035', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr035'])
test('Ppr036', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr036'])
test('Ppr037', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr037'])
test('Ppr038', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr038'])
test('Ppr039', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr039'])
test('Ppr040', [ignore_stderr, req_th,req_ppr_deps], makefile_test, ['ppr040'])
test('Ppr041', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr041'])
test('Ppr042', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr042'])
test('Ppr043', [ignore_stderr, req_th,req_ppr_deps], makefile_test, ['ppr043'])
test('Ppr044', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr044'])
test('Ppr045', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr045'])
test('Ppr046', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr046'])
test('Ppr048', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr048'])
test('Ppr049', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr049'])
test('Ppr050', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr050'])
test('Ppr051', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr051'])
test('Ppr052', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr052'])
test('Ppr053', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr053'])
test('Ppr054', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr054'])
test('Ppr055', [ignore_stderr, req_ppr_deps], makefile_test, ['ppr055'])
test('T13050p', [ignore_stderr, req_ppr_deps], makefile_test, ['T13050p'])
test('T13199', [ignore_stderr, req_th,req_ppr_deps], makefile_test, ['T13199'])
test('T13550', [ignore_stderr, req_th,req_ppr_deps], makefile_test, ['T13550'])
test('T13942', [ignore_stderr, req_th,req_ppr_deps], makefile_test, ['T13942'])
test('T14289', [ignore_stderr, req_th,req_ppr_deps], makefile_test, ['T14289'])
test('T14289b', [ignore_stderr, req_th,req_ppr_deps], makefile_test, ['T14289b'])
test('T14289c', [ignore_stderr, req_th,req_ppr_deps], makefile_test, ['T14289c'])
test('T14306', [ignore_stderr, req_ppr_deps], makefile_test, ['T14306'])
test('T14343', normal, compile_fail, [''])
test('T14343b', normal, compile_fail, [''])
test('T15761', normal, compile_fail, [''])
test('T17697', normal, compile, [''])
test('T18052a', normalise_version('ghc-internal', 'base'), compile,
     ['-ddump-simpl -ddump-types -dno-typeable-binds -dsuppress-uniques'])
test('T18791', normal, compile, ['-ddump-parsed-ast'])
test('RdrNames', [ignore_stderr, req_ppr_deps], makefile_test, ['RdrNames'])
test('StarBinderAnns', [ignore_stderr, req_ppr_deps], makefile_test, ['StarBinderAnns'])
test('Test10255', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10255'])
test('Test10268', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10268'])
test('Test10269', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10269'])
test('Test10276', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10276'])
test('Test10278', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10278'])
test('Test10280', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10280'])
test('Test10307', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10307'])
test('Test10309', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10309'])
test('Test10312', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10312'])
test('Test10313', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10313'])
test('Test10354', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10354'])
test('Test10357', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10357'])
test('Test10358', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10358'])
test('Test10396', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10396'])
test('Test10399', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10399'])
test('Test10598', [ignore_stderr, req_ppr_deps], makefile_test, ['Test10598'])

# PPR of unicode -> does not roundtrip. See #18846
test('Test11018', [ignore_stderr,expect_fail,req_ppr_deps], makefile_test, ['Test11018'])
test('Test17519', [ignore_stderr,expect_fail,req_ppr_deps], makefile_test, ['Test17519'])

test('Test11321', [ignore_stderr, req_ppr_deps], makefile_test, ['Test11321'])
test('Test11332', [ignore_stderr, req_ppr_deps], makefile_test, ['Test11332'])

test('Test11430', [ignore_stderr, req_ppr_deps], makefile_test, ['Test11430'])
test('Test12417', [ignore_stderr, req_ppr_deps], makefile_test, ['Test12417'])
test('Test13163', [ignore_stderr, req_ppr_deps], makefile_test, ['Test13163'])
test('Test15303', [ignore_stderr, req_ppr_deps], makefile_test, ['Test15303'])
test('Test16212', [ignore_stderr, req_ppr_deps], makefile_test, ['Test16212'])
test('Test16230', [ignore_stderr, req_ppr_deps], makefile_test, ['Test16230'])
test('Test16236', [ignore_stderr, req_ppr_deps], makefile_test, ['Test16236'])
test('Test16279', [ignore_stderr, req_ppr_deps], makefile_test, ['Test16279'])
test('Test17388', [ignore_stderr, req_ppr_deps], makefile_test, ['Test17388'])
test('Test15242', [ignore_stderr, req_ppr_deps], makefile_test, ['Test15242'])
test('AnnotationLet', [ignore_stderr, req_ppr_deps], makefile_test, ['AnnotationLet'])
test('TestBoolFormula', [ignore_stderr, req_ppr_deps], makefile_test, ['TestBoolFormula'])
test('BundleExport', [ignore_stderr, req_ppr_deps], makefile_test, ['BundleExport'])
test('AnnotationTuple', [ignore_stderr, req_ppr_deps], makefile_test, ['AnnotationTuple'])
test('ListComprehensions', [ignore_stderr, req_ppr_deps], makefile_test, ['ListComprehensions'])
test('load-main', [ignore_stderr, req_ppr_deps], makefile_test, ['load-main'])

test('PprRecordDotSyntax1', [ignore_stderr, req_ppr_deps], makefile_test, ['PprRecordDotSyntax1'])
test('PprRecordDotSyntax2', [ignore_stderr, req_ppr_deps], makefile_test, ['PprRecordDotSyntax2'])
test('PprRecordDotSyntax3', [ignore_stderr, req_ppr_deps], makefile_test, ['PprRecordDotSyntax3'])
test('PprRecordDotSyntax4', [ignore_stderr, req_ppr_deps], makefile_test, ['PprRecordDotSyntax4'])
test('PprRecordDotSyntaxA', [ignore_stderr, req_ppr_deps], makefile_test, ['PprRecordDotSyntaxA'])
test('CommentsTest', [ignore_stderr, req_ppr_deps], makefile_test, ['CommentsTest'])
test('InTreeAnnotations1', [ignore_stderr, req_ppr_deps], makefile_test, ['InTreeAnnotations1'])


# Normal ppr does not reproduce unicode linear arrows, commented out
# in the Makefile for this test. See #18846
test('PprLinearArrow', [ignore_stderr, req_ppr_deps], makefile_test, ['PprLinearArrow'])

test('Test19784', [ignore_stderr, req_ppr_deps], makefile_test, ['Test19784'])
test('Test19798', [ignore_stderr, req_ppr_deps], makefile_test, ['Test19798'])

# The exact printing manages the extra semicolons, normal ppr not, so
# disabled in the Makefile for this test.
test('Test19813', [ignore_stderr, req_ppr_deps], makefile_test, ['Test19813'])

test('Test19814', [ignore_stderr, req_ppr_deps], makefile_test, ['Test19814'])
test('Test19821', [ignore_stderr, req_ppr_deps], makefile_test, ['Test19821'])
test('Test19834', [ignore_stderr, req_ppr_deps], makefile_test, ['Test19834'])
test('Test19839', [ignore_stderr, req_ppr_deps], makefile_test, ['Test19839'])
test('Test19840', [ignore_stderr, req_ppr_deps], makefile_test, ['Test19840'])
test('Test19850', [ignore_stderr, req_ppr_deps], makefile_test, ['Test19850'])
test('PprCommentsOnly', [ignore_stderr, req_ppr_deps], makefile_test, ['PprCommentsOnly'])
test('PprSemis', [ignore_stderr, req_ppr_deps], makefile_test, ['PprSemis'])

# Normal ppr does not reproduce all foreign decls, commented out
# in the Makefile for this test.
test('PprForeignDecl', [ignore_stderr, req_ppr_deps], makefile_test, ['PprForeignDecl'])

test('PprRoles', [ignore_stderr, req_ppr_deps], makefile_test, ['PprRoles'])
test('PprTypeSynParens', [ignore_stderr, req_ppr_deps], makefile_test, ['PprTypeSynParens'])
test('PprEmptyMostlyInst', [ignore_stderr, req_ppr_deps], makefile_test, ['PprEmptyMostlyInst'])
test('PprParenFunBind', [ignore_stderr, req_ppr_deps], makefile_test, ['PprParenFunBind'])
test('PprRecordSemi', [ignore_stderr, req_ppr_deps], makefile_test, ['PprRecordSemi'])
test('PprCompleteSig', [ignore_stderr, req_ppr_deps], makefile_test, ['PprCompleteSig'])
test('PprOverloadedLabels', [ignore_stderr, req_ppr_deps], makefile_test, ['PprOverloadedLabels'])
test('PprArrows', [ignore_stderr, req_ppr_deps], makefile_test, ['PprArrows'])
test('PprOverloadedRecords', [ignore_stderr, req_ppr_deps], makefile_test, ['PprOverloadedRecords'])
test('PprArrowLambdaCase', [ignore_stderr, req_ppr_deps], makefile_test, ['PprArrowLambdaCase'])
test('PprRecursiveDo', [ignore_stderr, req_ppr_deps], makefile_test, ['PprRecursiveDo'])
test('PprTypeBrackets', [ignore_stderr, req_ppr_deps], makefile_test, ['PprTypeBrackets'])
test('PprDynamic', [ignore_stderr, req_ppr_deps], makefile_test, ['PprDynamic'])
test('PprEmptyMostly', [ignore_stderr, req_ppr_deps], makefile_test, ['PprEmptyMostly'])
test('PprClassParens', [ignore_stderr, req_ppr_deps], makefile_test, ['PprClassParens'])
test('PprThAbstractFamily', [ignore_stderr, req_ppr_deps], makefile_test, ['PprThAbstractFamily'])
test('PprClassTypeFamily', [ignore_stderr, req_ppr_deps], makefile_test, ['PprClassTypeFamily'])
test('PprT13747', [ignore_stderr, req_ppr_deps], makefile_test, ['PprT13747'])
test('PprBracesSemiDataDecl', [ignore_stderr, req_ppr_deps], makefile_test, ['PprBracesSemiDataDecl'])
test('PprUnicodeSyntax', [ignore_stderr, req_ppr_deps], makefile_test, ['PprUnicodeSyntax'])
test('PprCommentPlacement2', [ignore_stderr, req_ppr_deps], makefile_test, ['PprCommentPlacement2'])
test('PprOrPat', [ignore_stderr, req_ppr_deps], makefile_test, ['PprOrPat'])
test('PprExportWarn', [ignore_stderr, req_ppr_deps], makefile_test, ['PprExportWarn'])
test('PprInstanceWarn', [ignore_stderr, req_ppr_deps], makefile_test, ['PprInstanceWarn'])

test('Test20243', [ignore_stderr, req_ppr_deps], makefile_test, ['Test20243'])
test('Test20247', [ignore_stderr, req_ppr_deps], makefile_test, ['Test20247'])
test('Test20256', [ignore_stderr, req_ppr_deps], makefile_test, ['Test20256'])
test('Test20258', [ignore_stderr, req_ppr_deps], makefile_test, ['Test20258'])
test('Test20297', [ignore_stderr, req_ppr_deps], makefile_test, ['Test20297'])
test('Test20315', normal, compile_fail, [''])
test('Test20846', [ignore_stderr, req_ppr_deps], makefile_test, ['Test20846'])
test('Test21355', [ignore_stderr, req_ppr_deps], makefile_test, ['Test21355'])
test('Test21805', [ignore_stderr, req_ppr_deps], makefile_test, ['Test21805'])

test('T22488', normal, ghci_script, ['T22488.script'])
test('T22488_docHead', normal, compile_and_run, ['-package ghc'])
test('T20531', extra_files(['T20531_defs.hs']), ghci_script, ['T20531.script'])
test('T20531_red_ticks', extra_files(['T20531_defs.hs']), ghci_script, ['T20531_red_ticks.script'])
test('HsDocTy', [ignore_stderr, req_ppr_deps], makefile_test, ['HsDocTy'])
test('Test22765', [ignore_stderr, req_ppr_deps], makefile_test, ['Test22765'])
test('Test22771', [ignore_stderr, req_ppr_deps], makefile_test, ['Test22771'])
test('Test23465', [ignore_stderr, req_ppr_deps], makefile_test, ['Test23465'])
test('Test23887', [ignore_stderr, req_ppr_deps], makefile_test, ['Test23887'])
test('Test23885', [ignore_stderr, req_ppr_deps], makefile_test, ['Test23885'])
test('ListTuplePuns', extra_files(['ListTuplePuns.hs']), ghci_script, ['ListTuplePuns.script'])
test('AnnotationNoListTuplePuns', [ignore_stderr, req_ppr_deps], makefile_test, ['AnnotationNoListTuplePuns'])
test('Test24533', [ignore_stderr, req_ppr_deps], makefile_test, ['Test24533'])
test('PprLetIn', [ignore_stderr, req_ppr_deps], makefile_test, ['PprLetIn'])
test('CaseAltComments', [ignore_stderr, req_ppr_deps], makefile_test, ['CaseAltComments'])
test('MatchPatComments', [ignore_stderr, req_ppr_deps], makefile_test, ['MatchPatComments'])
test('Test24748', [ignore_stderr, req_ppr_deps], makefile_test, ['Test24748'])
test('DataDeclShort', [ignore_stderr, req_ppr_deps], makefile_test, ['DataDeclShort'])
test('Test24749', [ignore_stderr, req_ppr_deps], makefile_test, ['Test24749'])
test('Test24754', [ignore_stderr, req_ppr_deps], makefile_test, ['Test24754'])
test('Test24755', [ignore_stderr, req_ppr_deps], makefile_test, ['Test24755'])
test('Test24753', [ignore_stderr, req_ppr_deps], makefile_test, ['Test24753'])
test('Test24771', [ignore_stderr, req_ppr_deps], makefile_test, ['Test24771'])
test('Test24159', [ignore_stderr, req_ppr_deps], makefile_test, ['Test24159'])
test('Test25132', [ignore_stderr, req_ppr_deps], makefile_test, ['Test25132'])
test('Test25467', [ignore_stderr, req_ppr_deps], makefile_test, ['Test25467'])

test('T24237', normal, compile_fail, [''])

test('Test25454', [ignore_stderr, req_ppr_deps], makefile_test, ['Test25454'])
test('Test25885', [ignore_stderr, req_ppr_deps], makefile_test, ['Test25885'])

test('TestLevelImports', [ignore_stderr, req_ppr_deps], makefile_test, ['TestLevelImports'])
test('TestNamedDefaults', [ignore_stderr, req_ppr_deps], makefile_test, ['TestNamedDefaults'])