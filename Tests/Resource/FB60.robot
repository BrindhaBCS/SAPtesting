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
    Save Excel Document     ${filepath}
    Close Current Excel Document
SAP logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('connection')}
    Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('sap_client')}
    Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('sap_user')}
    Sleep    2
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('sap_pass')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Sleep    3s
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   5s
Transaction FB60
    Input Text  wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0010/ctxtINVFO-ACCNT       ${customer}
    Sleep   2
    Input Text  wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0010/ctxtINVFO-BLDAT       ${invoice_date}
    Sleep   2
    Input Text  wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0010/txtINVFO-WRBTR        ${amount}
    Sleep   2
    Input Text  wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0010/ctxtINVFO-SGTXT       ${text}
    Sleep   2
    Input Text  wnd[0]/usr/subITEMS:SAPLFSKB:0100/tblSAPLFSKBTABLE/ctxtACGL_ITEM-HKONT[1,0]     ${gl_amount}
    Sleep   2
    Input Text  wnd[0]/usr/subITEMS:SAPLFSKB:0100/tblSAPLFSKBTABLE/txtACGL_ITEM-WRBTR[4,0]      ${amount_cur_doc}
    Sleep   2
    # Input Text  wnd[0]/usr/subITEMS:SAPLFSKB:0100/tblSAPLFSKBTABLE/ctxtACGL_ITEM-KOSTL[17,0]    ${cost_center}
    # Sleep   2
    Click Element   wnd[0]/tbar[0]/btn[11]
    Sleep   2
    ${output}   Get Value    wnd[0]/sbar/pane[0]
    Log To Console      ${output}
    Write Excel     ${symvar('vendor_excel_path')}    ${symvar('sheet_name')}    ${row_count}    8      ${output}

    ${document}     Get Document Number     wnd[0]/sbar/pane[0]
    Log To Console      ${document}
    Write Excel     ${symvar('vendor_excel_path')}    ${symvar('sheet_name')}    ${row_count}    9      ${document}

    ${company_code}     Get Company Code    ${output}
    Log To Console      ${company_code}
    Write Excel     ${symvar('vendor_excel_path')}    ${symvar('sheet_name')}    ${row_count}    10      ${company_code}
    
FB60 Invoice entry

    ${user_count}    Count Excel Rows     ${symvar('vendor_excel_path')}
    ${rows}=    Evaluate    ${user_count} + 1
    Set Global Variable     ${rows}
    Log To Console      ${rows}
    Run Transaction     FB60
    Sleep   5
    FOR    ${row_count}    IN RANGE    2    ${rows}

        Set Global Variable     ${row_count}
        ${customer}    Read Excel    ${symvar('vendor_excel_path')}    ${symvar('sheet_name')}    ${row_count}    1
        Log To Console  ${customer}
        Set Global Variable     ${customer}
        
        ${invoice_date}    Read Excel    ${symvar('vendor_excel_path')}    ${symvar('sheet_name')}    ${row_count}    2
        Log To Console  ${invoice_date}
        Set Global Variable     ${invoice_date}
        
        ${amount}    Read Excel    ${symvar('vendor_excel_path')}    ${symvar('sheet_name')}    ${row_count}    3
        Log To Console  ${amount}
        Set Global Variable     ${amount}
        
        ${text}    Read Excel    ${symvar('vendor_excel_path')}    ${symvar('sheet_name')}    ${row_count}    4
        Log To Console  ${text}
        Set Global Variable     ${text}
        
        ${gl_amount}    Read Excel    ${symvar('vendor_excel_path')}    ${symvar('sheet_name')}    ${row_count}    5
        Log To Console  ${gl_amount}
        Set Global Variable     ${gl_amount}
        
        ${amount_cur_doc}    Read Excel    ${symvar('vendor_excel_path')}    ${symvar('sheet_name')}    ${row_count}    6
        Log To Console  ${amount_cur_doc}
        Set Global Variable     ${amount_cur_doc}
        
        # ${cost_center}    Read Excel    ${symvar('vendor_excel_path')}    ${symvar('sheet_name')}    ${row_count}    7
        # Log To Console  ${cost_center}
        # Set Global Variable     ${cost_center}
        
        Transaction FB60

    END
SAP Logout
    Run Transaction     /nex
    Sleep   5
    
    
    


