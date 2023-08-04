/*the macro does not work as intended*/
%macro import_multfiles(iter_end);
	%let i = 1;
	%do %while (%scan(&data_list , &i, %str( )) NE %str());
    %let item = %scan(&data_list , &i, %str( ));

    proc import file= i
    out=project.i
	dbms=sav
	replace;
run;
%end;
%mend import_multfiles;

%import_multfiles();

 
