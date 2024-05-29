
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    SeleniumLibrary
Library    OperatingSystem
Library    String
Library     ExcelLibrary
Library     openpyxl
# Library    RPA.Excel.Files

***Variable***
${EXCEL_FILE}    D:\\RobotFramework\\SAPtesting\\Tests\\Resource\\Nike_TermKeys_2023.xlsx   

*** Keywords ***
System Logon
    Start Process    ${symvar('Nike_SAP')}
    Sleep   5
    Connect To Session
    Open Connection     ${symvar('Nike_connection')}
    SAP_Tcode_Library.Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('CFG_CLIENT_license')}
    SAP_Tcode_Library.Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('CFG_USER_license')}    
    SAP_Tcode_Library.Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{CFG_PASS_license} 
    # SAP_Tcode_Library.Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('CFG_PASS_license')}  
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10

License Key    
    ${row_count}    count excel rows    ${EXCEL_FILE}        
    Log to console    ${row_count}
    ${rows}    Evaluate    ${row_count} + 1
    
    FOR    ${row}    IN RANGE    2    ${rows}
        Log    row value: ${row}
        ${INSTALL_NO}    Read Excel    ${EXCEL_FILE}    Sheet2    ${row}    3    
        IF  '${INSTALL_NO}' == '*'    
            ${license_key}    Read Excel    ${EXCEL_FILE}    Sheet2    ${row}    1
            Log    Found license key: ${license_key}
            Set Global Variable     ${license_key}        
            Exit For Loop
        END
    END

Apply License
    Run Transaction    /n/bnwvs/main
    Sleep    3
    SAP_Tcode_Library.Click Element    wnd[1]/usr/btnBUTTON_1
    ${key}    copy to clipboard    ${license_key} 
    Log to console    ${key}    
    Sleep    3
    SAP_Tcode_Library.Click Element   wnd[1]/tbar[0]/btn[13]
    Take Screenshot    Import from clipboard.jpg
    Sleep    3
    Is license key invalid  wnd[2]    wnd[2]/tbar[0]/btn[0]  
    Take Screenshot    Continue.jpg
    Sleep    3
    SAP_Tcode_Library.Click Element    wnd[1]/tbar[0]/btn[11]
    Take Screenshot    OK.jpg
    Sleep    2
    SAP_Tcode_Library.Click Element    wnd[1]/tbar[0]/btn[0]
    Take Screenshot    Agree.jpg
    Sleep    2
    # SAP_Tcode_Library.Window Handling    wnd[1]    BCSET Activation warning    wnd[1]/tbar[0]/btn[0]        
    SAP_Tcode_Library.Click Element    wnd[1]/tbar[0]/btn[0]
    Take Screenshot    BCset.jpg
    Sleep    2

Login Box
    Open Browser    ${symvar('url')}    Chrome
    SeleniumLibrary.Capture Page Screenshot
    Maximize Browser Window
    Sleep    5
    Wait Until Element Is Visible    xpath://button[@type='submit']    40s
    SeleniumLibrary.Click Element    xpath://button[@type='submit']
    SeleniumLibrary.Capture Page Screenshot
    Wait Until Element Is Visible    xpath://input[@id='okta-signin-username']    40s
    SeleniumLibrary.Input Text    xpath://input[@id='okta-signin-username']    ${symvar('login_user')}
    SeleniumLibrary.Capture Page Screenshot
    Sleep    1
    Wait Until Element Is Visible    xpath://input[@id='okta-signin-password']     40s
    SeleniumLibrary.Input Text    xpath://input[@id='okta-signin-password']    ${symvar('login_pass')}
    SeleniumLibrary.Capture Page Screenshot
    Sleep    5
    SeleniumLibrary.Click Element    xpath://input[@type='submit']
    SeleniumLibrary.Capture Page Screenshot
    Sleep    5
    SeleniumLibrary.Click Element    xpath://input[@type='submit']
    SeleniumLibrary.Capture Page Screenshot
    Sleep    30s
    SeleniumLibrary.Capture Page Screenshot

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
    Save Excel Document     ${filepath}
    Close Current Excel Document