*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process
Library    ExcelLibrary
Library    String
Library    Collections
Library    DateTime
*** Variables ***
${Excel_file_path}    ${symvar('Excel_Name')}
${Excel_Sheet}    ${symvar('Sheet_Name')}
${START_ROW}    9
${END_ROW}      15
${MAX_FAILURES}    1
${table}    wnd[0]/usr
${k}    "          4"

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('DTA_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('DTA_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('DTA_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('DTA_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{DTA_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
System Logout
    Run Transaction   /nex
SM59_Transation_code
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B22
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E22
    IF  '${Tcode}' != 'SM59'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Expand Element	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}1
        Sleep	1
        Select Item	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*9}16	&Hierarchy
        Sleep	1
        Doubleclick Element	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*9}16	&Hierarchy
        Sleep	1
        Click Element	wnd[0]/tbar[1]/btn[27]
        Sleep	1
        ${total_row}    Get Row Count    wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell 
        Log To Console    ${total_row}
        ${combined_values}    Set Variable    ${EMPTY}
        ${values_array}    Create List
        FOR    ${row}    IN RANGE    0    ${total_row}
            ${action_value}    Get Cell Value   wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell    ${row}    ACTION
            Log    Action value from row ${row}: ${action_value}
            ${result_value}    Get Cell Value    wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell    ${row}    RESULT
            Log    Result value from row ${row}: ${result_value}
            ${row_values}    Create List    ${action_value}    ${result_value}
            Append To List    ${values_array}    ${row_values}
            Log To Console    ${row_values}
            ${combined_values}    Set Variable    ${combined_values}${row_values}\n
        END
        Write Value To Excel    ${Excel_file_path}    ${Excel_Sheet}    E22    ${combined_values}
    END