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
SM13_Transation_code
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B15
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E15
    IF  '${Tcode}' != 'SM13'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Sleep	1
        Select Radio Button	wnd[0]/usr/radSEL_STOPPED
        Sleep	1
        Input Text	wnd[0]/usr/txtSEL_CLIENT	*
        Sleep	1
        Input Text	wnd[0]/usr/txtSEL_USER	*
        Sleep	1
        Input Text	wnd[0]/usr/txtFROM_DATE    28.08.2024    #${FROM_DATE}
        Sleep	1
        Input Text	wnd[0]/usr/txtTO_DATE    22.10.2024    #${TO_DATE}
        Sleep	1
        Click Element	wnd[0]/tbar[1]/btn[8]
        Sleep	1
        ${total_row}    Get Row Count  wnd[0]/usr/cntlGRID1/shellcont/shell   
        ${row}    Set Variable    ${total_row} updated record found
        Write Value To Excel    ${Excel_file_path}    ${Excel_Sheet}    E15    ${row}
    END