/*welcome to Stata!

This file contains my example codes for the first Stata lecture

Date
Version #

Presented by Tom McKeon, and modified from Jessica Rast
* comment

This file contains the commands used during the lecture, and will help you 
complete your lab.

For this lab, keep in mind
	1. Safe your commands in a do-file, like this one, so you can access them later
	2. Make notes in your do-file. you can add comments using the * or //
	3. You can run a line of code by highlighting it and either 
		a. click "do" on the command bar
		b. click ctrl+enter
	4. Label your do-file like I have done here, with any notes you may need next time you access the file. It's also good practice to add a date and your name
	5. change the file location to match your directory

*/

fs //what's this? keeps me from accidentlly running the whole do-file



///------------------------------------------------
///importing data
clear 
import excel "C:\Users\ureka\OneDrive\Documents\Stata 2022\PUBH 501-001\gunownership.xlsx", sheet("Sheet1") firstrow clear //change this to match the path on your computer

*check that everything went okay
list in 1/10	//List the first 10 observations for the all variables
list in -10/l	//list the last 10 observations for all variables

use "C:\Users\ureka\OneDrive\Documents\Stata 2022\PUBH 501-002\lowbirthweightv12.dta", clear // change this to match the path on your computer

save "C:\Users\ureka\OneDrive\Documents\Stata 2022\PUBH 501-002\LBW_Week2", replace //change this to match the path on your computer

***note: the -clear- option removes previous data from memory; make sure old data is saved if necessary***





///------------------------------------------------

///starting a log file
log using "C:\Users\ureka\OneDrive\Documents\Stata 2022\PUBH 501-002\WEEKTWO.txt" , replace text

log off //temporarily turn log off
log on //turn it back on

log close //close out the log file 

// name(mylog2)


///------------------------------------------------
///editing and managing variables 
describe 
describe smokepreg

tab smokepreg

label var smokepreg "Mother smoked during pregnancy"
label def YNFMT 0 "no" 1 "yes"
label val smokepreg YNFMT
tab smokepreg

///------------------------------------------------
///exciting commands
describe //see variable properties
codebook momweight //more detail than above, can list specific variables 
count //number of observations in your data
display (4+5)^2 //use Stata as a calculator
help display //use -help- and any command to get the stata help file
dis 4+5



///------------------------------------------------
///frequencies
ta smokepreg 

tab smokepreg, m nolab

tab smokepreg, summ(age) 

tab1 smokepreg race hbphx

proportion smokepreg







///------------------------------------------------
///summary stats
summ momweight
summ momweight, detail

tabstat momweight, stats(n, mean, sd, p25, p50, p75) //must have spaces

tab momweight //mode




///------------------------------------------------
///histogram
histogram age, freq 

histogram age, freq bin(5)

histogram age, freq bin(10) by(race) title(Age distribution by race)







///------------------------------------------------
///box and whisker plots
graph box momweight
graph box momweight, over(lowbwt)
graph hbox momweight, over(lowbwt)


///------------------------------------------------
///Violin Plot
ssc install vioplot, replace
vioplot momweight, over(lowbwt)
vioplot momweight, over(lowbwt), horizontal

///------------------------------------------------
///bar charts
	*use the 'count' or 'percent' option to plot frequncies or percentages. Mean is the default if you don't enter either option

graph bar (percent), over(smokepreg, sort(1) descending)

graph bar (percent), over(docvisits, sort(1) desc) over(smokepreg) title(“Doctor visits by smoking status during pregnancy”)

graph bar (count), over(docvisits, sort(1) desc) over(smokepreg) title(“Doctor visits by moking status during pregnancy”)




///------------------------------------------------
///dot plots
dotplot bwt
dotplot bwt, over(smokepreg)



///------------------------------------------------
///scatter plots
scatter momweight bwt

scatter momweight bwt, ylabel(minmax)

scatter momweight bwt, by(smokepreg)



