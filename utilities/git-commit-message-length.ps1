cd C:\Users\andre\Dropbox\Rproj\Horse-Cattle-Elk-Grazing-Interaction-Study

#displays the raw lengths
git shortlog  | grep -e '^      ' | sed 's/[[:space:]]\+\(.*\)$/\1/' | awk '{print length($0)}'

#or a text-based historgam
git shortlog  | grep -e '^      ' | sed 's/[[:space:]]\+\(.*\)$/\1/' | awk '{lens[length($0)]++;} END {for (len in lens) print len, lens[len] }' | sort -n