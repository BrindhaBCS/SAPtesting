*** Settings ***
Library    Process
Library     CustomSapGuiLibrary.py
Library    OperatingSystem
Library     ExcelLibrary
Library     openpyxl

*** Keywords ***
Read Excel
    [Arguments]    ${filepath}    ${sheetname}    ${rownum}    ${colnum}    
    Open Excel Document    ${filepath}    1
    Get Sheet    ${sheetname}    
    ${data}    Read Excel Cell    ${rownum}    ${colnum}        
    [Return]    ${data}
    Close Current Excel Document

Write Excel
    [Arguments]    ${filepath}    ${sheetname}    ${rownum}    ${colnum}    ${cell_value}
    Open Excel Document    ${filepath}    1
    Get Sheet    ${sheetname}  
    Write Excel Cell      ${rownum}       ${colnum}     ${cell_value}       ${sheetname}
    Save Excel Document     ${excel_path}
    Close Current Excel Document

SAP logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('login_client')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('login_user')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('login_password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Sleep    3s
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   5s

SAP Logout
    Run Transaction     /nex
    Sleep   5

Transaction code FB03
    Input Text  wnd[0]/usr/txtRF05L-BELNR       ${document}
    Sleep   2
    Input Text  wnd[0]/usr/ctxtRF05L-BUKRS       ${company_code}
    Sleep   2
    Input Text  wnd[0]/usr/txtRF05L-GJAHR        ${fiscal_year}
    Sleep   2
    Send Vkey    0
    Sleep   5
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   5

FB03 display the invoice document
    Run Transaction     /nFB03
    ${user_count}    Count Excel Rows     ${symvar('excel_path')}
    ${rows}=    Evaluate    ${user_count} + 1
    Log To Console      ${rows}
    Sleep   5
    FOR    ${row_count}    IN RANGE    2    ${rows}

        ${document}    Read Excel    ${symvar('excel_path')}    ${symvar('sheet_name')}    ${row_count}    9
        Log To Console  ${document}
        Set Global Variable     ${document}

        ${company_code}    Read Excel    ${symvar('excel_path')}    ${symvar('sheet_name')}    ${row_count}    10
        Log To Console  ${company_code}
        Set Global Variable     ${company_code}

        ${fiscal_year}    Read Excel    ${symvar('excel_path')}    ${symvar('sheet_name')}    ${row_count}    11
        Log To Console  ${fiscal_year}
        Set Global Variable     ${fiscal_year}
        Transaction code FB03

    END



