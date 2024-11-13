.
///-------------------------------------------------------------///
///---------------prepare for analysis--------------------------///
///-------------------------------------------------------------///
///start a log file
log using "8\week8.txt" , replace text


///bring in .dta stata data file
use "\lowbirthweight.dta", clear




///-------------------------------------------------------------///
///----------------ANOVA----------------------------------------///
///-------------------------------------------------------------///
*is average birthweight different by race? we will use the numeric race variable, we can't use string variables with ANOVA



tab race  /// investigate frequency and percentagetab

///check for normality (assumption of ANOVA)
hist bwt, by(race) freq ///

bysort race: summ bwt
bysort race: tabstat bwt, stats(mean p50)


///Levene's test for equality of variances
robvar bwt, by(race)
	//this shows the mean and SD for bwt by race (as done above with bysort)
	//and runs Levene's test for equality of variance to test is there is a 
	//significant difference in variance between groups. There is not in this case. 


///ANOVA command
anova bwt race //runs a one-way ANVOA
oneway bwt race, t //this is the same as the above command. 

///-------------------------------------------------------------///
///post hoc comparisons can be run after -anova- or -oneway-. restuls will be the same
anova bwt race 
pwcompare race, mcompare(bon) pveffects 
	*post hoc comparisons must be run right after the command
	*here we are using the bonferroni adjusted tests


///-------------------------------------------------------------///
///you can run ANOVA on a subpopulation using the -if- statment, as we have with other commands
anova bwt race if smoke==1
pwcompare race, mcompare(bon) pveffects  //comparison will be within the subpopulation stated in the ANOVA

quietly: anova bwt race 
pwcompare race, mcompare(bon) pveffects 


///-------------------------------------------------------------///
///----------------Kruskal Wallis-------------------------------///
///-------------------------------------------------------------///

hist lwt, by(race) freq ///
	title("Mother weight") ///
	xlab(#6, format(%4.0f)) 
bysort race: summ lwt
bysort race: tabstat lwt, stats(mean p50)

///run kruskal wallis test
kwallis lwt, by(race)

///install kwallis2 user-written command to do post hoc comparisons
findit kwallis2

///run the command
kwallis2 lwt, by(race)

///can also use the -dunntest- command
findit dunntest
dunntest lwt, by(race)

*note: kwallis2- and -dunntest- also gives you the output for hte kruskal-wallis test, so you could just run that command instead of the kwallis command 




//Stata tips:
///-------------------------------------------------------------///
///----------------Formats--------------------------------------///
///-------------------------------------------------------------///

///make a value labe for a numeric variable
ta ftvcat
label def visit_count 0 "none" 1 "one" 2 "two or more"
label val ftvcat visit_count
tab ftvcat

///format a number to display a certain way
gen bwt2=sqrt(bwt) //create a variable with a lot of decimal places
tab bwt2
format bwt2 %4.1f //creates a three-digit variable with one digit after the decimal place 
tab bwt2
format bwt2 %5.3f //the underlying values are still there, as you can see when you ask for more decimal places


///display commas in a numeric variable
format bwt %4.0gc
ta bwt

///format string to display a certain way
replace racenew="other_multiple" if racenew=="other"
list smoke ht ui racenew in 1/8


format racenew %-14s //this make race 14 characters long, and justifies it to the left
list smoke ht ui racenew in 1/8



///Changing format of histogram x axis
hist bwt, by(race) freq ///
	title("Birthweight") ///
	xlab(#6, format(%4.0f)) 
bysort race: summ bwt
bysort race: tabstat bwt, stats(mean p50)




