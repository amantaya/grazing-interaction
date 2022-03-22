# tell dropbox to ignore all of these data directories because they are temporary staging folders

Set-Content -Path 'C:\Users\andre\Dropbox\Rproj\grazing-interaction\data\00-rename' -Stream com.dropbox.ignored -Value 1

Set-Content -Path 'C:\Users\andre\Dropbox\Rproj\grazing-interaction\data\01-extract' -Stream com.dropbox.ignored -Value 1

Set-Content -Path 'C:\Users\andre\Dropbox\Rproj\grazing-interaction\data\02-transfer' -Stream com.dropbox.ignored -Value 1

Set-Content -Path 'C:\Users\andre\Dropbox\Rproj\grazing-interaction\data\03-upload' -Stream com.dropbox.ignored -Value 1

Set-Content -Path 'C:\Users\andre\Dropbox\Rproj\grazing-interaction\data\chunks' -Stream com.dropbox.ignored -Value 1