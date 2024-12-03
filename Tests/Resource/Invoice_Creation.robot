*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    Collections
#Library    ../../Symphony/Lib/site-packages/SeleniumLibrary/__init__.py
Resource    ../Web/Support_Web.robot
Library    ExcelLibrary
Library    DateTime

*** Variables ***    

${PO_Creation_File}      C:\\RobotFramework\\sap_testing\\Tests\\Resource\\Purchase_Order_Details.xlsx
${PO_Creation_Sheet}     Purchase order
${GR_Creation_Sheet}     Goods Receipt
${Invoice_Creation_Sheet}     Invoice Receipt
${PO_Header}    ${SPACE*10}20
${invoice_date}    06.11.2024


*** Keywords ***

Read Excel Sheet
    [Arguments]    ${Excel_file}    ${sheetname}    ${rownum}    ${colnum}    
    Open Excel Document    ${Excel_file}    1
    Get Sheet    ${sheetname}    
    ${data}    Read Excel Cell    ${rownum}    ${colnum}        
    [Return]    ${data}
    Log To Console    ${data}
    Close Current Excel Document

Write Excel
    [Arguments]    ${filepath}    ${sheetname}    ${rownum}    ${colnum}    ${cell_value}
    Open Excel Document    ${filepath}    1
    Get Sheet    ${sheetname}  
    Write Excel Cell      ${rownum}       ${colnum}     ${cell_value}       ${sheetname}
    Save Excel Document     ${filepath}
    Close Current Excel Document 

System Logon
    Start Process     ${symvar('P2P_SAP_SERVER')}     
    Sleep    2s
    Connect To Session
    Open Connection    ${symvar('P2P_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('P2P_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('P2P_User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('P2P_User_Password')}
    #Input Password   wnd[0]/usr/pwdRSYST-BCODE    %('P2P_User_Password')
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   0.1

System Logout
    Run Transaction   /nex

Executing Invoice Creation
    ${total_row}=    Get Total Row    ${PO_Creation_File}    ${Invoice_Creation_Sheet}
    Log To Console     ${total_row}
    ${rows}=    Evaluate    ${total_row} + 1
    Log To Console    ${rows}
    FOR    ${row}    IN RANGE    2    ${rows}
        #System Logon
        Run Transaction    /nmiro
        Sleep    0.1
        ${Company_Code}    Read Excel Cell Value    ${PO_Creation_File}    ${Invoice_Creation_Sheet}   ${row}    2
        ${is_CC_present}=    Run Keyword And Ignore Error    Element Should Be Present    wnd[1]/usr/ctxtBKPF-BUKRS
        ${CC_result}=    Run Keyword And Ignore Error    Element Should Be Present    wnd[1]/usr/ctxtBKPF-BUKRS
        ${is_CC_present}=    Get From List    ${CC_result}    0   # Extract the first element of the tuple ('PASS' or 'FAIL')
        Run Keyword If    '${is_CC_present}' == 'PASS'    Give Company Code    ${row}    ${Company_Code}    ELSE    Switch Company Code    ${row}    ${Company_Code}
        Run Keyword And Ignore Error    Send VKey               0
        #Run Keyword And Ignore Error    Input Text    wnd[1]/usr/ctxtBKPF-BUKRS    ${Company_Code}        
        #Run Keyword And Ignore Error    Log To Console    ${Company_Code}
        #Run Keyword And Ignore Error    Send VKey               0
        Run Keyword And Ignore Error    Select From List By key    wnd[0]/usr/cmbRM08M-VORGANG    1
        ${Invoice_Date}    Get Current Date    result_format=%d.%m.%Y
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/ctxtINVFO-BLDAT    ${Invoice_Date}
        Run Keyword And Ignore Error    Send VKey               0
        #Check the tax checkbox
        Sleep    0.1
        Run Keyword And Ignore Error    Select Checkbox    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/chkINVFO-XMWST
        #Select the Tax details
        Sleep    0.1
        ${Tax_Type}    Read Excel Cell Value    ${PO_Creation_File}    ${Invoice_Creation_Sheet}   ${row}    5
        Run Keyword And Ignore Error    Select From List By key    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/cmbINVFO-MWSKZ    ${Tax_Type}
        Run Keyword And Ignore Error    Log To Console    ${Tax_Type}
        ${PO_Number}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}   ${row}    13
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/subITEMS:SAPLMR1M:6010/tabsITEMTAB/tabpITEMS_PO/ssubTABS:SAPLMR1M:6020/subREFERENZBELEG:SAPLMR1M:6211/ctxtRM08M-EBELN    ${PO_Number}        
        Run Keyword And Ignore Error    Log To Console    ${PO_Number}
        Run Keyword And Ignore Error    Send VKey               0
        Sleep    0.2
        Run Keyword And Ignore Error    Click Element    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_PAY
        ${Baseline_date}    Get Current Date    result_format=%d.%m.%Y
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_PAY/ssubHEADER_SCREEN:SAPLFDCB:0020/ctxtINVFO-ZFBDT    ${Baseline_date}
        Run Keyword And Ignore Error    Click Element    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL
        ${Business_Place}    Read Excel Cell Value    ${PO_Creation_File}    ${Invoice_Creation_Sheet}   ${row}    11
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/ctxtINVFO-BUPLA    ${Business_Place}
        Run Keyword And Ignore Error    Log To Console    ${Business_Place}

        ${Balance_Amount}    Run Keyword And Ignore Error    Get Value    wnd[0]/usr/txtRM08M-DIFFERENZ
        Log To Console    ${Balance_Amount}
        ${Amount}=    Clear Negative Sign    ${Balance_Amount}
        Run Keyword And Ignore Error    Log To Console    ${Amount}
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/txtINVFO-WRBTR    ${Amount}
        Sleep    0.2
        Run Keyword And Ignore Error    Click Element    wnd[0]/tbar[0]/btn[11]   
        ${invoice_status}    Get Value    wnd[0]/sbar
        ${invoice_number}=    Extract Numeric    ${invoice_status}
        Log To Console    Invoice Number : ${invoice_number}
        Write Excel    ${PO_Creation_File}    ${Invoice_Creation_Sheet}   ${row}    12    ${invoice_number}
        #System Logout
        Run Keyword And Ignore Error    Click Element    wnd[0]/tbar[0]/btn[3]
    END

Give Company Code
    [Arguments]    ${row}    ${Company_Code}
    Run Keyword And Ignore Error    Input Text    wnd[1]/usr/ctxtBKPF-BUKRS    ${Company_Code}
    Sleep    0.1        
Switch Company Code
    [Arguments]    ${row}    ${Company_Code}
    Run Keyword And Ignore Error    Click Element    wnd[0]/mbar/menu[1]/menu[0]
    Run Keyword And Ignore Error    Input Text    wnd[1]/usr/ctxtBKPF-BUKRS    ${Company_Code}
    Sleep    0.1    
