/********************************************************
***Program Information***
Date: 10/13/2021
Programmer: Wayne Hileman
Purpose/Program Name: Set Environment Variables
Version Info/Notes: v1 
     Set environment variables for connection strings, log paths, etc.
	Include this program at the top of stored processes in the Report Portal. 
	

***Data Date/Snapshot***
First Day of Testing active and inactive records

***Variables Used ***
&SAVE_DATASRC_DVALID: libname odbc connection string
&SAVE_SESSION_TIMEOUT: 
&t1: time t1
&stp: name of stored process

Also uses  

Revision History:
mm/dd/yyyy - wkh - updated blah blah blah
********************************************************/

data _null_ ;
call symput("SAVE_DATASRC_DVALID","odbc datasrc=datavalidation schema=dbo") ;
call symput("SAVE_SESSION_TIMEOUT","3600") ;
call symputx('t1',datetime());
call symputx('stp',scan("&_PROGRAM.",-1,'/'));
run;

libname dvalid &SAVE_DATASRC_DVALID.;
libname log "\SASConfig\Lev1\SASAppCompute\StoredProcessServer\Logs\portal";

* Set session macro variables ;
proc sql noprint;
	select SRVNAME_DATA_SHARE,schoolyear,CollectionID,QuarterlyId, protocol
	into :SRVNAME_DATA_SHARE, :CY, :CCID, :QID, :protocol trimmed
	from dvalid.sas_portal_env 
	where upper("&_SRVNAME") = upper(SRVNAME_WEB) ; 
quit;

%let SAVE_SASSHARE = \\&SRVNAME_DATA_SHARE; 
/*%let project=&SAVE_SASSHARE\_Restricted\_Projects\Baseball;*/
/*%let source=&project.\Source Data;*/
/*%let path=&project.\Sub Programs;*/
/*libname source "&source.";*/
*%put _global_;
