test_that("replaces parts of the subject text file path with the correct file path", {
  df <- data.frame(
    path = "D:/BUO01/BUO01_20210625_20210723/100EK113/2021-06-25-11-22-42.JPG"
  )

  df2 <- data.frame(
    collection_folder = "BUO01_20210625_20210723",
    sub_folder = "100EK113",
    file_name = "2021-06-25-11-22-42.JPG",
    path = "G:/cameratraps2/BUO01/BUO01_20210625_20210723/100EK113/2021-06-25-11-22-42.JPG"
  )

  cameratraps_folders_to_match <- data.frame(
    site_code = "BUO01",
    collection_folder = "BUO01_20210625_20210723",
    site_folder = "G:/cameratraps2/BUO01",
    path = "G:/cameratraps2/BUO01/BUO01_20210625_20210723"
  )

  expect_equal(
    subject_text_files_to_cameratraps_path(
      df,
      cameratraps_folders_to_match
    ),
    df2
  )
})
