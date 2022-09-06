foreach ($file in get-childitem ./scripts/analysis/archived) { git mv $file.FullName ./scripts/archived }
