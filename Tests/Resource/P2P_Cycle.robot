*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    Collections
Library    ../../Symphony/Lib/site-packages/SeleniumLibrary/__init__.py
Resource    ../Web/Support_Web.robot
Library    ExcelLibrary
Library    DateTime

*** Variables ***    

${PO_Creation_File}      C:\\RobotFramework\\sap_testing\\Tests\\Resource\\Purchase_Order_Details.xlsx
${PO_Creation_Sheet}     Purchase order
${GR_Creation_Sheet}     Goods Receipt
${PO_Header}    ${SPACE*10}20
${Invoice_Creation_Sheet}     Invoice Receipt
${PO_Header}    ${SPACE*10}20
#${invoice_date}    06.11.2024

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

Executing P2P Cycle
    ${total_row}=    Get Total Row    ${PO_Creation_File}    ${PO_Creation_Sheet}
    Log To Console    Hello
    Log To Console     ${total_row}
    ${rows}=    Evaluate    ${total_row} + 1
    Log To Console    ${rows}
    FOR    ${initial_row}    IN RANGE    2    ${rows}
        Run Transaction    /nme21n
        Sleep    1
        #Run Keyword And Ignore Error    Select From List By Key    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB0:SAPLMEGUI:0030/subSUB1:SAPLMEGUI:1105/cmbMEPO_TOPLINE-BSART    NB
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
        Run Keyword And Ignore Error    Click Element    wnd[0]/tbar[0]/btn[3]
        ###### GR Creation
        Run Transaction    /nmigo
        Sleep    0.2
        Run Keyword And Ignore Error    Set Focus    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_FIRSTLINE:SAPLMIGO:0011/cmbGODYNPRO-ACTION    
        Run Keyword And Ignore Error    Select From List By Key    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_FIRSTLINE:SAPLMIGO:0011/cmbGODYNPRO-ACTION    A01
        Sleep    0.1
        Run Keyword And Ignore Error    Set Focus    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_FIRSTLINE:SAPLMIGO:0011/cmbGODYNPRO-REFDOC
        Run Keyword And Ignore Error    Select From List By Key    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_FIRSTLINE:SAPLMIGO:0011/cmbGODYNPRO-REFDOC    R01
        Sleep    0.1
        ${PO_Number}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}    ${initial_row}    13
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_FIRSTLINE:SAPLMIGO:0011/subSUB_FIRSTLINE_REFDOC:SAPLMIGO:2000/ctxtGODYNPRO-PO_NUMBER    ${PO_Number}        
        Run Keyword And Ignore Error    Log To Console    ${PO_Number}
        Sleep    0.1
        ${Movement_Type}    Read Excel Cell Value    ${PO_Creation_File}    ${GR_Creation_Sheet}   ${initial_row}    4
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_FIRSTLINE:SAPLMIGO:0011/ctxtGODEFAULT_TV-BWART    ${Movement_Type}        
        Run Keyword And Ignore Error    Log To Console    ${Movement_Type}
        Run Keyword And Ignore Error    Send VKey               0
        Sleep    0.3
        Run Keyword And Ignore Error    Select Checkbox    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_ITEMLIST:SAPLMIGO:0200/tblSAPLMIGOTV_GOITEM/chkGOITEM-TAKE_IT[3,0]
        ${Storage_Location}    Read Excel Cell Value    ${PO_Creation_File}    ${GR_Creation_Sheet}      ${initial_row}    8
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_ITEMLIST:SAPLMIGO:0200/tblSAPLMIGOTV_GOITEM/ctxtGOITEM-LGOBE[7,0]    ${Storage_Location}        
        Run Keyword And Ignore Error    Log To Console    ${Storage_Location}
        Sleep    0.1
        Run Keyword And Ignore Error    Click Element    wnd[0]/tbar[0]/btn[11]
        ${gr_status}    Get Value    wnd[0]/sbar
        ${gr_number}=    Extract Numeric    ${gr_status}
        Log To Console    GR Number : ${gr_number}
        Write Excel    ${PO_Creation_File}    ${GR_Creation_Sheet}   ${initial_row}    9    ${gr_number}
        Run Keyword And Ignore Error    Click Element    wnd[0]/tbar[0]/btn[3]
        ######## Invoice Creation
        Run Transaction    /nmiro
        Sleep    0.1
        ${Company_Code}    Read Excel Cell Value    ${PO_Creation_File}    ${Invoice_Creation_Sheet}   ${initial_row}    2
        Run Keyword And Ignore Error    Input Text    wnd[1]/usr/ctxtBKPF-BUKRS    ${Company_Code}        
        Run Keyword And Ignore Error    Log To Console    ${Company_Code}
        Run Keyword And Ignore Error    Send VKey               0
        #Run Keyword And Ignore Error    Select From List By Key    wnd[0]/usr/cmbRM08M-VORGANG    1
        ${Invoice_Date}    Get Current Date    result_format=%d.%m.%Y
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/ctxtINVFO-BLDAT    ${Invoice_Date}
        #Check the tax checkbox
        Sleep    0.1
        Run Keyword And Ignore Error    Select Checkbox    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/chkINVFO-XMWST
        #Select the Tax details
        Sleep    0.1
        ${Tax_Type}    Read Excel Cell Value    ${PO_Creation_File}    ${Invoice_Creation_Sheet}   ${initial_row}    5
        Run Keyword And Ignore Error    Select From List By Key    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/cmbINVFO-MWSKZ    ${Tax_Type}
        Run Keyword And Ignore Error    Log To Console    ${Tax_Type}
        ${PO_Number}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}   ${initial_row}    13
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/subITEMS:SAPLMR1M:6010/tabsITEMTAB/tabpITEMS_PO/ssubTABS:SAPLMR1M:6020/subREFERENZBELEG:SAPLMR1M:6211/ctxtRM08M-EBELN    ${PO_Number}        
        Run Keyword And Ignore Error    Log To Console    ${PO_Number}
        Run Keyword And Ignore Error    Send VKey               0
        Sleep    0.1
        Run Keyword And Ignore Error    Click Element    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_PAY
        ${Baseline_date}    Get Current Date    result_format=%d.%m.%Y
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_PAY/ssubHEADER_SCREEN:SAPLFDCB:0020/ctxtINVFO-ZFBDT    ${Baseline_date}
        Run Keyword And Ignore Error    Click Element    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL
        ${Business_Place}    Read Excel Cell Value    ${PO_Creation_File}    ${Invoice_Creation_Sheet}   ${initial_row}    11
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/ctxtINVFO-BUPLA    ${Business_Place}
        Run Keyword And Ignore Error    Log To Console    ${Business_Place}

        ${Balance_Amount}    Run Keyword And Ignore Error    Get Value    wnd[0]/usr/txtRM08M-DIFFERENZ
        Log To Console    ${Balance_Amount}
        ${Amount}=    Clear Negative Sign    ${Balance_Amount}
        Run Keyword And Ignore Error    Log To Console    ${Amount}
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/txtINVFO-WRBTR    ${Amount}
        Sleep    0.1
        Run Keyword And Ignore Error    Click Element    wnd[0]/tbar[0]/btn[11]   
        ${invoice_status}    Get Value    wnd[0]/sbar
        ${invoice_number}=    Extract Numeric    ${invoice_status}
        Log To Console    Invoice Number : ${invoice_number}
        Write Excel    ${PO_Creation_File}    ${Invoice_Creation_Sheet}   ${initial_row}    12    ${invoice_number}
        Run Keyword And Ignore Error    Click Element    wnd[0]/tbar[0]/btn[3]
    END
Retrieve Window Title
    [Arguments]    ${row}
    ${po_status}=    Run Keyword And Ignore Error    Get Window Title    wnd[1]
    ${status}=    Set Variable    ${po_status}[1]    
    Log To Console    PO Status (Window Title): ${status}
    Write Excel    ${PO_Creation_File}    ${PO_Creation_Sheet}    ${row}    13    ${status}
    Write Excel    ${PO_Creation_File}    ${GR_Creation_Sheet}    ${row}    5    ${status}
            
Retrieve Default Value
    [Arguments]    ${row}
    ${po_status}=    Run Keyword And Ignore Error    Get Value    wnd[0]/sbar
    ${po_status}=    Get From List    ${po_status}    1
    ${po_number}=    Extract Numeric    ${po_status}
    Log To Console    PO Number (Default Value): ${po_number}
    Write Excel    ${PO_Creation_File}    ${PO_Creation_Sheet}    ${row}    13    ${po_number}
    Write Excel    ${PO_Creation_File}    ${GR_Creation_Sheet}    ${row}    5    ${po_number}
