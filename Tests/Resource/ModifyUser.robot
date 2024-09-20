*** Settings ***
Library    Process
Library    ExcelLibrary
Library    SAP_Tcode_Library.py
Library    openpyxl

*** Keywords *** 
System Logon
    Start Process    ${symvar('SAP_SERVER')}
    Connect To Session
    Open Connection     ${symvar('User_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('User_Client')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Login_User')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{DEV_PASSWORD}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('DEV_PASSWORD')}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
System Logout
    Run Transaction   /nex
Modify User
    Run Transaction    /nSU01
    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('SAP_User_ID')}
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[7]
    Window Handling    wnd[1]    Address Maintenance      wnd[1]/usr/btnBUTTON_2
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[19]
    Sleep    1
    Click Element    wnd[0]/usr/tabsTABSTRIP1/tabpPROF
    Sleep    1
    delete all profile
    Sleep    2
    ${last_profile_index}    Set Variable    0
    FOR    ${role}    IN    @{symvar('Requested_SAP_Roles')}
        ${row_count}    Count Excel Rows     ${symvar('User_Profile_Excelpath')}       ${role}
        ${total_rows}=    Evaluate    ${row_count} + 1
        FOR    ${row}    IN RANGE    1    ${total_rows}
            ${i}    Evaluate    ${last_profile_index} + ${row}
            ${j}    Evaluate    ${i} - 1
            ${profile}    Read Excel Cell Value    ${symvar('User_Profile_Excelpath')}    ${role}    ${row}    1
            Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpPROF/ssubMAINAREA:SAPLSUID_MAINTENANCE:1103/cntlG_PROFILES_CONTAINER/shellcont/shell    ${j}    PROFILE    ${profile}
            Send Vkey    0
        END
        ${total}=    Evaluate    ${last_profile_index} + ${row_count}
        ${last_profile_index}    Set Variable    ${total}
        
    END
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    1
    ${result}    Get Value    wnd[0]/sbar/pane[0]
    Log    ${result}
    Log To Console    ${result}