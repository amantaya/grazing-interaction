test_that("3-letter site code collection folders parse", {

df <- data.frame(
  site_code = "WCT",
  collection_folder = "WCT_05152018_06112018"
)
  expect_equal(extract_sitecode_from_collection_folder(collection_folder = "WCT_05152018_06112018"), df)
})

test_that("5-letter site code collection folders parse", {

  df <- data.frame(
    site_code = "BUT12",
    collection_folder = "BUT12_20210527_20210622"
  )
  expect_equal(extract_sitecode_from_collection_folder(collection_folder = "BUT12_20210527_20210622"), df)
})

test_that("1-letter and 2 digit site code collection folders parse", {

  df <- data.frame(
    site_code = "A51",
    collection_folder = "A51_05282021_06222021"
  )
  expect_equal(extract_sitecode_from_collection_folder(collection_folder = "A51_05282021_06222021"), df)
})

test_that("3-letter and '5_min' site code collection folders parse", {

  df <- data.frame(
    site_code = "WCS_5min",
    collection_folder = "WCS_5min_05212019_06032019"
  )
  expect_equal(extract_sitecode_from_collection_folder(collection_folder = "WCS_5min_05212019_06032019"), df)
})

test_that("3-digit site code collection folders return NA", {

  df <- data.frame(
    site_code = NA_character_,
    collection_folder = "123_05212019_06032019"
  )
  expect_equal(extract_sitecode_from_collection_folder(collection_folder = "123_05212019_06032019"), df)
})

test_that("3-letter site code return correct path", {

  df <- data.frame(
    site_code = "WCS"
  )

  df2 <- data.frame(
    site_code = "WCS",
    site_folder = "G:/cameratraps/wildcat/timelapsesouth"
  )
  expect_equal(site_folder_from_sitecode(df, path = "G:"), df2)
})

test_that("5-letter site code return correct path", {

  df <- data.frame(
    site_code = "SHT11"
  )

  df2 <- data.frame(
    site_code = "SHT11",
    site_folder = "G:/cameratraps2/SHT11"
  )
  expect_equal(site_folder_from_sitecode(df, path = "G:"), df2)
})

test_that("1-letter and 2 digit site code return correct path", {

  df <- data.frame(
    site_code = "A51"
  )
  df2 <- data.frame(
    site_code = "A51",
    site_folder = "G:/cameratraps/fiftyone/timelapse"
  )
  expect_equal(site_folder_from_sitecode(df, path = "G:"), df2)
})

test_that("3-letter and '5_min' site code return correct path", {

  df <- data.frame(
    site_code = "BGW_5min"
  )
  df2 <- data.frame(
    site_code = "BGW_5min",
    site_folder = "G:/cameratraps/boggy/timelapse5min"
  )
  expect_equal(site_folder_from_sitecode(df, path = "G:"), df2)
})

test_that("0 subject folders to match print message", {

  df <- NULL

  df2 <- "There a 0 Folders to Match Subject Photos"

  expect_output(site_folder_from_sitecode(df, path = "G:"), df2)
})

test_that("file paths form correctly when combining site and collection folders", {

  df <- data.frame(
    site_code = "BUO23",
    collection_folder = "BUO23_20210525_20210624",
    site_folder = "G:/cameratraps2/BUO23"
  )
  df2 <- data.frame(
    site_code = "BUO23",
    collection_folder = "BUO23_20210525_20210624",
    site_folder = "G:/cameratraps2/BUO23",
    path = "G:/cameratraps2/BUO23/BUO23_20210525_20210624"
  )
  expect_equal(construct_path_from_collection_and_site_folders(df), df2)
})
