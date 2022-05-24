# Setup

source("setup.R")

# get all of the collection folders for the site
wildcat_exclosure_folders <- as_tibble(path = list.dirs(full_path_to_collection_folder)
                                       )

# rename the first column to "path"
names(wildcat_exclosure_folders) <- "path"

wildcat_exclosure_folders_sep <- separate(wildcat_exclosure_folders,
                                          path,
                                          into = c("discard",
                                                   "home",
                                                   "rstudio",
                                                   "cameratraps",
                                                   "site_group",
                                                   "site",
                                                   "collection",
                                                   "subfolders"),
                                          sep = "/",
                                          remove = FALSE)

View(wildcat_exclosure_folders_sep)

completed <- tibble(
  collection_folder =
    c("WCX_04192019_05212019",
      "WCX_05212019_07102019",
    )
)

not_completed <- tibble(
  collection_folder =
    c("WCX_06292018_07122018",
      )
)
