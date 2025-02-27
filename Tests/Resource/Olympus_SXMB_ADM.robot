*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py 

*** Keywords ***
System Logon
    Start Process     ${symvar('Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Olympus_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Olympus_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Olympus_User_Password}
    Send Vkey    0
    Multiple Logon Handling   wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
 
SXMB_ADM_Tcodes
    Run Transaction    /nSXMB_ADM
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[0]
	Sleep	2
    Take Screenshot    SXMB_ADM.jpg
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Run Transaction    /nex
    Sleep    2