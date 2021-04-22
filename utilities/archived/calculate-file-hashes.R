library(openssl)

# Clear the R environment
rm(list=ls(all=TRUE))

# Set the working directory
setwd("C:/TEMP")

# Check to see if the working directory is correct
getwd()

# Save the system time before calculating hashes
start_time <- Sys.time()

# Source
source_files <- list.files("C:/TEMP/transfer/A51_10222020_12022020/", recursive = TRUE, include.dirs = TRUE, full.names = TRUE)

# Destination
destination_files <- list.files("J:/cameratraps/fiftyone/timelapse/A51_10222020_12022020/", recursive = TRUE, include.dirs = TRUE, full.names = TRUE)

# Calculate file hashes using the SHA256 algorithm
source_file_hashes <-  sha256(file(source_files[1]))

source_file_hashes_test2 <- NULL

for (i in 1:1) {
  source_file_hashes_test2 <- sha256(file(source_files[i]))
}

str(source_file_hashes_test2)
#source_file_hashes_test <-  sha256(file(source_files[1]))

summary(source_file_hashes == source_file_hashes_test2)

# View file hashes
source_file_hashes

# 
destination_file_hashes <- sha256(destination_files)

summary(destination_file_hashes == source_file_hashes)

# Save the system time after calculating hashes
end_time <- Sys.time()

# Compare the system time before and after running the function to see how long it took to calculate hashes
end_time - start_time

