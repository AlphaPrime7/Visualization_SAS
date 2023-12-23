/******************
Input: chol.csv
Output: SAS-visualization_cholesterol.pdf
Written by:Tingwei Adeck
Date: Sep 26 2022
Description: Introduction to data visualization in SAS
Requirements: Need library called work (default sas folder and files saved here are temporary), chol.csv file.
Dataset description: Data obtained from Dr. Gaddis (small dataset)
Input: chol.csv
Output: SAS-visualization_cholesterol.pdf
******************/

/*DATA models (The way to read files when working locally, notice I am working on the SAS cloud)
INFILE 'c:\MyRawData\Models.dat' TRUNCOVER;
INPUT Model $ 1-12 Class $ Price Frame $ 28-38;
RUN;*/

ods pdf file=
    "&path/sas_umkc/output/SAS-visualization_cholesterol.pdf";
    
options papersize=(8in 4in) nonumber nodate;

title 'Race Pie Chart'; 
proc gchart data=work.import;
    pie Race / explode='Jazz' plabel=(h=1.5 color=blue);;
run;

title 'Scatterplot of Weight vs Cholesterol'; 
proc sgplot data=work.import;
    scatter x= Cholesterol y=Weight;
    reg x = Cholesterol  y = Weight  / clm cli;
run;

title 'Scatterplot of Weight vs Cholesterol'; 
proc sgplot data=work.import;
    scatter x= Cholesterol y=Weight;
    ellipse x = Cholesterol  y = Weight;
run;

proc sql noprint;
create table project.cholmeans as
select 
    Weight_group,
    mean(Cholesterol) as Cholesterol_means, 
    mean(Cholesterol) - stderr(Cholesterol) as lowStdChol,    
    mean(Cholesterol) + stderr(Cholesterol) as highStdChol,
from work.import
group by Weight_group;
quit;

proc print data = project.cholmeans;
run;

title 'Boxplot of cholesterol means'; 
proc sgplot data=project.cholmeans;
scatter x= Weight_group y=Cholesterol_means / 
    yerrorlower=lowStdChol yerrorupper=highStdChol group=Weight_group;
series x=Weight_group y= Cholesterol_means/ group=Weight_group;
run;

title 'Clustered Boxplot of cholesterol means'; 
proc boxplot data=work.import;
   plot Cholesterol*Sex(Weight_group) / odstitle="Clustered boxplot" blocklabelpos=above;
run;

title 'Clustered Boxplot of cholesterol means with color differentation'; 
proc sgplot data=work.import;
   vbox Cholesterol / category=Weight_group group=Sex;
   xaxis label="Weight group";
   keylegend / title="Sex";
run; 

data attrmap;
   input id $ Sex $10. @19 fillcolor $8.;
   datalines;
Sex 'Female'    beige    
Sex 'Male'  cx663D29
;
run;

title 'Clustered Bar chart for Weight Groups';
proc sgplot data=work.import dattrmap=attrmap;
   /* The ATTRID option references the name of the attribute map */
   vbar Weight_group / stat = mean  group=Sex response=Cholesterol groupdisplay=cluster 
              dataskin=pressed attrid=Sex;
   xaxis display=(nolabel noticks);
   yaxis label='Mean cholesterol';
   keylegend / title='Clustered Bar chart';
run;

title 'Clustered Bar chart for Age groups';
proc sgplot data=work.import dattrmap=attrmap;
   /* The ATTRID option references the name of the attribute map */
   vbar Age_group / stat = mean  group=Sex response=Cholesterol groupdisplay=cluster 
              dataskin=pressed attrid=Sex;
   xaxis display=(nolabel noticks);
   yaxis label='Mean cholesterol';
   keylegend / title='Clustered Bar chart';
run;

title 'Scatterplot of Age vs Cholesterol'; 
proc sgplot data=work.import;
    scatter x= Cholesterol y=Age;
    reg x=Cholesterol  y=Age  / clm cli;
run;

ods pdf close;