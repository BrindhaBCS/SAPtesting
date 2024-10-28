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
ST04_Transation_code    
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B26
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E26
    IF  '${Tcode}' != 'ST04'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Select Item    wnd[0]/shellcont[1]/shell/shellcont[1]/shell	${SPACE*8}101	Task
        Sleep	1
        ${data_volume_size}    Get Value    wnd[0]/usr/txtHDB_OVERVIEW-DB_STORAGE_DATA
        Log To Console    ${data_volume_size}
        ${log_volume_size}    Get Value    wnd[0]/usr/txtHDB_OVERVIEW-DB_STORAGE_LOG
        Log To Console    ${log_volume_size}
        Write Value To Excel    ${Excel_file_path}    ${Excel_Sheet}    E26    ${data_volume_size}\n${log_volume_size}
    END