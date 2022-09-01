# 2022-07-11-15-29-14 What I Accomplished Last Week
Created: 2022-07-11 15:29:14

1. API
	1.  Bugs
		1. I fixed the bug associated with messages that are missing a seconds and/or a microseconds value. This was causing the API to fail because it couldn't handle the missing data.
		2. I fixed the configuration issue and we now use the `config.json` file to set the dates we want to query. This will make it much simpler for users to get their data. They will not have to edit the python code directly anymore.
	2. Performance
		1. I made performance improvements and we now get data much faster.
		3. I also improved the warning and error messages to provide some diagnostic feedback. If an error occurs, the error messages should provide a starting place to troubleshoot the error.
	3. Data
		1. We're getting about ~600,000 messages per month at this rate, and we expect about 8,000,000 messages per year.

2. Feedback on 2021 Heber Report from Andy
	1. Andy pointed out a few things regarding when herds grazed that I made adjustments for in the wording. 
	2. Andy also pointed out that one of our cameras, Black Canyon North, which is in the Sharp Hollow Pasture, is actually taking photos of cows inside of the King Phillip pasture during September 2019. I need to remove that subset of photos and reproduce the figure.
	3. Andy also pointed out some things regarding precipitation about how 2019 was even drier than 2018. That is not my recollection so I am trying to acquire precip data for heber.
	4. I want to incorporate his feedback and send it back out this week.

3. Heber Veg Analysis 2021
	1. Send Methods section

4. Heber Camera Analysis 2021
	1. Students completed 14 *sorting* assignments in the last two weeks.
	2. I improved the automation for processing completed scoring assignments with my R script. 

5. Machine Learning
	1. I've been helping Daniel troubleshoot issues with the machine learning dependencies (software)
	2. 

6. Heber Photo Analysis 2021
	1. All **sorting** assignments for the time-lapse have been completed
	2. Students are now working on **scoring** assignments, of which there are 27. 
		1. Each assignment has about 100 photos, so I'd estimate if each student completes 5 assignments per week, we're looking at 3 weeks until all of time-lapse data is processed.
		2. 
## Tags

## References
1. 