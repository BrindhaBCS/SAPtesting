*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${Olympus_SAP_SERVER}    ${symvar('Olympus_SAP_SERVER')}
${Olympus_SAP_connection}    ${symvar('Olympus_SAP_connection')}

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
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Olympus_User_Password')}      
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
Sldcheck   
    Run Transaction    /nSldcheck 
    Sleep    1
    Take Screenshot    Sldcheck_Olympus.jpg
    	    
System Logout
    Run Transaction    /nex
    Sleep    1