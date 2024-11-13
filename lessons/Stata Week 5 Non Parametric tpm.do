 
Non-parametrics tests: sign test, sign rank, rank sum


///-------------------------------------------------------------///
///---------------bring in the data-----------------------------///
///-------------------------------------------------------------///
///start a log file
log using "C:\week5.txt" , replace text

///use the CESD data for sign and signrank tests: paired data
use "C:\cesdnonparametric.dta", clear // change this to match the path on your computer
// Or, go back to your main Stata UI and go to file >>>> open >>>>> .dta


///-------------------------------------------------------------///
///-------------Sign test---------------------------------------///
///-------------------------------------------------------------///
///-------------------------------------------------------------///
///check for normality
tabstat cesdT cesdTE, ///
 stats(n, p25, p50, p75, mean , var)
tab1 cesdT cesdTE
// or use the wildcard
tab cesd*
 
///histograms
hist cesdT, freq width(2)
hist cesdTE, freq bin(7)


///-------------------------------------------------------------///
///sign test using the -signtest- command
signtest cesdT = cesdTE

///-------------------------------------------------------------///
///-------------Wilcoxon sign rank test-------------------------///
///-------------------------------------------------------------///

///same data as sign test 
signrank cesdT=cesdTE

///-------------------------------------------------------------///
///-------------Wilcoxon rank sum test--------------------------///
///-------------------------------------------------------------///

///------------------------------------------------
///bring in unpaired data
use "C:\painscore.dta", clear // change this to match the path on your computer

describe 
codebook

///look at dependent and independent variables
tab1 painscore groups
///-------------------------------------------------------------///
///test for normality
bysort groups: tabstat painscore, stats(n, p25, p50, p75, mean var)

hist painscore, by(groups) freq bin(10)

///-------------------------------------------------------------///
///ranksum test
ranksum painscore, by(groups)





///-------------------------------------------------------------///
///-------------more on graphs----------------------------------///
///-------------------------------------------------------------///

///-------------------------------------------------------------///
///multiple graphs
set autotabgraphs on //allow graph editor to put new graphs in a new tab
set autotabgraphs off
histogram painscore if groups==1, name(histG1) freq
histogram painscore if groups==2, name(histG2) freq
histogram painscore, name(histB) by(groups) freq bin(10)




///-------------------------------------------------------------///
///saving in the graph editor
graph display  histG1 //create a recording
graph display histG2 //apply the recording
graph display histB //apply a scheme


graph drop histB histG1 //need to drop the graph name before using it again this session


log close













