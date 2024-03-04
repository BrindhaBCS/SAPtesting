*** Settings ***
Library    Process
Library     CustomSapGuiLibrary.py
Library    OperatingSystem
Library    ExcelLibrary
Library    openpyxl

*** Variables ***
${SAP_SERVER}      C:\\Program Files (x86)\\SAP\\FrontEnd\\SAPgui\\saplogon.exe
${FIELD_USER}      wnd[0]/usr/txtRSYST-BNAME
${FIELD_PASSWORD}  wnd[0]/usr/pwdRSYST-BCODE

# ${user_count}       3
${excel_path}       ${CURDIR}\\invoice.xlsx
${sheet_name}       INPUT
${screenshot_dir}   ${OUTPUT_DIR}

# ${customer}         CMS0000043
# ${invoice_date}     19.02.2024
# ${amount}           1000
# ${text}             robo test
# ${gl_amount}        40001
# ${amount_cur_doc}   1000
# ${cost_center}      329

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
    Start Process     ${SAP_SERVER}
    Sleep    10s
    Connect To Session
    Open Connection    BIS
    Input Text    wnd[0]/usr/txtRSYST-MANDT     800
    Input Text    ${FIELD_USER}    lokeshk
    Input Password    ${FIELD_PASSWORD}    Test@12345
    Send Vkey    0
    Sleep   10s
    # Take Screenshot     logon.png
    # Add Screenshot To Excel     ${screenshot_dir}   ${excel_path}    ${sheet_name}    3    3     
Transaction FB70
    Run Transaction     FB70
    Sleep   5
    Input Text  wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0510/ctxtINVFO-ACCNT       ${customer}
    Sleep   5
    Input Text  wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0510/ctxtINVFO-BLDAT       ${invoice_date}
    Sleep   5
    Input Text  wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0510/txtINVFO-WRBTR        ${amount}
    Sleep   5
    Input Text  wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0510/ctxtINVFO-SGTXT       ${text}
    Sleep   5
    Input Text  wnd[0]/usr/subITEMS:SAPLFSKB:0100/tblSAPLFSKBTABLE/ctxtACGL_ITEM-HKONT[1,0]     ${gl_amount}
    Sleep   5
    Input Text  wnd[0]/usr/subITEMS:SAPLFSKB:0100/tblSAPLFSKBTABLE/txtACGL_ITEM-WRBTR[4,0]      ${amount_cur_doc}
    Sleep   5
    Input Text  wnd[0]/usr/subITEMS:SAPLFSKB:0100/tblSAPLFSKBTABLE/ctxtACGL_ITEM-KOSTL[17,0]    ${cost_center}
    Sleep   5
    Click Element   wnd[0]/tbar[0]/btn[11]
    Sleep   5
    ${output}   Get Value    wnd[0]/sbar/pane[0]
    # Log To Console      ${output}
    Write Excel     ${excel_path}    ${sheet_name}    ${row_count}    8      ${output}

    ${document}     Get Document Number     wnd[0]/sbar/pane[0]
    # Log To Console      ${document}
    Write Excel     ${excel_path}    ${sheet_name}    ${row_count}    9      ${document}

    ${company_code}     Get Company Code    ${output}
    # Log To Console      ${company_code}
    Write Excel     ${excel_path}    ${sheet_name}    ${row_count}    10      ${company_code}

Transaction code FB03
    Run Transaction     /nFB03
    Sleep   5
    Input Text  wnd[0]/usr/txtRF05L-BELNR       ${document}
    Sleep   5
    Input Text  wnd[0]/usr/ctxtRF05L-BUKRS       ${company_code}
    Sleep   5
    Input Text  wnd[0]/usr/txtRF05L-GJAHR        ${fiscal_year}
    Sleep   5
    Send Vkey    0

FB03 display the invoice document
    FOR    ${row_count}    IN RANGE    2    ${rows}

        ${document}    Read Excel    ${excel_path}    ${sheet_name}    ${row_count}    9
        # Log To Console  ${document}
        Set Global Variable     ${document}

        ${company_code}    Read Excel    ${excel_path}    ${sheet_name}    ${row_count}    10
        # Log To Console  ${company_code}
        Set Global Variable     ${company_code}

        ${fiscal_year}    Read Excel    ${excel_path}    ${sheet_name}    ${row_count}    11
        # Log To Console  ${fiscal_year}
        Set Global Variable     ${fiscal_year}

    END

FB70 Invoice entry

    ${user_count}    Count Excel Rows     ${excel_path}
    ${rows}=    Evaluate    ${user_count} + 1
    Set Global Variable     ${rows}
    FOR    ${row_count}    IN RANGE    2    ${rows}

        Set Global Variable     ${row_count}
        ${customer}    Read Excel    ${excel_path}    ${sheet_name}    ${row_count}    1
        # Log To Console  ${customer}
        Set Global Variable     ${customer}
        
        ${invoice_date}    Read Excel    ${excel_path}    ${sheet_name}    ${row_count}    2
        # Log To Console  ${invoice_date}
        Set Global Variable     ${invoice_date}
        
        ${amount}    Read Excel    ${excel_path}    ${sheet_name}    ${row_count}    3
        # Log To Console  ${amount}
        Set Global Variable     ${amount}
        
        ${text}    Read Excel    ${excel_path}    ${sheet_name}    ${row_count}    4
        # Log To Console  ${text}
        Set Global Variable     ${text}
        
        ${gl_amount}    Read Excel    ${excel_path}    ${sheet_name}    ${row_count}    5
        # Log To Console  ${gl_amount}
        Set Global Variable     ${gl_amount}
        
        ${amount_cur_doc}    Read Excel    ${excel_path}    ${sheet_name}    ${row_count}    6
        # Log To Console  ${amount_cur_doc}
        Set Global Variable     ${amount_cur_doc}
        
        ${cost_center}    Read Excel    ${excel_path}    ${sheet_name}    ${row_count}    7
        # Log To Console  ${cost_center}
        Set Global Variable     ${cost_center}
        
        Transaction FB70

    END

#write the output into the excel sheet
# excel rows
#     ${user_count}    Count Excel Rows     ${excel_path}
#     ${rows}=    Evaluate    ${user_count} + 1
#     Log To Console      ${rows}

SAP Logout
    Run Transaction   /nex
    Sleep    5


    
    


