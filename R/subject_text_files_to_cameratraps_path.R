#' Construct a Path to Subject Photos in a Collection Folder
#'
#' @description `subject_text_files_to_cameratraps_path()` creates a path to
#'   each subject photo in a collection folder by extracting the collection
#'   folder, image sub-folder, and file name from a subject text file.
#'
#' @param subject_txt_df A data frame with a column named `path` that is a file
#'   path to a subject photo in within a collection folder.
#'
#' @param cameratraps_folder A data frame with columns named `collection_folder`,
#' `sub_folder`, `file_name`, and `path`.
#'
#' @return Returns a data frame with columns named `collection_folder`,
#'   `sub_folder`, `file_name` and `path`.
#'
#'   * `collection_folder` corresponds to all photos collected from an SD card,
#'      e.g. BGW_5min_06042019_06112019.
#'   * `sub_folder` corresponds to the sub-folder created by the cameratrap,
#'      e.g. 100EK113.
#'   * `file_name` corresponds to the file name of the photo/image.
#'   * `path` corresponds to the file path to the image.
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr relocate
#' @importFrom stringr str_extract
#' @importFrom magrittr %>%
#'
#' @examples
#' library(GrazingCameratraps)
#' subject_txt_df <-
#' data.frame(
#'   path = "D:/BUO01/BUO01_20210625_20210723/100EK113/2021-06-25-11-22-42.JPG"
#'   )
#'
#' cameratraps_folder <-
#' data.frame(
#'   collection_folder = "BUO01_20210625_20210723",
#'   sub_folder = "100EK113",
#'   file_name = "2021-06-25-11-22-42.JPG",
#'   path = "G:/cameratraps2/BUO01/BUO01_20210625_20210723/100EK113/2021-06-25-11-22-42.JPG"
#'   )
#' subject_text_files_to_cameratraps_path(subject_txt_df, cameratraps_folder)
#'
#' @export
subject_text_files_to_cameratraps_path <- function(subject_txt_df,
                                                   cameratraps_folder) {
  # create a series of regular expressions to extract parts of the filepath
  # matches WCS_04192019_05212019
  # matches A51_05282021_06222021
  # matches WCS_5min_04192019_05212019
  # matches KPT16_20210527_20210622
  collection_folder_regex <-
    "([[:upper:]]{3}_\\d{8}_\\d{8})|([[:upper:]]\\d{2}_\\d{8}_\\d{8})|([[:upper:]]{3}_5min_\\d{8}_\\d{8})|([[:upper:]]{3}\\d{2}_\\d{8}_\\d{8})" # nolint: line_length_linter

  # create a regular expression to match the subfolder
  # matches 100EK113
  subfolder_regex <- "\\d{3}\\EK\\d{3}"

  subject_txt_df %>%
    dplyr::mutate(
      collection_folder =
        stringr::str_extract(subject_txt_df$path, collection_folder_regex)
    ) %>%
    dplyr::mutate(
      sub_folder =
        stringr::str_extract(subject_txt_df$path, subfolder_regex)
    ) %>%
    dplyr::mutate(
      file_name = basename(subject_txt_df$path)
    ) %>%
    dplyr::mutate(
      path =
        file.path(
          cameratraps_folder$path[1],
          sub_folder,
          file_name
        )
    ) %>%
    dplyr::relocate(
      collection_folder,
      sub_folder,
      file_name,
      path
    )
}
