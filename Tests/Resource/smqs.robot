*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process

*** Keywords ***
SAP Logonn
    Start Process    ${sapvar('sap_server')}
    Sleep    2
    Connect To Session
    Sleep    2
    Open Connection    ${sapvar('server')}
    Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${sapvar('user_name')}
    Sleep    2
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${sapvar('password')}
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[0]
    Sleep    2
    Multiple logon Handling     wnd[1]    wnd[1]/usr/radMULTI_LOGON_OPT2    wnd[1]/tbar[0]/btn[0]
    Sleep   1

SMQS_tcodes
    Run Transaction    smqs
    Sleep    1
    Click Element    wnd[0]/mbar/menu[2]/menu[1]
    Sleep    2
    Take Screenshot
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Take Screenshot
    Sleep    2
    Click Element    wnd[0]/mbar/menu[2]/menu[0]
    Sleep    2
    Send Vkey    82
    Sleep    2
    Take Screenshot
    Sleep    2
    Send Vkey    82
    Sleep    2
    Take Screenshot
    # Run Transaction    /n
    # Sleep    2

SMQ1_tcodes
    Run Transaction    /nsmq1
    Sleep    2
    Take Screenshot
    Sleep    2
System Logout
    Run Transaction   /nex
    Sleep    5   

    