// For geeks only //
// & for "and" and | for "or". //


* Example 1: Count observations with lowbwt >= 25 and not missing
count if lowbwt >= 25 & lowbwt != .

* Example 2: Count observations with lowbwt equal to 33 or 50
count if lowbwt == 33 | lowbwt == 50

* Example 3: Tabulate nation for observations with lowbwt between 20 and 40
tab nation if lowbwt >= 20 & lowbwt <= 40

* Example 4: Tabulate nation for observations with lowbwt > 25, excluding missing values
tab nation if lowbwt > 25 & lowbwt != .

* Example 5: Tabulate nation where lowbwt > 25 or lowbwt is missing
tab nation if lowbwt > 25 | lowbwt == .

* Example 6: Tabulate nation where lowbwt > 25 or life60 is missing
tab nation if lowbwt > 25 | life60 == .

* Example 7: List nation and lowbwt for observations with lowbwt >= 30 and not missing
list nation lowbwt if lowbwt >= 30 & lowbwt != .

* Example 8: Summarize lowbwt for observations with lowbwt > 30 and not missing
summarize lowbwt if lowbwt > 30 & lowbwt != .

* Example 9: Generate a new variable 'high_bwt' that equals 1 if lowbwt >= 40 and is not missing
gen high_bwt = 1 if lowbwt >= 40 & lowbwt != .

* Optional: Display the new variable to check
list nation lowbwt high_bwt if lowbwt >= 40 & lowbwt != .


* To generate a new variable with random numbers ranging from 1 to 10 in Stata,
* you can use the runiformint() function within the generate command. Here's how you can do it:
generate painscore = runiformint(1, 10)
recode painscore (1/5=1) (6/10=2), gen(paingroup)
