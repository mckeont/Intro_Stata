//adjusted p-values
anova poverty_per store
pwcompare store, mcompare(bon) pveffects
kwallis2 poverty_per, by(store)
// kwallis doesn't include post-hoc. However it can use both a string and numeric grouping variable.

// kwallis2 grouping variable type needs to be numeric
tab store
tab store, nolab

// Let's test it out....
// numeric to string
decode store, gen(storecat)

//check
tab store storecat

kwallis2 poverty_per, by(storecat)
kwallis poverty_per, by(storecat)

// What to do if you have a string type?
// string to numeric
encode storecat, generate(storebacktoNum)

kwallis2 poverty_per, by(storebacktoNum)
kwallis poverty_per, by(storebacktoNum)
