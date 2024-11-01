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
SM12_TRANSATION_CODE
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B14
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E14
    IF  '${Tcode}' != 'SM12'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Sleep	1
        Clear Field Text    wnd[0]/usr/subAREA_TOP:RS_ENQ_ADMIN:0111/ctxtENQ_LOCK_FILTER-CLIENT
        Input Text	wnd[0]/usr/subAREA_TOP:RS_ENQ_ADMIN:0111/ctxtENQ_LOCK_FILTER-CLIENT    *
        Sleep	0.5
        Clear Field Text    wnd[0]/usr/subAREA_TOP:RS_ENQ_ADMIN:0111/ctxtENQ_LOCK_FILTER-USERNAME
        Input Text	wnd[0]/usr/subAREA_TOP:RS_ENQ_ADMIN:0111/ctxtENQ_LOCK_FILTER-USERNAME	*
        Sleep	0.5
        Click Element	wnd[0]/usr/subAREA_TOP:RS_ENQ_ADMIN:0111/btnLOAD
        Sleep	0.5
        ${lock_row}    Get Row Count    wnd[0]/usr/subAREA_MAIN:RS_ENQ_ADMIN:0110/cntlCONTAINER_MAIN/shellcont/shell/shellcont[1]/shell
        Log To Console    ${lock_row}
        ${lock_time}    Read Table Column    wnd[0]/usr/subAREA_MAIN:RS_ENQ_ADMIN:0110/cntlCONTAINER_MAIN/shellcont/shell/shellcont[1]/shell    DATETIME
        Log To Console    ${lock_time}
        ${combined_lock_time}    Set Variable    # Initialize an empty variable to collect all times
        FOR    ${i}    IN RANGE    0    ${lock_row}
            ${lock_time_value}=    Set Variable    ${lock_time}[${i}]
            ${combined_lock_time}=    Set Variable    ${combined_lock_time}\n${lock_time_value}
        END
        Write Value To Excel    ${Excel_file_path}    ${Excel_Sheet}    E14    ${combined_lock_time}
        Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D14   value=1
    END