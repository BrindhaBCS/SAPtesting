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
ST22_Transation_code
    ${Tcode}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=B18
    Clear Excel Cell    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E18
    IF  '${Tcode}' != 'ST22'
        Log To Console    Check Your Transcation
    ELSE
        Run Transaction    /n${Tcode}
        Click Element	wnd[0]/mbar/menu[2]/menu[1]
        Sleep	1
        ${FROM_DATE}=    Get Current Date    result_format=%d.%m.%Y    increment=-5 day
        Input Text	wnd[0]/usr/ctxtS_DATUM-LOW	${FROM_DATE}
        Sleep	1
        ${TO_DATE}=    Get Current Date    result_format=%d.%m.%Y
        Input Text	wnd[0]/usr/ctxtS_DATUM-HIGH    ${TO_DATE}
        Sleep	1
        Click Element	wnd[0]/tbar[1]/btn[8]
        Sleep	1
        FOR    ${i}    IN RANGE    ${START_ROW}    ${END_ROW}+1
            TRY
                ${value}    Get Value    wnd[0]/usr/lbl[1,${i}]
                Log To Console    Label value at column ${i}: ${value}
                ${current_value}    Read Value From Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=E18
                Write Value To Excel    ${Excel_file_path}    ${Excel_Sheet}    E18    ${current_value}\n${value}
                Write Value To Excel    file_path=${Excel_file_path}    sheet_name=${Excel_Sheet}    cell=D18   value=1
            EXCEPT
                Continue For Loop
            END 
            
        END
    END