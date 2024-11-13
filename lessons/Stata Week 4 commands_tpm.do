.
///-------------------------------------------------------------///
///---------------bring in the data-----------------------------///
///-------------------------------------------------------------///
///start a log file
log using "\Week 4\week4.txt" , replace text

///use low birth weight data
use "C:\Users\ureka\OneDrive\Desktop\Stata2023_1-1\Logs\Week 4\lab4data.dta", clear // change this to match the path on your computer
***remember: the -clear- option removes previous data from memory; make sure old data is saved if necessary***


///------------------------------------------------
///editing and managing variables 
describe 
codebook
codebook cesd* educnew

list STUDYID cesd0 cesd1 in 1/10

tab educnew

label define educstatus 0 "HS/GED" 1 "Did not finish HS"
label val educnew educstatus
tab educnew

label var cesd0 "CES-D at first interview (third trimester)"
label var cesd1 "CES-D at second interview (1 month post delivery)"

///-------------------------------------------------------------///
///-------------Paired t-tests----------------------------------///
///-------------------------------------------------------------///

///-------------------------------------------------------------///
///let's look at summary stats
summ cesd*
tabstat cesd*, stats(n, mean, var, p25, p50, p75)
tabstat cesd0 cesd1, stats(n, mean, var, p25, p50, p75, SEM)
mean cesd*

///-------------------------------------------------------------///
///check normality with a histogram
hist cesd0, freq  
hist cesd1, freq 


///superimpose a normal curse
hist cesd0, normal freq
hist cesd1, normal freq


///-------------------------------------------------------------///
///the paired t-test
ttest cesd0 = cesd1 if educnew==1

///-------------------------------------------------------------///
///-------------two-sample t-tests------------------------------///
///-------------------------------------------------------------///

///-------------------------------------------------------------///
/// summary stats
bysort educnew: summ cesd1
bysort educnew: tabstat cesd1, stats(n, mean, var, p25, p50, p75, SEM)

list STUDYID educnew cesd1 in 200/220

///Look at a boxplot of cesd1 by education status
graph box cesd1, over(educnew)
graph box cesd1
dotplot cesd1
onewayplot cesd1, vertical
///-------------------------------------------------------------///
///check normality with a histogram
hist cesd1, freq by(educnew) 

///superimpose a normal curse
hist cesd1 if educnew==0, normal freq
hist cesd1 if educnew==1, normal freq

///-------------------------------------------------------------///
///run the test of equal variance before t-test
sdtest cesd1, by(educnew) //significant at p<0.05: variance unequal

///-------------------------------------------------------------///
///two-sample t-test with unequal variance 
ttest cesd1, by(educnew) unequal
ttest cesd1, by(educnew) //equal variances assumed, incorrect


///-------------------------------------------------------------///
///alternative: running a two-sample t-test if your data has two variables, instead of one variable with a group name (like we just did). This will not run in our data, just pretent variable names

///still need to test for equal variance:
sdtest var1=var2, unpaired

///t-test 
ttest var1=var2, unpaired
ttest var1=var2, unpaired unequal


///-------------------------------------------------------------///
///-------------more on variable creation------------------------///
///-------------------------------------------------------------///

///-------------------------------------------------------------///
///create a new categorical variable from a continuous one

///way 1: we also did this last week
gen cesdcat=.
replace cesdcat=0 if (cesd0 < 16)
replace cesdcat=1 if (cesd0 >=16 & cesd0 <=23)
replace cesdcat=2 if (cesd0 >23 & cesd0 !=.)

label define cesd 0 "<16" 1 "16-23" 2 ">23", replace
label values cesdcat cesd


///check that it worked
tab cesdcat
bysort cesdcat: tabstat cesd0, stats(min, max)

///-------------------------------------------------------------///
///way 2: use -recode-
recode cesd0 (0/15=0) (16/23=1) (24/max=2), gen(cesdcat2)
tab1 cesdcat2 cesdcat
tab cesdcat2 cesdcat




log close













