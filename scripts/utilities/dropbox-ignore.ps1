# tell dropbox to ignore all of these data directories because they are temporary staging folders
Set-Content -Path 'C:\Users\andre\Dropbox\dev\grazing-interaction\data\temp\chunks' -Stream com.dropbox.ignored -Value 1

Set-Content -Path 'C:\Users\andre\Dropbox\dev\grazing-interaction\data\temp' -Stream com.dropbox.ignored -Value 1
