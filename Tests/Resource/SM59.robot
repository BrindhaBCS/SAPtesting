*** Settings ***
Library    Process
Library     CustomSapGuiLibrary.py
Library    OperatingSystem
Force Tags  sldapicust-gv

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

SM59
    Run Transaction     /nsm59
    Click Element   wnd[0]/mbar/menu[1]/menu[5]
    Input Text  wnd[1]/usr/tabsG_SELONETABSTRIP/tabpTAB001/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/txtG_SELFLD_TAB-LOW[0,24]       ${symvar('destination')}
    Sleep   5
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep  5s
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   5s
    Take Screenshot
    Sleep   5s
    Click Element   wnd[0]/usr/tabsTAB_SM59/tabpSIGN
    Sleep   5s
    Take Screenshot
