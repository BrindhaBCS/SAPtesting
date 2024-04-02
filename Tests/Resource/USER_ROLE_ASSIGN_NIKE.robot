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
    
user_role_assign
    Run Transaction    /nSU10
    Sleep    1
    FOR    ${su10_index}    IN RANGE    1000 
        ${user_input} =    Run Keyword And Return Status    Input Text    wnd[0]/usr/tblSAPLSUID_MAINTENANCETC_USERS/ctxtSUID_ST_BNAME-BNAME[0,${su10_index}]    ${symvar('user_names')}[${su10_index}]
        Run Keyword If    not ${user_input}    Exit For Loop
    END
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[18]
    Sleep    1
    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpACTG
    Sleep    1
    FOR    ${test_role_assign_index}    IN RANGE    1000
        ${role_assign_input} =    Run Keyword And Return Status    Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpACTG/ssubMAINAREA:SAPLSUID_MAINTENANCE:1106/cntlG_ROLES_CONTAINER/shellcont/shell    ${test_role_assign_index}    AGR_NAME    ${symvar('Test_role_assign')}[${test_role_assign_index}]  
        Run Keyword If    not ${role_assign_input}    Exit For Loop
        Sleep    1
    END
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    1
    Take Screenshot    user_assign_to_role.jpg
    Sleep    1