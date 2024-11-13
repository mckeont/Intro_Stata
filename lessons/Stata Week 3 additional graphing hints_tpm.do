
//Graphing Hints Week 3
tpm //what's this? keeps me from accidentlly running the whole do-file


// Graph editor 
 ** To change individual rectangles, right click then choose object specific properties
 ** Create a text box using note
 **scaleaxis to change title of y axis
 ** Can change orientation to horizontal in graph editor

/// Histogram (continuous)
histogram 
///Box and whisker plots (continuous)
graph box 
///Violin Plot (continuous)
vioplot 
///Bar charts (categorical / ordinal)
graph bar 
///Dot plots (single variable)
dotplot bwt
///Scatter plots ( two continuous)
scatter 

// Load data
use "C:\Users\ureka\OneDrive\Documents\Stata 2022\PUBH 501-002\lowbirthweightv12.dta", clear // change this to match the path on your computer

///------------------------------------------------
///editing and managing variables 
describe 
describe smokepreg

tab smokepreg

label var smokepreg "Mother smoked during pregnancy"
label def YNFMT 0 "no" 1 "yes"
label val smokepreg YNFMT
tab smokepreg


///-------------------------------------------------------------///
///-----------graphs--------------------------------------------///
///-------------------------------------------------------------///

///histogram
histogram age, freq 
histogram age, freq bin(5)
histogram age, freq width(1)
histogram age, freq bin(10) by(race) title(Age distribution by race)
histogram age if age<45, freq 

//changing axis ticks
histogram age, freq ylabel(5(5)50) ymtick(0(1)50) ytitle("values of y")
// to change xaxis go into graph editor, change scale or ticks. 

///box and whisker plots
graph box momweight
graph box momweight, over(lowbwt)
graph hbox momweight, over(lowbwt)

 // label outliers
graph hbox momweight, over( race ) by(smokepreg)  mark(1, mlab(momweight)) 
label var smokepreg "Smoking during pregnancy" /// adds as a caption
label def smprg 0 "No" 1 "Yes"
label val smokepreg smprg

///bar charts
	*use the 'count' or 'percent' option to plot frequncies or percentages. Mean is the default if you don't enter either option
graph bar (percent), over(smokepreg, sort(1) desc ) by(race)

graph hbar (percent), over(smokepreg, sort(1) descending) 

graph bar (percent), over(docvisits, sort(1) desc) over(smokepreg) title(“Doctor visits by moking status during pregnancy”)

graph bar (count), over(docvisits, sort(1) desc) 


graph bar (count), over(docvisits, sort(1) desc) over(smokepreg) title(“Doctor visits by moking status during pregnancy”) ytitle("y title") subtitle( "subtitle") 
//ylabel(minmax) 
// ylabel(, nogrid)


///dot plots
dotplot bwt, center mean

dotplot bwt, over(smokepreg) center median

///scatter plots
scatter momweight bwt
scatter momweight bwt, ylabel(minmax)
scatter momweight bwt, by(smokepreg)

///violin plots 
help vioplot //Stata does not have a vioplot command. But you can download a user-written command 
ssc install vioplot

vioplot bwt, name(g1)
vioplot bwt, over(smokepreg) name(g2)

graph combine g1 g2
graph drop g1 g2 //you can't name any other graphs g1 or g2 unless you drop these


///-----edit and create variables-------------------------------///
///-------------------------------------------------------------///
///create a variable that makes age into categories
gen agecat=.
replace agecat=1 if age<25
replace agecat=2 if age<30 & age>=25
replace agecat=3 if age>=30

///label the variable
label var agecat "age in three categories"

///create a value label
label def cat 1 "age 14-24" 2 "age 25-29" 3 "age 30-45"

///apply the value label to your new variable
label val agecat cat
tab agecat

///check that we made the variable correctly, two ways
tab age agecat, m
bysort agecat: summ age



///------------------------------------------------
///rename a variable
rename racenew race2
rename (racenew hbphx bwt) (race2 hpb bweight)

///-------------------------------------------------------------///
///-----creating a random sample--------------------------------///
///-------------------------------------------------------------///


///------------------------------------------------
///importing data
clear 
import excel "PATH\LAB3LOSdata500", firstrow clear //change this to match the path on your computer

///check that everything went okay
list in 1/10	//List the first 10 observations for the all variables
list in -10/l	//list the last 10 observations for all variables

///------------------------------------------------
///look at summary stats of whole data set
tabstat LOS, stats(mean median var)


///------------------------------------------------
///random sample of 50% of the original
sample 50
tabstat LOS, stats(mean median var)
summ LOS, detail
///------------------------------------------------
///do another sample to see that it is different
sample 50
tabstat LOS, stats(mean median var)

///------------------------------------------------
///setting the seed to get reproducable results
set seed 1298767
sample 50
tabstat LOS, stats(mean median var)

///------------------------------------------------
///random sample of n=50 instead of 50%
sample 50, count
tabstat LOS, stats(mean median var)




//Hints for Zany Data Activity
label def label1 1 "Netflix" 2 "Hulu" 3 "Amazon Prime" 4 "AppleTV" 5 "Disney+ " 6 " Other" 
label val streaming label1

decode streaming, gen(Favorite_Streaming)

label var Favorite_Streaming "Favorite Streaming Service"

tab Favorite_Streaming

label var incphila_K "Estimated Phila Avg. Income"

label var toothfair_dollars "How much should the Tooth Fairy give?"

label var life_mars "Do you believe in life on Mars?"

label var banana_dollars "How much would you pay for 3 bananas"

label var sleep_hours "How much sleep do you get?"



/// Histogram (continuous)
histogram incphila, freq bin(60) title(Distribution of Estimated Phila Avg. Income)
///Box and whisker plots (continuous)
graph box toothfair_dollars title(How much should the Tooth Fairy give?)
///Violin Plot (continuous)
graph box toothfair_dollars
vioplot toothfair_dollars
vioplot toothfair_dollars, over(life_mars)
///Bar charts (categorical / ordinal)
graph bar (percent), over(sleep_hours, sort(1) descending) title(How much sleep do you get?)
graph bar (percent), over(Favorite_Streaming, sort(1) descending) title(Favorite Streaming Service?)
///Dot plots (single variable)
dotplot banana_dollars title(How much for 3 bananas?)

dotplo
///Scatter plots ( two continuous)
scatter banana_dollars incphila_k  title(Relationship between banana dollars and ave phila income?)

graph bar sleep_hours, over(oldest_child)



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


graph bar (percent), over(docvisits, sort(1) desc) over(smokepreg) title("Doctor visits by smoking status during pregnancy")

graph bar (count), over(docvisits, sort(1) desc) over(smokepreg) title("Doctor visits by moking status during pregnancy")

graph hbar (percent), over(group, sort(1)) ///
  title("Veggie Popularity Contest", size(med)) ///
  subtitle("Percentage of respondents choosing each option", size(small)) ///
  ytitle("Number of Votes") ///
  legend(off) ///
  bar(1, bcolor(green) lcolor(black)) 
  ysize(8) graphregion(margin(l=6 r=10 t=8 b=8))


///------------------------------------------------
///dot plots
dotplot bwt
dotplot bwt, over(smokepreg)

///------------------------------------------------
///scatter plots
scatter momweight bwt

scatter momweight bwt, ylabel(minmax)

scatter momweight bwt, by(smokepreg)

 


