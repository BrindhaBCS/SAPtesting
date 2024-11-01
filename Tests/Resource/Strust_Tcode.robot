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
Strust_Tcode
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B29
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E29
    IF  '${Tcode}' != 'STRUST'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Sleep    1
        clear excel cell   ${Excel_file_path}    ${Excel_Sheet}    E29
        Click Element    wnd[0]/tbar[1]/btn[25]  
        Sleep    1
        ${Row_count}    Get Row Count    wnd[0]/usr/cntlPK_CTRL/shellcont/shell
        IF  '${Row_count}' == '0'
            Log To Console    Check your System Certificate is not there..
        ELSE
            FOR    ${row}    IN RANGE    0    ${Row_count}
                ${Owner}    Get Sap Table Value    table_id=wnd[0]/usr/cntlPK_CTRL/shellcont/shell    row_num=${row}   column_id=SUBJECT
                ${FromDate}    Get Sap Table Value    table_id=wnd[0]/usr/cntlPK_CTRL/shellcont/shell    row_num=${row}   column_id=DATEFROM
                ${ToDate}    Get Sap Table Value    table_id=wnd[0]/usr/cntlPK_CTRL/shellcont/shell    row_num=${row}   column_id=DATETO

                ${current_date}=   Get Current Date   result_format=%d.%m.%Y
                ${compare_date}=    Convert Date   ${ToDate}   date_format=%d.%m.%Y
                ${reference_date}=    Convert Date   ${current_date}   date_format=%d.%m.%Y
                IF    '${ToDate}' >= '${reference_date}'
                    Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D29   value=3
                ELSE
                    Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D29   value=1
                END
                ${Output_Log}    Set Variable    Owner:${Owner} FromDate:${FromDate} ToDate:${ToDate}
                ${current_value}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E29
                ${value}    Set Variable    ${current_value}\n${Output_Log}
                Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E29    value=${value}
            END
        END
    END