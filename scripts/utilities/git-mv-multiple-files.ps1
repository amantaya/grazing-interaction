foreach ($file in get-childitem *.md) { git mv $file.FullName ./docs/notes }
