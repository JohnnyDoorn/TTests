context("One Sample TTest")

# does not test
# - missing values exclusion
# - error handling of plots

test_that("Main table results match for t-test", {
  options <- jaspTools::analysisOptions("TTestOneSample")
  options$variables <- "contGamma"
  options$meanDifference <- TRUE
  options$effectSize <- TRUE
  options$VovkSellkeMPR <- TRUE
  results <- jaspTools::runAnalysis("TTestOneSample", "test.csv", options)
  table <- results[["results"]][["ttest"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list("FALSE", 6.42284229078859e+20, 1.32664189226908, 99, 2.03296079621,
	       1.08315413981152e-23, 13.2664189226908, "contGamma")
  )
})

test_that("Main table results match for Wilcoxon signed rank", {
  options <- jaspTools::analysisOptions("TTestOneSample")
  options$variables <- "contNormal"
  options$meanDifference <- TRUE
  options$effectSize <- TRUE
  options$effSizeConfidenceIntervalCheckbox <- TRUE
  options$students <- FALSE
  options$mannWhitneyU <- TRUE

  results <- jaspTools::runAnalysis("TTestOneSample", "test.csv", options)
  table <- results[["results"]][["ttest"]][["data"]]

  jaspTools::expect_equal_tables(table,
                      list("FALSE", 1789, -0.291485148514852, -0.482275183604466, -0.225731139327267,
	                         0.0114424559827519, -0.0742951335226289, "contNormal"))
})

test_that("Main table results match for Z-test", {
  options <- jaspTools::analysisOptions("TTestOneSample")
  options$variables <- "contNormal"
  options$students <- FALSE
  options$zTest <- TRUE
  options$stddev <- 1.5
  options$effectSize <- TRUE
  options$effSizeConfidenceIntervalCheckbox <- TRUE
  results <- jaspTools::runAnalysis("TTestOneSample", "test.csv", options)
  table <- results[["results"]][["ttest"]][["data"]]
  jaspTools::expect_equal_tables(table,
                      list("FALSE", -1.25832391693333, -0.125832391693333, -0.321828790147339,
	                         0.208274634966236, 0.070164006760672, "contNormal")
                      )
})

test_that("Normality table matches", {
  options <- jaspTools::analysisOptions("TTestOneSample")
  options$variables <- "contGamma"
  options$normalityTests <- TRUE
  results <- jaspTools::runAnalysis("TTestOneSample", "test.csv", options)
  table <- results[["results"]][["AssumptionChecks"]][["collection"]][["AssumptionChecks_ttestNormalTable"]][["data"]]
  jaspTools::expect_equal_tables(table, list(0.876749741598208, 1.32551553117109e-07, "contGamma"))
})

test_that("Descriptives table matches", {
  options <- jaspTools::analysisOptions("TTestOneSample")
  options$variables <- "contGamma"
  options$descriptives <- TRUE
  results <- jaspTools::runAnalysis("TTestOneSample", "test.csv", options)
  table <- results[["results"]][["ttestDescriptives"]][["collection"]][["ttestDescriptives_table"]][["data"]]
  jaspTools::expect_equal_tables(table,
    list("contGamma", 100, 2.03296079621, 1.53241112621044, 0.153241112621044)
  )
})

test_that("Descriptives plot matches", {
  options <- jaspTools::analysisOptions("TTestOneSample")
  options$variables <- "contGamma"
  options$descriptivesPlots <- TRUE
  results <- jaspTools::runAnalysis("TTestOneSample", "test.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "descriptives", dir="TTestOneSample")
})

test_that("Raincloud plot matches (vertical)", {
  options <- jaspTools::analysisOptions("TTestOneSample")
  options$variables <- "contGamma"
  options$descriptivesPlotsRainCloud <- TRUE
  set.seed(12312414)
  results <- jaspTools::runAnalysis("TTestOneSample", "test.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "raincloud-vertical", dir="TTestOneSample")
})

test_that("Raincloud plot matches (horizontal)", {
  options <- jaspTools::analysisOptions("TTestOneSample")
  options$variables <- "contGamma"
  options$descriptivesPlotsRainCloud <- TRUE
  options$descriptivesPlotsRainCloudHorizontalDisplay <- TRUE
  set.seed(12312414)
  results <- jaspTools::runAnalysis("TTestOneSample", "test.csv", options)
  testPlot <- results[["state"]][["figures"]][[1]][["obj"]]
  jaspTools::expect_equal_plots(testPlot, "raincloud-horizontal", dir="TTestOneSample")
})

test_that("Analysis handles errors", {
  options <- jaspTools::analysisOptions("TTestOneSample")
  
  options$variables <- "debInf"
  results <- jaspTools::runAnalysis("TTestOneSample", "test.csv", options)
  notes <- unlist(results[["results"]][["ttest"]][["footnotes"]])
  expect_true(any(grepl("infinity", notes, ignore.case=TRUE)), label = "Inf check")
  
  options$variables <- "debSame"
  results <- jaspTools::runAnalysis("TTestOneSample", "test.csv", options)
  notes <- unlist(results[["results"]][["ttest"]][["footnotes"]])
  expect_true(any(grepl("variance", notes, ignore.case=TRUE)), label = "No variance check")
  
  options$variables <- "debMiss99"
  results <- jaspTools::runAnalysis("TTestOneSample", "test.csv", options)
  notes <- unlist(results[["results"]][["ttest"]][["footnotes"]])
  expect_true(any(grepl("observations", notes, ignore.case=TRUE)), label = "Too few obs check")
})