sum ahllt ahlstat ajbstat doby amlstat sex arace afiyr

*summarised 3 potential dependent variables, independent variable, and covariates(some of which will need to be transformed)

. gen healthlimits = ahllt
. replace healthlimits=. if ahllt<0
replace healthlimits=0 if healthlimits==2

. gen healthstatus = ahlstat
. replace healthstatus=. if ahlstat<0


gen ghqb=0
replace ghqb=1 if ahlghq2>2
replace ghqb=. if ahlghq2==.
*generate dummy for wellbeing


gen inpatient = ahospd
replace inpatient=0 if ahosp==-8
replace inpatient=. if ahospd=-1 
replace inpatient=. if  ahospd=-2 
replace inpatient=. if  ahospd<-8 
replace inpatient=0 if ahospd==-8
replace inpatient=0 if ahospch==1
replace inpatient=. if ahospch==2
gen linpatient= log(inpatient)

*generate inpatient days not as a result of pregnancy (where some days are due to pregnancy, replace with missing as unable to tell how many are not due to pregnancy)
*used log of inpatient days as the distribution is positively skewed
 gen dob = doby
. replace dob=. if doby<0

. gen married = amlstat 
. replace married=. if amlstat<0

. gen ethnicity = arace
. replace ethnicity=. if arace<0

* replaced missing variables

gen year = 1991
gen age = year - dob
gen age2 = age^2
*variables are generated for age and age^2

.  gen healthstatusb = ahlstat
.  replace healthstatusb=. if ahlstat<0
. replace healthstatusb=0 if ahlstat>0
. replace healthstatusb=1 if ahlstat>2
*A dummy variable is generated, taking the value 1, if health status is fair, poor or very poor (decided to include fair, as few were poor or very poor)

gen unemployed=0
replace unemployed=1 if ajbstat==3
*dummy for unemployment

. gen marriage = amlstat
. replace marriage =. if amlstat<0
. replace marriage=0 if amlstat>1
*generate dummy for marriage
replace sex=0 if sex==2
*convert to dummy for sex

gen race = arace
replace race=. if arace<0
* remove missing race values

. gen unemployedage = unemployed*age
(1 missing value generated)

.  gen unemployedage2 = unemployed*age2
(1 missing value generated)

. gen unemployedsex = unemployed*sex

*generate interaction terms
 sum inpatient linpatient healthstatus healthstatusb ghqb unemployed age age2 marriage sex race lincome unemployedage  unemployedsex
*create a table of summary statistics

ssc install outreg2

hettest linpatient unemployed

quietly reg linpatient unemployed, robust
outreg2 using inpatient.doc, replace ctitle(Model 1)

quietly reg linpatient unemployed age age2 marriage sex i.race lincome, robust
outreg2 using inpatient.doc, append ctitle(Model 2)

quietly reg linpatient unemployed age age2 marriage sex i.race lincome unemployedsex unemployedage, robust
outreg2 using inpatient.doc, append ctitle(Model 3)

hettest linpatient unemployed

*Table 1 - first set of regressions use OLS and  linpatientdays, with no covariates, covariates and covariates and interaction terms

quietly logit healthstatusb unemployed
outreg2 using healthstatusb2.doc, replace ctitle(Model 4)

quietly logit healthstatusb unemployed, or
outreg2 using healthstatusb2.doc, append ctitle(Model 4 OR) eform

quietly logit healthstatusb unemployed age age2 marriage sex i.race lincome
outreg2 using healthstatusb2.doc, append ctitle(Model 5)

quietly logit healthstatusb unemployed age age2 marriage sex i.race lincome, or
outreg2 using healthstatusb2.doc, append ctitle(Model 5 OR) eform

quietly logit healthstatusb unemployed age age2 marriage sex i.race lincome unemployedsex unemployedage 
outreg2 using healthstatusb2.doc, append ctitle(Model 6)

quietly logit healthstatusb unemployed age age2 marriage sex i.race lincome unemployedsex unemployedage, or 
outreg2 using healthstatusb2.doc, append ctitle(Model 6 OR) eform

*Table 2 -second set of regressions use health status converted to a binary variable and logit regresion, with no covariates, covariates and covariates and interaction terms


quietly logit ghqb unemployed, 
outreg2 using ghqb.doc, replace ctitle(Model 7)

quietly logit ghqb unemployed, or
outreg2 using ghqb.doc, append ctitle(Model 7 OR) eform


quietly logit ghqb unemployed age age2 marriage sex i.race lincome, 
outreg2 using ghqb.doc, append ctitle(Model 8 ) 

quietly logit ghqb unemployed age age2 marriage sex i.race lincome, or
outreg2 using ghqb.doc, append ctitle(Model 8 OR) eform

quietly logit ghqb unemployed age age2 marriage sex i.race lincome unemployedsex unemployedage,  
outreg2 using ghqb.doc, append ctitle(Model 9)

quietly logit ghqb unemployed age age2 marriage sex i.race lincome unemployedsex unemployedage, or 
outreg2 using ghqb.doc, append ctitle(Model 9 OR) eform


*Table 3 -second set of regressions use ghq (wellbeing) converted to a binary variable and logit regresion, with no covariates, covariates and covariates and interaction terms

*turning points
quietly reg ghqb c.age##c.age
margins, at(age=(18(1)80)) atmeans
marginsplot
di - (_b[c.age]/ (2*_b[c.age#c.age]) )


