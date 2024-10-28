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
ST02_Transation_code
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B24
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E24
    IF  '${Tcode}' != 'ST02'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}   
        ${total_rows}    Get Length    ${table}
        Log To Console    ${total_rows}
        ${swape_size}    Get value    wnd[0]/usr/lbl[92,13] 
        Log To Console    ${swape_size}
        IF    ${swape_size} > 0    
            Log To Console    Swap size exceeded 0
        ELSE    
            Log To Console    Swap size is within acceptable limits.
            ${current_value}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E124
            Write Value To Excel    ${Excel_file_path}    ${Excel_Sheet}    E24    ${current_value}\n${swape_size}
        END
    END