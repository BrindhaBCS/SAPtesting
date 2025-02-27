*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${ABB_Olympus_SAP_SERVER}    ${symvar('ABB_Olympus_SAP_SERVER')}
${ABB_Olympus_SAP_connection}    ${symvar('ABB_Olympus_SAP_connection')}

*** Keywords ***
System Logon
# ABAP system credentials and server
    Start Process     ${symvar('ABB_Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('ABB_Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABB_Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABB_Olympus_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABB_Olympus_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Olympus_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
SOIN   
    Run Transaction    /nSOIN 
    Sleep   2
   
    Take Screenshot    SOIN.jpg
    Sleep    1   
System Logout
    Run Transaction    /nex
    Sleep    1