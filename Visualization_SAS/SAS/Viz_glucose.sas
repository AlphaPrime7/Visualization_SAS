/******************
Input: glucose.sav
Output: SAS-visualization_glucose.pdf
Written by:Tingwei Adeck
Date: Sep 26 2022
Description: Introduction to data visualization in SAS
Requirements: Need library called project, glucose.sav,cholesterol.sav file.
Dataset description: Data obtained from Dr. Gaddis (small dataset)
Input: glucose.sav
Output: SAS-visualization_glucose.pdf
******************/

/*DATA models (The way to read files when working locally, notice I am working on the SAS cloud)
INFILE 'c:\MyRawData\Models.dat' TRUNCOVER;
INPUT Model $ 1-12 Class $ Price Frame $ 28-38;
RUN;*/

%let path=/home/u40967678/sasuser.v94;


libname project
    "&path/sas_umkc/input";

/*FILENAME REFFILE '/home/u40967678/sasuser.v94/sas_umkc/src/chol.csv'*/
filename glucose
    "&path/sas_umkc/input/glucose.sav";
    
ods pdf file=
    "&path/sas_umkc/output/SAS-visualization_glucose.pdf";
    
options papersize=(8in 4in) nonumber nodate;

/* Assuming items are separated by a space */
/*%let data_list = %str(glucose cholesterol);*/

proc import file= glucose
    out=project.glucose
	dbms=sav
	replace;
run;

title 'Clustered Bar Chart'; ***no stat = sum;
proc sgpanel data=project.glucose;
  panelby Person_Number / layout=columnlattice onepanel
          colheaderpos=bottom rows=1 novarname noborder;
  vbar Time_after_eating / group=Time_after_eating response=Blood_Glucose_A  group=Time_after_eating statlabel;
  colaxis display=none;
  rowaxis grid;
  run;
  
ods pdf close;
