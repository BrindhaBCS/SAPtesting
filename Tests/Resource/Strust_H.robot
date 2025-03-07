*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    Merger.py

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}            
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{DL1_PASSWORD}  
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
System Logout
    Run Transaction   /nex
    Sleep    5
    

STRUST
    Run Transaction     /nstrust
    Send Vkey    0
    Take Screenshot    007_strust_01.jpg
    Sleep    2
    
    
System_PSE
    Expand Node	wnd[0]/shellcont/shell	PROG<SYST>
	Sleep	2
	
	Double Click On Tree Item	wnd[0]/shellcont/shell	PROG<SYST>1
	Sleep	2
    Select Node    wnd[0]/shellcont/shell	PROG<SYST>1
    Take Screenshot    007_SYST_01.jpg

SNC_SAPCRYPTOLIB

    Expand Node	wnd[0]/shellcont/shell	PROG<SNCS>
	Sleep	2
	Double Click On Tree Item	wnd[0]/shellcont/shell	PROG<SNCS>1
	Sleep	2
    Select Node    wnd[0]/shellcont/shell	PROG<SNCS>1
    Take Screenshot    007_SNCS_01.jpg



SSL server standard  
    Expand Node	wnd[0]/shellcont/shell	SSLSDFAULT
	Sleep	2      
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLSDFAULT1    
    Sleep    2
    Select Node    wnd[0]/shellcont/shell	SSLSDFAULT1
    Take Screenshot    007_SSLSDFAULT1_01.jpg
    Sleep    2


SSL client SSL Client (Anonymous)
    Expand Node	wnd[0]/shellcont/shell	SSLCANONYM
	Sleep	2 
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCANONYM1    
    Sleep    2
    Select Node    wnd[0]/shellcont/shell	SSLCANONYM1
    Take Screenshot    007_SSLCANONYM1_01.jpg
    Sleep    2
    

SSL client SSL Client (Standard)
    Expand Node	wnd[0]/shellcont/shell	SSLCDFAULT
	Sleep	2
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCDFAULT1    
    Sleep    2
    Select Node    wnd[0]/shellcont/shell	SSLCDFAULT1
    Take Screenshot    007_SSLCDFAULT1_01.jpg
    Sleep    2

    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    1

    Convert pdf    ${symvar('screenshot_directory')}    ${symvar('screenshot_directory')}\\${symvar('PDFFILE_NAME')}


    