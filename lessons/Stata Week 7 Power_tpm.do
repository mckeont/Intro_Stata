/*welcome back to Stata

Do file of commands used for Stata lecture 
Power and sample size

Tom McKeon (modified from JR)
*/

2 proportions to report in case-control.
%exposed/cases
%exposed/controls

2 proportions to report in cohort. row percentage
%cases/exposed
%cases/unexposed 

fs //what's this? keeps me from accidentlly running the whole do-file. Not a Stata command

// data: lowbirthweightv12.dta

// Stata Tips
// splitting values in one column into new. For example, if you have a variable claled Sex which contains both Male and Female
// You can split males only into one column, and females only into another.

separate race, by(race)
lab var race1 "Black"
lab var race2 "Other"
lab var race3 "White"


// Generating new variables based on calculation. 
gen mw2 = momweight - 129.8201

summ momweight
summ mw2

hist momweight
hist mw2



***no data needed for power calculations, just number inputs***


///-------------------------------------------------------------///
///--------------Paired power calculations----------------------///
///-------------------------------------------------------------///

///means of two time points = 175 and 182, SD of the difference = 16
	///default alpha = 0.05, default power = 0.8
power pairedmeans 175 182, sddiff(16) 

///Can change the power and alpha using these options
power pairedmeans 175 182, sddiff(16) alpha(0.01) power(0.9)
power pairedmeans 175 182, sddiff(16) power(0.7 0.8 0.9)
power pairedmeans 175 182, sddiff(16) alpha(0.1 0.05 0.01) power(0.7 0.8 0.9)


///Can run if we don’t know means but do know the difference in means
power pairedmeans, altdiff(7) sddiff(16) //should get the same results as when we entered the means


///Can computer power for a known sample size
power pairedmeans 175 182, n(100) sddiff(16)
power pairedmeans 175 182, n(50) sddiff(16)

///Graph power at different sample sizes (from 50 to 100, counting by 10)
power pairedmeans 175 182, n(50 (10) 100) sddiff(16) graph


///-------------------------------------------------------------///
///--------------Un-paired power calculations-------------------///
///-------------------------------------------------------------///

///basic sample size calculation for group1 mean 20 sd 10, group 2 mean 23 sd 12. Default power 0.8 default alpha 0.05 two-sided
power twomeans 20 23, sd1(10) sd2(12) //unequal variance becuase we have differnt SDs by group
power twomeans 20 23, sd(10) //becasue we only have one SD, that is the same for both groups, this assumes equal variance

///can do same as paired example above and change inputs
power twomeans 20 23, sd1(10) sd2(12) alpha (0.1 0.05) power (0.7 0.8 0.9)

///can do same as paired example above and get power for a given sample size
power twomeans 20 23, sd1(10) sd2(12) alpha (0.1 0.05)  n1(100) n2(150)
power twomeans 20 23, sd1(10) sd2(12) alpha (0.1 0.05)  n1(100 150) n2(150 200)

///can graph at different sample sizes and power levels
power twomeans 20 23, sd1(10) sd2(12)  n(200 (40) 500) graph
power twomeans 20 23, sd1(10) sd2(12) alpha (0.1 0.05)  power(.7 (.1) .9) graph



///-------------------------------------------------------------///
///--------------Un-paired difference in proportions------------///
///-------------------------------------------------------------///

///calculate sample size for proportions 0.6 and 0.5 default power=0.8, alpha=0.05 two-sided
power twoproportions 0.6 0.5

///calcluate power for different sample sizes
power twoproportions 0.6 0.5, n(500 (50) 1000)

///can still do all the same things as above: chnage alpha, power, n ranges, graph
power twoproportions 0.6 0.5,  n(500 (50) 1000) graph
power twoproportions 0.6 0.5, alpha (0.01 0.05)  power(.7 .8 .9) graph













