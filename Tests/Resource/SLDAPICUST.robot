*** Settings ***
Library    Process
Library     CustomSapGuiLibrary.py
Library    OperatingSystem

*** Keywords ***
SAP logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('login_password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Sleep    3s
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   5s

SAP Logout
    Run Transaction     /nex
    Sleep   5

Sldapicust
    Run Transaction    /nsldapicust
    Sleep    2
    Take Screenshot
    ${destination}  get cell value from gridtable       wnd[0]/usr/cntlCONTAINER/shellcont/shell
    Set Global Variable    ${destination}
    Log To Console     **gbStart**username**splitKeyValue**${destination}**gbEnd**
