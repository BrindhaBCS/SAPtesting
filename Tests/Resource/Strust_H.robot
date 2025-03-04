*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}            
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{HEINEKEN_PASSWORD}  
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg
System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10

STRUST
    Run Transaction     /nstrust
    Send Vkey    0
    Take Screenshot    000_PSE.jpg
    Sleep    2
    
    
System_PSE
    Expand Node	wnd[0]/shellcont/shell	PROG<SYST>
	Sleep	2
	
	Double Click On Tree Item	wnd[0]/shellcont/shell	PROG<SYST>1
	Sleep	2
    Select Node    wnd[0]/shellcont/shell	PROG<SYST>1
    Take Screenshot    001_PSE.jpg

SNC_SAPCRYPTOLIB

    Expand Node	wnd[0]/shellcont/shell	PROG<SNCS>
	Sleep	2
	Double Click On Tree Item	wnd[0]/shellcont/shell	PROG<SNCS>1
	Sleep	2
    Select Node    wnd[0]/shellcont/shell	PROG<SNCS>1
    Take Screenshot    002_SNCS.jpg



SSL server standard  
    Expand Node	wnd[0]/shellcont/shell	SSLSDFAULT
	Sleep	2      
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLSDFAULT1    
    Sleep    2
    Select Node    wnd[0]/shellcont/shell	SSLSDFAULT1
    Take Screenshot    003_SSLSDFAULT1.jpg
    Sleep    2


SSL client SSL Client (Anonymous)
    Expand Node	wnd[0]/shellcont/shell	SSLCANONYM
	Sleep	2 
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCANONYM1    
    Sleep    2
    Select Node    wnd[0]/shellcont/shell	SSLCANONYM1
    Take Screenshot    004_SSLCANONYM1.jpg
    Sleep    2
    

SSL client SSL Client (Standard)
    Expand Node	wnd[0]/shellcont/shell	SSLCDFAULT
	Sleep	2
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCDFAULT1    
    Sleep    2
    Select Node    wnd[0]/shellcont/shell	SSLCDFAULT1
    Take Screenshot    005_SSLCDFAULT1.jpg
    Sleep    2


    