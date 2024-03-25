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
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
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
Installed_Software_component_Version_SM51_T_CODE
    Run Transaction    /nSM51
    Sleep    2
    Click Element    wnd[0]/mbar/menu[4]/menu[11]
    Sleep    2
    Click Element    wnd[1]/usr/btnPRELINFO
    Sleep    1
    Click Element    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS
    Sleep    1
    Set Focus    wnd[2]/usr/tabsVERSDETAILS/tabpPROD_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0302/cntlPV_CU_CONTROL/shellcont/shell
    Sleep    1
    FOR    ${i}    IN RANGE    17
            ${selected_rows}    Selected Rows    wnd[2]/usr/tabsVERSDETAILS/tabpPROD_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0302/cntlPV_CU_CONTROL/shellcont/shell    ${i*17}    
            Take Screenshot    ${i+1}SM51.jpg
            Sleep    1
        END