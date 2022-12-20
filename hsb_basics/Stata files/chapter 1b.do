
#d;
* input the data ;
* keep only the variables and cases needed for the analysis ;
use hsb.dta;
keep schoolid mathach ses minority;
keep if schoolid <= 1317 ;

* get the needed descriptive statistics ;
#d;
tab minority;
tabstat mathach ses minority, statistics(mean sd) ;
tabstat mathach ses minority, statistics(mean sd) by(schoolid);

* obtain selected descriptive graphics ;
#d;
hist mathach;
graph box mathach;
#d;
scatter mathach ses;
scatter mathach ses, by(schoolid);

* perform bivariate regression ;
#d;
regress mathach ses;

# plot predicted values against ses (the independent variable) ;
#d;
predict yhat, xb;
#d;
twoway (scatter mathach ses, msize(small))
       (line yhat ses, lwidth(medthick) lpatt(solid)),
        ytitle(Math Achievement) xtitle(Socioeconomic Status);

* create dummy variables for the remaining cases ;		
#d;
gen s1=0;  replace s1=1 if schoolid==1224;
gen s2=0;  replace s2=1 if schoolid==1288;
gen s3=0;  replace s3=1 if schoolid==1296;
gen s4=0;  replace s4=1 if schoolid==1308;
gen s5=0;  replace s5=1 if schoolid==1317;
/* =====================
* alternate method of computing dummy variables ;
#d;
drop s1-s5;
tabulate schoolid, generate(s);
tab1 s1-s5;
===================== */

* get tables of each dummy to verify the were correctly defined ;
#d;
tab schoolid s1;
tab schoolid s2;
tab schoolid s3;
tab schoolid s4;
tab schoolid s5;
* ===================== ;

* compute regressions with dummies, with and without ses ;
#d;
regress mathach ses s2-s5;
regress mathach s2-s5;
/* regress mathach s1-s5; include all dummies */
/* regress mathach s1-s5, nocons;  include all dummies without intercept */
#d;
regress mathach ses s2-s5;
est sto r1;
#d;
test (s2=0)(s3=0)(s4=0)(s5=0);
#d;
regress mathach s2-s5;
#d;
test (s2=0)(s3=0)(s4=0)(s5=0);
est sto r2;
lrtest r1 r2;
