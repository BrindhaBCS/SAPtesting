*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    Collections
Library    ../../Symphony/Lib/site-packages/SeleniumLibrary/__init__.py
Resource    ../Web/Support_Web.robot
Library    ExcelLibrary

*** Variables ***    

${PO_Creation_File}      Purchase_Order_Details.xlsx
${PO_Creation_Sheet}     Purchase order

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
    Sleep   1

System Logout
    Run Transaction   /nex

Executing PO Creation
    ${total_row}=    Get Total Row    ${PO_Creation_File}    ${PO_Creation_Sheet}
    Log To Console    Hello
    Log To Console     ${total_row}
    ${rows}=    Evaluate    ${total_row} + 1
    Log To Console    ${rows}
    FOR    ${initial_row}    IN RANGE    2    ${rows}
        Run Transaction    /nme21n
        Sleep    1
        Run Keyword And Ignore Error    Select From List By Key    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB0:SAPLMEGUI:0030/subSUB1:SAPLMEGUI:1105/cmbMEPO_TOPLINE-BSART    NB
        ${supplier}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}   ${initial_row}    3
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB0:SAPLMEGUI:0030/subSUB1:SAPLMEGUI:1105/ctxtMEPO_TOPLINE-SUPERFIELD    ${supplier}    
        Run Keyword And Ignore Error    Log To Console    ${supplier}
        Run Keyword And Ignore Error    Send VKey    0
        Sleep    1
        ${purchase_org}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}   ${initial_row}    4
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT8/ssubTABSTRIPCONTROL2SUB:SAPLMEGUI:1221/ctxtMEPO1222-EKORG    ${purchase_org}
        Run Keyword And Ignore Error    Log To Console    ${purchase_org}
        ${purchase_grp}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}   ${initial_row}    5
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT8/ssubTABSTRIPCONTROL2SUB:SAPLMEGUI:1221/ctxtMEPO1222-EKGRP    ${purchase_grp}
        Run Keyword And Ignore Error    Log To Console    ${purchase_grp}
        ${company_code}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}   ${initial_row}    6
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT8/ssubTABSTRIPCONTROL2SUB:SAPLMEGUI:1221/ctxtMEPO1222-BUKRS    ${company_code}
        Run Keyword And Ignore Error    Log To Console    ${company_code}
        ${material}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}   ${initial_row}    7
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-EMATN[4,0]    ${material}
        Run Keyword And Ignore Error    Log To Console    ${material}
        ${quantity}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}   ${initial_row}    8
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/txtMEPO1211-MENGE[6,0]    ${quantity}
        Run Keyword And Ignore Error    Log To Console    ${quantity}
        ${currency}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}   ${initial_row}    9
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/txtMEPO1211-WAERS[11,0]    ${currency}
        Run Keyword And Ignore Error    Log To Console    ${currency}
        ${delivery_date}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}   ${initial_row}    10
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-EEIND[9,0]    ${delivery_date}
        Run Keyword And Ignore Error    Log To Console    ${delivery_date}
        ${net_price}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}   ${initial_row}    11
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/txtMEPO1211-NETPR[10,0]    ${net_price}
        Run Keyword And Ignore Error    Log To Console    ${delivery_date}
        ${plant}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}   ${initial_row}    12
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-NAME1[15,0]    ${plant}
        Run Keyword And Ignore Error    Log To Console    ${plant}
        Run Keyword And Ignore Error    Click Element    wnd[0]/mbar/menu[0]/menu[4]
        Sleep    1
        ${is_present}=    Run Keyword And Ignore Error    Element Should Be Present    wnd[1]
        ${result}=    Run Keyword And Ignore Error    Element Should Be Present    wnd[1]
        ${is_present}=    Get From List    ${result}    0   # Extract the first element of the tuple ('PASS' or 'FAIL')
        Run Keyword If    '${is_present}' == 'PASS'    Retrieve Window Title    ${initial_row}    ELSE    Retrieve Default Value    ${initial_row}
        
    END
Retrieve Window Title
    [Arguments]    ${row}
    ${po_status}=    Run Keyword And Ignore Error    Get Window Title    wnd[1]
    ${status}=    Set Variable    ${po_status}[1]    
    Log To Console    PO Status (Window Title): ${status}
    Write Excel    ${PO_Creation_File}    ${PO_Creation_Sheet}    ${row}    13    ${status}
            
Retrieve Default Value
    [Arguments]    ${row}
    ${po_status}=    Run Keyword And Ignore Error    Get Value    wnd[0]/sbar
    ${po_status}=    Get From List    ${po_status}    1
    ${po_number}=    Extract Numeric    ${po_status}
    Log To Console    PO Number (Default Value): ${po_number}
    Write Excel    ${PO_Creation_File}    ${PO_Creation_Sheet}    ${row}    13    ${po_number}
