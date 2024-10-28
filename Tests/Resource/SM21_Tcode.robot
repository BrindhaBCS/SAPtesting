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
SM21_Tcode
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B10
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E10
    IF  '${Tcode}' != 'SM21'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Sleep    0.5
        ${FROM_DATE_SM21}=    Get Current Date    result_format=%d.%m.%Y    increment=-1 day
        Input Text    wnd[0]/usr/ctxtDATE_FR    ${FROM_DATE_SM21}
        ${TO_DATE_SM21}    Get Current Date    result_format=%d.%m.%Y
        Input Text    wnd[0]/usr/ctxtDATE_TO    ${TO_DATE_SM21}
        Sleep    0.5
        Clear Field Text    wnd[0]/usr/ctxtINSTOPT-LOW
        Select Checkbox    wnd[0]/usr/chkRB1
        Sleep    0.5
        Click Element    wnd[0]/tbar[1]/btn[8]
        Sleep    0.5
        ${row_count}    Get Row Count    table_id=wnd[0]/usr/cntlCONTAINER_0100/shellcont/shell/shellcont[1]/shell
        IF  '${row_count}' == '0'
            Log To Console    In your Transaction SM21 System not there. 
        ELSE
            FOR    ${row_num}    IN RANGE    0    ${row_count}
                ${name}    Get Sap Table Value    table_id=wnd[0]/usr/cntlCONTAINER_0100/shellcont/shell/shellcont[1]/shell    row_num=${row_num}    column_id=MESSAGEID
                ${status}    Get Sap Table Value    table_id=wnd[0]/usr/cntlCONTAINER_0100/shellcont/shell/shellcont[1]/shell    row_num=${row_num}    column_id=TEXT
                ${date}    Get Current Date    result_format=%d.%m.%Y.%H.%M.%S  
                ${value}    Set Variable    ${row_num} . ${name}--${status}
                ${current_value}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E10
                ${new_value}    Set Variable    ${current_value}\n${value}
                Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E10    value=${new_value}
            END
        END
    END