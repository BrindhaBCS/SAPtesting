*** Settings ***
Library    Process
Library    ExcelLibrary
Library    SAP_Tcode_Library.py
Library    openpyxl

*** Keywords *** 
System Logon
    Start Process    ${symvar('dev_SAP_SERVER')}
    Connect To Session
    Open Connection     ${symvar('dev_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('dev_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('dev_User_Name')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{dev_PASSWORD}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('dev_PASSWORD')}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
System Logout
    Run Transaction   /nex
Modify User
    Run Transaction    /nSU01
    Input Text    wnd[0]/usr/ctxtSUID_ST_BNAME-BNAME    ${symvar('dev_TestUser_Name')}
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
    Open Excel Document    ${symvar('User_excel_path')}    ${symvar('Department1')}
    ${column_data}=    Read Excel Column    1    sheet_name=${symvar('Department1')}
    ${row_count}=    Get Length    ${column_data}
    Log    Column data length: ${row_count}
    FOR    ${row}    IN RANGE    1    ${row_count}
        ${value}=    Set Variable    ${column_data}[${row}]
        Log    ${value}
        ${sap_cell_range}=    Evaluate    ${row} -1
        Set Cell Value    wnd[0]/usr/tabsTABSTRIP1/tabpPROF/ssubMAINAREA:SAPLSUID_MAINTENANCE:1103/cntlG_PROFILES_CONTAINER/shellcont/shell    ${sap_cell_range}    PROFILE    ${value}
        Send Vkey    0
    END
    Close Current Excel Document
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    1
    ${result}    Get Value    wnd[0]/sbar/pane[0]
    Log    ${result}
    Log To Console    ${result}