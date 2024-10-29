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
SM66_Tcode
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B9
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E9
    IF  '${Tcode}' != 'SM66'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Sleep    0.5
        Click Element    wnd[0]/tbar[1]/btn[13]
        Sleep    0.5
        Click Element    wnd[0]/tbar[1]/btn[8]
        Sleep    0.5
        ${row_count}    Get Row Count    table_id=wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell
        IF  '${row_count}' == '0'
            Log To Console    In your Transaction SM66 System not there. 
        ELSE    
            FOR    ${row_num}    IN RANGE    0    ${row_count}
                ${name}    Get Sap Table Value    table_id=wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell    row_num=${row_num}    column_id=SERVER_NAME
                ${status}    Get Sap Table Value    table_id=wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell    row_num=${row_num}    column_id=STATE_DISP
                ${date}    Get Current Date    result_format=%d.%m.%Y.%H.%M.%S  
                ${value}    Set Variable    SeverName:${name}--Status:${status} Date:${date}
                ${current_value}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E9
                ${new_value}    Set Variable    ${current_value}\n${value}
                Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E9    value=${new_value}
                IF    '${status}' == 'Running'
                    Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D9    value=1
                ELSE
                    Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D9    value=3
                END
                
            END
        END
    END