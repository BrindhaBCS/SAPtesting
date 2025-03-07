*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    Merger.py

*** Variables ***
${programe_name}    RSEMASSA
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
    

SE38

    Run Transaction    se38
	Sleep	2
	Input Text	wnd[0]/usr/ctxtRS38M-PROGRAMM	${programe_name}
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	2
	Input Text	wnd[0]/usr/ctxtS_PARTYP-LOW	LS
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	2
    Take Screenshot    002_SE38_01.jpg
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    1

    