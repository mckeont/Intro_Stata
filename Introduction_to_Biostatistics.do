.
*--------------------------------------*
* Introduction to Biostatistics       *
* Tutorial by Thomas P. McKeon, MPH   *
* November 2023                        *
*--------------------------------------*


* Data Import and Cleaning
clear  // Clear previous data
display (4+5)^2  // Use Stata as a calculator

* Starting a Log File
log using "C:\YOURPATH\mylogfile.txt", replace
log off  // Temporarily turn log off
log on  // Turn it back on
log close  // Close out the log file

* Importing and Saving Data
import excel "C:\YOURPATH\EXCEL_DATASET.xlsx", sheet("Sheet1") firstrow clear
use "C:\YOURPATH\STATA_DATASET.dta", clear
save "C:\YOURPATH\DATASET", replace  // Save a new version if you modify your dataset
sysuse dir  // View datasets preinstalled with Stata

*Examining data
sysuse auto  // Load auto.dta dataset
count //number of observations in your data

list in 1/10	//Lists first 10 observations for all variables
list in -10/l	//lists last 10 observations for all variables
list turn make length foreign in 1/15  // List first 15 observations for -turn- -make- and -foreign- 
list make-rep78 in 1/5 // list first 5 observations of a range of variables

///editing and managing variables 
help describe // The help command displays help information about the specified command or topic. 
describe // Describe data in memory or in a file
describe weight
codebook // more details about variables
tab rep78 // tabulate frequencies and determine mode

// Labeling variables and their values
help label
label var rep78 "New Label" // label variable in your "variables window"
label def labelSticker 1 "one" 2 "second" 3 "three" 4 "fourth!" 5 "five" // Define a label called labelSticker
label val rep78 labelSticker  // attach label to variable to label values

// More on frequencies and proportions
tab rep78 // view updated labels, compare to tabulate rep78 before adding labels
tab rep78, m // view missing data
tab rep78, nolab // view without labels
tab rep78, m nolab // you can combine options
tab rep78, summ(price) //produces one- and two-way tables (breakdowns) of means and standard deviations.
tab1 rep78 make foreign  // If you're interested in using multiple variables and you want the separate distributions of each, then use -tab1-. -tab- will give you a cross-tabulation of the two variables
proportion rep78  // Estimate proportions

///summary stats
summ length  // Summary statistics
summ length, detail  //  display additional statistics
tabstat length, stats(n, mean, sd, p50) // Compact table of summary statistics

///Graphing
** Histograms **
histogram price // Histograms for continuous and categorical variables **default density **
histogram price, freq // change y axis to frequency
histogram price, freq width(100)  //set width of bins to #
histogram price, freq bin(10) // set number of bins to #
histogram price, freq bin(10) normal // add a normal line
histogram price, freq bin(10) normal title(Your Title) subtitle(Your subtitle) // Add Title and subtitle
histogram rep78, freq bin(10) by(foreign) // Create two histograms by foreign status 
histogram price if price < 10000, freq // Add a conditional statement, only values less than 10,000
histogram turn, freq ylabel(0(15)60) ymtick(0(2)60) ytitle("values of y") //changing axis ticks
// to change xaxis go into graph editor, change scale or ticks. 

** box and whisker plots **
graph box length  // Vertical box plot, the y axis is numerical, and the x axis is categorical.
graph box length, by(foreign) // The by() option with graph box allows you to create separate boxplots for different groups or categories defined by a specific variable. Each group's boxplot is displayed in its own panel or subplot.
graph box length, over(foreign) // The over() option is used to overlay multiple boxplots on the same graph, rather than creating separate panels. It's useful when you want to visually compare the distributions of a continuous variable across different categories or groups in a single graph
graph hbox length, over(foreign) title(horizontal boxplot)  // horiztonal boxplot
graph hbox turn, over(foreign ) by(rep78)  mark(1, mlab(turn)) // label outliers and combine over() and by()

** Violin Plot **
ssc install vioplot, replace  // Violin Plots are a modification of box plots and needs to be installed first
vioplot length, over(foreign)

** bar charts ** use the 'count' or 'percent' option to plot frequncies or percentages. Mean is the default if you don't enter either option. Good for categorical or ordinal data
graph bar (percent), over(foreign) 
graph bar (percent), over(foreign, sort(1))  // sort low to high
graph bar (percent), over(foreign, sort(1) desc)  // sort high to low
graph bar (percent), over(foreign, sort(1) desc label(angle(45))) over(rep78) title("Title") // group, title, and angle labels
graph bar (count), over(foreign, label(angle(45))) over(rep78) title("Title")

** dot plots **
dotplot headroom //  A dotplot is a scatterplot with values grouped together vertically  The aim is to display all the data for several variables or groups in one compact graphic.
dotplot length, center median // center and add median line
dotplot length, over(foreign) center mean  // group by foreign status, center and mean line

** scatter plots **
scatter length price  // compare two continuous variables 
scatter length price, ylabel(minmax) xlabel(, nogrid) ylabel(, nogrid) // change y-axis to minmax, remove gridlines
scatter length price, by(foreign)


// Name and combine graphs
vioplot length, name(g1)
vioplot length, over(foreign) name(g2)
graph combine g1 g2
graph drop g1 g2 //you can't name any other graphs g1 or g2 unless you drop these

///multiple graphs
set autotabgraphs on //allow graph editor to put new graphs in a new tab
set autotabgraphs off


///-----edit and create variables-------------------------------///

///create a variable that makes miles per gallon (mpg) into groups
gen mpgcat=.  // creates a new variable. use  =. for numeric, and ="" for text
replace mpgcat=1 if mpg<18
replace mpgcat=2 if mpg<20 & mpg>=18
replace mpgcat=3 if mpg>=20
tab mpg mpgcat, m // compare and check variables were made correctly
bysort mpgcat: summ mpg  // other way to compare and check

gen mpgtext=""  
replace mpgtext="low mpg" if mpg<18
replace mpgtext="medium mpg" if mpg<20 & mpg>=18
replace mpgtext="high mpg" if mpg>=20
tab mpgtext mpgcat  // compare new variables

label var mpgcat "MPG as numeric categories" ///label the variables
label var mpgtext "MPG as string categories" 
tab mpgtext mpgcat  // compare new variables with labels

recode mpg (0/18=1) (19/20=2) (21/max=3), gen(mpgrecode)
tab mpg mpgrecode

///rename a variable
rename  mpg mpg_new
rename (trunk length price) (trunkNEW lengthNEW priceNEW) // rename several at same time

// Converting numeric to categorical 
encode make, generate(make_numeric) 
tab make_numeric, nolab 

// Converting categorical to numeric
decode make_numeric, generate(make_string)
tab make_string

// Generating new variables based on calculation. 
gen discountprice = price - 129.8201
tab discountprice

// create new variables by unique values of another variable
separate race, by(race)
lab var race1 "Black" // label
lab var race2 "Other"
lab var race3 "White"




///-------------------------------------------------------------///
///-------------Paired t-tests----------------------------------///
///-------------------------------------------------------------///
clear // clear the auto dataset
sysuse bpwide // load in a Fictional blood-pressure dataset
describe // view data

label var bp_before "Blood Pressure Measurement Before Treament"
label var bp_after "Blood Pressure Measurement After Treament"
describe // view new labels 

///let's look at summary stats
summ bp*  // * does summary stats for all variables beginning with "bp"
tabstat bp*, stats(n, mean, var, p25, p50, p75)
tabstat bp_before bp_after, stats(n, mean, var, p25, p50, p75, SEM)
mean bp*

///check normality with a histogram
hist bp_before, freq normal
hist bp_after, freq normal 

///the paired t-test for before and after treatment
ttest bp_before = bp_after
ttest bp_before = bp_after if sex==1  // restrict to females only

///-------------------------------------------------------------///
///-------------two-sample t-tests------------------------------///
///-------------------------------------------------------------///

// two sample t-test of blood pressure before treatment between male and females
/// summary stats
bysort sex: summ bp_before
bysort sex: tabstat bp_before, stats(n, mean, var, p25, p50, p75, SEM)

///Look at a boxplot of bp_before by sex
graph box bp_before, over(sex)
graph box bp_before
dotplot bp_before

///check normality with a histogram
hist bp_before, freq by(sex)

///superimpose a normal curse
hist bp_before if sex==0, normal freq
hist bp_before if sex==1, normal freq

///run the sdtest of equal variance before t-test
sdtest bp_before, by(sex) //significant at p<0.05: variance unequal

///two-sample t-test 
ttest bp_before, by(sex) 
ttest bp_before, by(sex) unequal  //with unequal variances

///alternative: running a two-sample t-test if your data has two variables, instead of one variable with a group name (like we just did). This will not run in our data, just pretent variable names

///still need to test for equal variance:
sdtest var1=var2, unpaired

///t-test 
ttest var1=var2, unpaired
ttest var1=var2, unpaired unequal


///-------------------------------------------------------------///
///-------------------Non-parametrics tests:--------------------///
///--------------- sign test, sign rank, rank sum---------------///
///------------------------------------------------------------///
clear 
sysuse nlsw88  // National Longitudinal Survey of Youth (NLSY)

// Create two new variables, hourly wage for the north and wage for the south
generate wage_north = wage if south == 0
generate wage_south = wage if south == 1

///-------------------------------------------------------------///
///-------------Sign test---------------------------------------///
///-------------------------------------------------------------///
///-------------------------------------------------------------///
///check for normality
tabstat wage_north wage_south, stats(n, p25, p50, p75, mean , var)

///histograms
hist wage_north, freq normal
hist wage_south, freq normal

///sign test using the -signtest- command
signtest wage_north = wage_south

///-------------------------------------------------------------///
///-------------Wilcoxon sign rank test-------------------------///
///-------------------------------------------------------------///
clear
sysuse bpwide // Load in a fictional blood pressure dataset again
describe
drop if bp_before >= 160 & bp_before <= 165 // let's drop some observations to skew the data
drop if bp_after >= 155 & bp_after <= 160 // let's drop some observations to skew the data
count
//check normality
hist bp_before, freq normal
hist bp_after, freq normal

tabstat bp_before bp_after, stats(n, p25, p50, p75, mean , sd, var)

signrank bp_before=bp_after

///-------------------------------------------------------------///
///-------------Wilcoxon rank sum test--------------------------///
///-------------------------------------------------------------///

///look at dependent and independent variables
tab1 bp_before sex
///-------------------------------------------------------------///
///test for normality
bysort sex: tabstat bp_before, stats(n, p25, p50, p75, mean var)

hist bp_before, by(sex) freq bin(10)

///-------------------------------------------------------------///
///ranksum test
ranksum bp_before, by(sex)


///-------------------------------------------------------------///
///-------------Chi-square tests--------------------------------///
///-------------------------------------------------------------///

///use low birth weight data for the chi-square and fischer's exact tests
use "\Chi.Fish.McN_LBW.dta", clear // change this to match the path on your computer

///Goodness of fit test
findit csgof

tab race //see how many levels there are to your variable, that will inform the -expperc- option in -csgof- command

csgof race, expperc(70,20,10) //include the expected proportions (expperc= expected percentages)

///-------------------------------------------------------------///
///chi-square test of independence

tab ui low, m //tabulate the two variables, using option -m- to look for missing
tab ui low, row col //the -row- and -column- options give row and column percentages

tab ui low, row col chi2 //the -chi2- option runs the chi-square test of independence 
tab ui low, chi2


///Fisher's exact test
///the setup for Fisher's exact is the same as chi2, using the -tab- command with an option
tab ht low, expected //the -expected- option gives the expected frequency of each cell
tab ht low, expected exact //the -exact- option calls for the Fisher's exact test

///-------------------------------------------------------------///
///-------------McNemar test------------------------------------///
///-------------------------------------------------------------///

///------------------------------------------------
///bring in new paired data
use "\Chi.Fish.McN_CESD.dta", clear // change this to match the path on your computer


describe 
codebook
codebook cesd0* //the * will show everything that has the prefix "cesd0"
tab cesd0 cesd0dich23 //run a crosstabulation to compare these two variables

label var cesd0 "CES-D at first interview (third trimester)"
label var cesd1 "CES-D at second interview (1 month post delivery)"

///use -tab1- to look at a tabulation of the dichotomous variables at the same time
tab1 cesd0dich23 cesd1dich23 //tab1 allows more than one variable, where tab does not

//use tab to look at a crosstabulation of the same variables
tab cesd0dich23 cesd1dich23
tab cesd0dich23 cesd1dich23, row col //row and col allow for row and column percentages

///The -mcc- runs McNemar's test (mcc = matched case control)
mcc cesd0dich23 cesd1dich23 //use the exact p-value when sum of the discordant rows < 20


bysort race: tabstat ht, stats(n, mean, var, p25, p50, p75, SEM)
bysort race: summ ht
proportion ht, over(race)


// case (cohort) study 
cs varcase varexposed 
csi #a #b #c #d  // fill in your own numbers
// % cases /exposed  % cases/unexposed 

// Case–control studies
cc varcase varexposed 
cci #a #b #c #d // fill in your own numbers
// % exposed/cases  % exposed/controls  



///-------------------------------------------------------------///
///--------------Paired power calculations----------------------///
///-------------------------------------------------------------///
///default alpha = 0.05, default power = 0.8

///means of two time points = 175 and 182, SD of the difference = 16
power pairedmeans 175 182, sddiff(16) 

///Can change the power and alpha using these options
power pairedmeans 175 182, sddiff(16) alpha(0.01) power(0.9)
power pairedmeans 175 182, sddiff(16) power(0.7 0.8 0.9)
power pairedmeans 175 182, sddiff(16) alpha(0.1 0.05 0.01) power(0.7 0.8 0.9)
///Can run if we don't know means but do know the difference in means
power pairedmeans, altdiff(7) sddiff(16) //should get the same results as when we entered the means
///Can computer power for a known sample size
power pairedmeans 175 182, n(100) sddiff(16)
power pairedmeans 175 182, n(50) sddiff(16)
///Graph power at different sample sizes (from 50 to 100, counting by 10)
power pairedmeans 175 182, n(50 (10) 100) sddiff(16) graph

///-------------------------------------------------------------///
///--------------Un-paired power calculations-------------------///
///-------------------------------------------------------------///

///basic sample size calculation for group1 mean 20 sd 10, group 2 mean 23 sd 12. 
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



///-------------------------------------------------------------///
///----------------ANOVA----------------------------------------///
///-------------------------------------------------------------///
sysuse citytemp
describe

// Generate a new variable from region that has three groups
tab region
recode region (1/2=1) (3=2) (4=3), gen(regionnew)
label def regionlabel 1 "North" 2 "South" 3 "West"
label val regionnew regionlabel
tab regionnew
tab region regionnew


///check for normality (assumption of ANOVA)
hist tempjuly , by(regionnew) freq 

bysort regionnew: summ tempjuly
bysort regionnew: tabstat tempjuly, stats(mean p50)


///ANOVA command
anova tempjuly regionnew //runs many types of ANVOA
quietly: anova tempjuly regionnew // runs test quietly in background
///Levene's test for equality of variances
robvar tempjuly, by(regionnew) 
pwcompare regionnew, mcompare(bon) pveffects 

oneway tempjuly regionnew, bon t //runs oneway with equal variance test and option for post hoc test and tabulate averages
** Note that the equal variance fails for this

///-------------------------------------------------------------///
///----------------Kruskal Wallis-------------------------------///
///---------------------for non-parametric----------------------///

hist tempjan, by(regionnew) freq 
bysort regionnew: tabstat tempjan, stats(mean p50)

///install kwallis2 user-written command to do post hoc comparisons
findit kwallis2

///run the command
kwallis2 tempjan, by(regionnew)


///-------------------------------------------------------------///
///----------------Linear regression----------------------------///
///-------------------------------------------------------------///
sysuse auto
describe

///check for normality 
tabstat headroom mpg, stats(mean p50 sd)
summ headroom
summ mpg
hist headroom
hist mpg
hist price


///are the varibles linearlly related? 
scatter mpg headroom

///linear regression command
regress headroom mpg

///plot variables with an added line of fitted values
twoway (scatter headroom mpg) (lfit headroom mpg), title("MPG and headroom with fitted values") subtitle("-twoway (scatter headroom mpg) (lfit headroom mpg)-")

///assess normality of the residuals
predict head_r, residual
hist head_r

estat hettest, rhs

///-------------------------------------------------------------///
///----------------Correlation----------------------------------///
///-------------------------------------------------------------///

///pearson correlation
corr mpg headroom 
pwcorr mpg headroom, sig //this gives the p-value associated with correlation


///spearman correlation
spearman mpg headroom 

spearman price mpg //price is not normally distributed, so a good fit for spearman

*if you have more than two variales, use this option to get the p-value printed
spearman mpg headroom price,stats(rho  p)


///-------------------------------------------------------------///
///-----creating a random sample--------------------------------///
///-------------------------------------------------------------///

///------------------------------------------------
///random sample of 50% of the original
sample 50
tabstat weight, stats(mean median var)
summ weight, detail
///------------------------------------------------
///do another sample to see that it is different
sample 50
tabstat weight, stats(mean median var)

///------------------------------------------------
///setting the seed to get reproducable results
set seed 1298767
sample 50
tabstat weight, stats(mean median var)

///------------------------------------------------
///random sample of n=50 instead of 50%
sample 50, count
tabstat weight, stats(mean median var)

