#' Extract Site Code from Collection Folder
#'
#' @description `extract_site_code_from_collection_folder()` extracts the site
#' code based on the prefix of a collection folder and returns a data frame with
#' `site_code` and `collection_folder` columns.
#'
#' @param collection_folder Input character vector. This character vector should
#'   corresponding to a collection folder or multiple collection folders. This
#'   character vector must can be named either with 3-letters, 1 letter and
#'   2-digits, or 3-letters and 2-digits. All prefixs must be followed by 8
#'   digits corresponding to the deployment date and 8 digits corresponding to
#'   the date of the last photo in the collection or the date the photos were
#'   collected from the camera.
#'
#' @return A data frame with a `site_code` column and a `collection_folder`
#'   column.
#'
#' @examples
#' extract_site_code_from_collection_folder("WCS_04192019_05212019")
#'
#' @export
extract_site_folder_from_site_code <-
  function(collection_folder) {
    if (length(collection_folder) == 0) {
      sitecode_df <- NULL
    } else {
      sitecode_df <-
        data.frame(
          "site_code" =
            stringr::str_extract(
              string = collection_folder,
              pattern = "[[:upper:]]{3}(?=_\\d{8})|[[:upper:]]\\d{2}(?=_\\d{8})|[[:upper:]]{3}_5min(?=_\\d{8})|[[:upper:]][[:upper:]][[:upper:]]\\d\\d(?=_\\d{8})"
            ),
          "collection_folder" = collection_folder
        )
      return(sitecode_df)
    }
  }

#' site_folder_from_sitecode
#'
#' @param sitecode_df
#' @param path
#'
#' @return
#' @export
#'
#' @examples
site_folder_from_sitecode <- function(sitecode_df, path) {
  if (is.null(sitecode_df) == TRUE) {
    stop("There are 0 Remaining Folders to Process on the Project Board")
  } else {
    # matching on the first three letters to construct file paths
    for (i in seq_len(nrow(sitecode_df))) {
      if (sitecode_df$site_code[i] == "BRL") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "bear", "timelapse")
      } else if (sitecode_df$site_code[i] == "BRT") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "bear", "trail")
      } else if (sitecode_df$site_code[i] == "BFD") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "bigfield", "timelapse")
      } else if (sitecode_df$site_code[i] == "BKD") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "blackcanyon", "timelapsedam")
      } else if (sitecode_df$site_code[i] == "BKN") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "blackcanyon", "timelapsenorth")
      } else if (sitecode_df$site_code[i] == "BKS") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "blackcanyon", "timelapsesouth")
      } else if (sitecode_df$site_code[i] == "BKT") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "blackcanyon", "trail")
      } else if (sitecode_df$site_code[i] == "BGX") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "boggy", "exclosure")
      } else if (sitecode_df$site_code[i] == "BGW_5min") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "boggy", "timelapse5min")
      } else if (sitecode_df$site_code[i] == "BGE") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "boggy", "timelapseeast")
      } else if (sitecode_df$site_code[i] == "BGW") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "boggy", "timelapsewest")
      } else if (sitecode_df$site_code[i] == "BGT") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "boggy", "trail")
      } else if (sitecode_df$site_code[i] == "EFK") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "eastfork", "timelapse")
      } else if (sitecode_df$site_code[i] == "A51") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "fiftyone", "timelapse")
      } else if (sitecode_df$site_code[i] == "FLO") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "firelookout", "timelapse")
      } else if (sitecode_df$site_code[i] == "HWY") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "highway", "timelapse")
      } else if (sitecode_df$site_code[i] == "HPL") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "holdingpasture", "timelapse")
      } else if (sitecode_df$site_code[i] == "MAD") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "mauldin", "phenocam")
      } else if (sitecode_df$site_code[i] == "OPO") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "onlyponderosa", "timelapse")
      } else if (sitecode_df$site_code[i] == "WCX") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "wildcat", "exclosure")
      } else if (sitecode_df$site_code[i] == "WCS_5min") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "wildcat", "timelapse5min")
      } else if (sitecode_df$site_code[i] == "WCN") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "wildcat", "timelapsenorth")
      } else if (sitecode_df$site_code[i] == "WCS") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "wildcat", "timelapsesouth")
      } else if (sitecode_df$site_code[i] == "WCT") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps", "wildcat", "trail")
      } else if (sitecode_df$site_code[i] == "BUO01") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "BUO01")
      } else if (sitecode_df$site_code[i] == "BUO07") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "BUO07")
      } else if (sitecode_df$site_code[i] == "BUO23") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "BUO23")
      } else if (sitecode_df$site_code[i] == "BUO29") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "BUO29")
      } else if (sitecode_df$site_code[i] == "BUT12") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "BUT12")
      } else if (sitecode_df$site_code[i] == "BUT19") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "BUT19")
      } else if (sitecode_df$site_code[i] == "GEO02") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "GEO02")
      } else if (sitecode_df$site_code[i] == "GEO30") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "GEO30")
      } else if (sitecode_df$site_code[i] == "GEO32") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "GEO32")
      } else if (sitecode_df$site_code[i] == "GET01") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "GET01")
      } else if (sitecode_df$site_code[i] == "GET06") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "GET06")
      } else if (sitecode_df$site_code[i] == "GET13") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "GET13")
      } else if (sitecode_df$site_code[i] == "GET21") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "GET21")
      } else if (sitecode_df$site_code[i] == "GET22") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "GET22")
      } else if (sitecode_df$site_code[i] == "KPT14") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "KPT14")
      } else if (sitecode_df$site_code[i] == "KPT16") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "KPT16")
      } else if (sitecode_df$site_code[i] == "KPT27") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "KPT27")
      } else if (sitecode_df$site_code[i] == "SHT11") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "SHT11")
      } else if (sitecode_df$site_code[i] == "SHT15") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "SHT15")
      } else if (sitecode_df$site_code[i] == "SHT18") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "SHT18")
      } else if (sitecode_df$site_code[i] == "SHT30") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "SHT30")
      } else if (sitecode_df$site_code[i] == "STO08") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "STO08")
      } else if (sitecode_df$site_code[i] == "STO09") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "STO09")
      } else if (sitecode_df$site_code[i] == "STO39") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "STO39")
      } else if (sitecode_df$site_code[i] == "STT29") {
        sitecode_df$site_folder[i] <-
          file.path(path, "cameratraps2", "STT29")
      } else {
        sitecode_df <- NULL
      }
    }
  }
  return(sitecode_df)
}

#' construct_path_from_collection_and_site_folders
#'
#' @description
#' `construct_path_from_collection_and_site_folders` constructs a file path by combining the path to the site_folder and appending the collection folder onto the path.
#'
#' @param sitecode_df
#'
#' @return
#' @export
#'
#' @examples
construct_path_from_collection_and_site_folders <- function(sitecode_df){
  sitecode_df$path <-
    file.path(sitecode_df$site_folder,
              sitecode_df$collection_folder)
  return(sitecode_df)
}

