
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

*** Keywords ***
System Logon
    Start Process    ${symvar('Nike_SAP')}
    Sleep   5
    Connect To Session
    Open Connection     ${symvar('Nike_connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('CFG_CLIENT_role')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('CFG_USER_role')}    
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{CFG_PASS_role} 
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('CFG_PASS_role')}  
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10
    
user_role_assign
    Run Transaction    /nSU10
    Sleep    3
    ${user_function}    Get Length  ${symvar('user_names')}
    Log    ${user_function} 
    FOR    ${su10_index}    IN RANGE    ${user_function}
        ${user_input} =    Run Keyword And Return Status    Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${su10_index}]    ${symvar('user_names')}[${su10_index}]
        Run Keyword If    not ${user_input}    Exit For Loop
    END
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[18]
    Sleep    2
    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
    Sleep    2
    ${role_function}    Get Length  ${symvar('Test_role_assign')}
    Log    ${role_function}
    FOR    ${test_role_assign_index}    IN RANGE    ${role_function}
        ${role_assign_input} =    Run Keyword And Return Status    Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${test_role_assign_index}    AGR_NAME    ${symvar('Test_role_assign')}[${test_role_assign_index}]  
        Run Keyword If    not ${role_assign_input}    Exit For Loop
        Sleep    2
    END
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    2
    Take Screenshot    user_assign_to_role.jpg
    Sleep    1