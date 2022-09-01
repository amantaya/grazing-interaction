# 2022-08-08-09-16-46 `grazer` package development
Created: 2022-08-08 09:16:46

- [ ] #task Develop a way to visualize camera operational dates and conversely dates with missing data plotted on the daily summary chart #grazer/dev
- [x] #task add additional fields to the `cameratraps.json` file that contains site names and timelapse settings #grazer/dev ✅ 2022-09-01
	- [x] #task add GPS coordinates to JSON #grazer/dev ✅ 2022-09-01
	- [ ] #task consider how to integrate Camera Trap Metadata Standard *CTMS* into the json #grazer/dev 
	- [ ] should the JSON be a XML file?
- [ ] #task write unit tests for functions #grazer/dev 
- [ ] #task test code coverage #grazer/dev 
- [ ] #task start semantic versioning the #grazer/dev package
- [ ] #task in `functions.R` need an internally consistent definition of what the input objects represent in terms of class (e.g. dataframe) and what processing steps take place to produce that object and explicitly define of columns and rows (if a data frame or tibble)
- [x] #task programmatically generate percentage annotations for grazing minutes figures ✅ 2022-09-01
	- [x] if inside a bar, use a `text` annotation
	- [x] if outside a bar, use a `label` annotation
	- [ ] 
```
	  # cow
  annotate(geom = "text", 
           x = 1, 
           y = 2500, 
           label = percent(season_total_2017$proportion_unwtd[1], 0.1)) +
  # elk
  annotate(geom = "label", 
           x = 1, 
           y = 5000, 
           label = percent(season_total_2017$proportion_unwtd[2], 0.1),
           fill = "#00BA38") +
```


## Tags
#grazer/dev 
## References
1. 