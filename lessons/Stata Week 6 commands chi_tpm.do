.
///-------------------------------------------------------------///
///---------------bring in the data-----------------------------///
///-------------------------------------------------------------///
///start a log file
log using "\week5.txt" , replace text

///use low birth weight data for the chi-square and fischer's exact tests
use "\Chi.Fish.McN_LBW.dta", clear // change this to match the path on your computer


///-------------------------------------------------------------///
///-------------Chi-square tests--------------------------------///
///-------------------------------------------------------------///

///-------------------------------------------------------------///
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



///-------------------------------------------------------------///
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


///-------------------------------------------------------------///
///-------------reminder: variable creation---------------------///
///-------------------------------------------------------------///

///-------------------------------------------------------------///
///we can recreate the cesd0dich23 variable

///cesd0dich23 using -gen-
gen cesd0YN23=.
replace cesd0YN23=0 if (cesd0 < 23)
replace cesd0YN23=1 if (cesd0 >=23)

label define cesdYN23 0 "<23" 1 "23+" , replace
label values cesd0YN23 cesdYN23

///check that it worked
tab cesd0YN23 cesd0dich23, nol //short for no label

///-------------------------------------------------------------///
///cesd1dich23 using -recode-
recode cesd1 (0/22=0) (23/max=1) , gen(cesd1YN23)

label values cesd1YN23 cesdYN23

///check that it worked
tab cesd1YN23 cesd1dich23



log close













