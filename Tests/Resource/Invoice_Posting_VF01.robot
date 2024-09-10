*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    5
    Connect To Session
    Open Connection    ${symvar('TS4_connection')}
    Sleep    2    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('TS4_Client_Id')}
    Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('TS4_User_Name')}
    Sleep    2
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('sap_pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{TS4_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   2
System Logout
    Run Transaction   /nex
    # Sleep    2
VF01
    Run Transaction    VF01
    Sleep    2
    Input Text    wnd[0]/usr/tblSAPMV60ATCTRL_ERF_FAKT/ctxtKOMFK-VBELN[0,0]    ${symvar('Document_num')}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    2
    ${Document Value}    Get Value    wnd[0]/sbar/pane[0]
    Sleep    2
    Log    ${Document Value}
    ${Invoice No}    Extract Number    wnd[0]/sbar/pane[0]
    Log    ${Invoice No}
    Set Global Variable     ${Invoice No}
    Log To Console    **gbStart**Copilot_Status**splitKeyValue**${Invoice No}**gbEnd**
    