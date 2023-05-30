#' subject_text_files_to_cameratraps_path
#'
#' @description
#' A short description...
#'
#' @param subject_txt_df
#'
#' @return Returns a data frame with the
#' @export
#'
#' @examples
subject_text_files_to_cameratraps_path <- function(subject_txt_df, cameratraps_folders_to_match_df) {
  # create a series of regular expressions to extract parts of the filepath
  # matches WCS_04192019_05212019
  # matches A51_05282021_06222021
  # WCS_5min_04192019_05212019
  # KPT16_20210527_20210622
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
          cameratraps_folders_to_match_df$path[1],
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
