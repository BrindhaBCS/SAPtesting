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
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}   
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
SMT1_T_CODE_System_that_trust_current_system
    Run Transaction    /nSMT1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTRUST_STRIP/tabpTRUST_STRIP_FC2
    Sleep    5
    FOR    ${i}    IN RANGE    2    999
        ${select_1}=    Run Keyword And Return Status    Select Only    wnd[0]/usr/tabsTRUST_STRIP/tabpTRUST_STRIP_FC2/ssubTRUST_STRIP_SCA:RS_RFC_TT_UI:0120/cntlCLIENT_CONTAINER/shellcont/shell/shellcont[1]/shell[1]    ${i}
        Sleep    1
        Run Keyword If    not ${select_1}    Exit For Loop
        Click Toolbar Button    wnd[0]/usr/tabsTRUST_STRIP/tabpTRUST_STRIP_FC2/ssubTRUST_STRIP_SCA:RS_RFC_TT_UI:0120/cntlCLIENT_CONTAINER/shellcont/shell/shellcont[1]/shell[0]    DISPLAY
        Sleep    1
        ${click}=    Run Keyword And Return Status    Click Element    wnd[0]/usr/tabsTRUSTEDT_STRIP/tabpTRUSTEDT_STRIP_FC1
        Run Keyword If    not ${click}    Exit For Loop
        Take Screenshot    ${i}_System_that_trust_current_system_SYSTEM_SETTING.jpg
        Sleep    1
        Click Element    wnd[0]/usr/tabsTRUSTEDT_STRIP/tabpTRUSTEDT_STRIP_FC2
        Take Screenshot    ${i}_System_that_trust_current_system_ADMINISTRATION.jpg
        Sleep    1
        Click Element    wnd[0]/tbar[0]/btn[3]
        Sleep    1
        Unselect    wnd[0]/usr/tabsTRUST_STRIP/tabpTRUST_STRIP_FC2/ssubTRUST_STRIP_SCA:RS_RFC_TT_UI:0120/cntlCLIENT_CONTAINER/shellcont/shell/shellcont[1]/shell[1]    ${i}
        Sleep    1
    END