*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    Collections
Library    ../../Symphony/Lib/site-packages/SeleniumLibrary/__init__.py
Resource    ../Web/Support_Web.robot
Library    ExcelLibrary

*** Variables ***    

${PO_Creation_File}      C:\\Purchase_Order_Details.xlsx
${PO_Creation_Sheet}     Purchase order
${GR_Creation_Sheet}     Goods Receipt
${PO_Header}    ${SPACE*10}20


*** Keywords ***

Read Excel Sheet
    [Arguments]    ${Excel_file}    ${sheetname}    ${rownum}    ${colnum}    
    Open Excel Document    ${Excel_file}    1
    #Open Workbook    ${Excel_file}
    #Set Active Worksheet    ${sheetname}    
    Get Sheet    ${sheetname}    
    ${data}    Read Excel Cell   ${rownum}    ${colnum}        
    [Return]    ${data}
    Log To Console    ${data}
    Close Current Excel Document 

Write Excel
    [Arguments]    ${filepath}    ${sheetname}    ${rownum}    ${colnum}    ${cell_value}
    #Open Workbook    ${Excel_file}
    #Set Active Worksheet    ${sheetname}
    #Write To Cell    ${rownum}    ${colnum}    ${cell_value}
    #Save Workbook
    #Close Workbook
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

Executing GR Creation
    ${total_row}=    Get Total Row    ${PO_Creation_File}    ${GR_Creation_Sheet}
    Log To Console    Hello
    Log To Console     ${total_row}
    ${rows}=    Evaluate    ${total_row} + 1
    Log To Console    ${rows}
    FOR    ${row}    IN RANGE    2    ${rows}
        Run Transaction    /nmigo
        Sleep    2
        Select From List By Key    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_FIRSTLINE:SAPLMIGO:0011/cmbGODYNPRO-ACTION    A01
        Select From List By Key    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_FIRSTLINE:SAPLMIGO:0011/cmbGODYNPRO-REFDOC    R01
        Sleep    1
        ${PO_Number}    Read Excel Cell Value    ${PO_Creation_File}    ${PO_Creation_Sheet}    ${row}    13
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_FIRSTLINE:SAPLMIGO:0011/subSUB_FIRSTLINE_REFDOC:SAPLMIGO:2000/ctxtGODYNPRO-PO_NUMBER    ${PO_Number}        
        Run Keyword And Ignore Error    Log To Console    ${PO_Number} 
        ${Movement_Type}    Read Excel Cell Value    ${PO_Creation_File}    ${GR_Creation_Sheet}   ${row}    4
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_FIRSTLINE:SAPLMIGO:0011/ctxtGODEFAULT_TV-BWART    ${Movement_Type}        
        Run Keyword And Ignore Error    Log To Console    ${Movement_Type}
        Run Keyword And Ignore Error    Send VKey               0
        Sleep    0.5
        Select Checkbox    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_ITEMLIST:SAPLMIGO:0200/tblSAPLMIGOTV_GOITEM/chkGOITEM-TAKE_IT[3,0]
        ${Storage_Location}    Read Excel Cell Value    ${PO_Creation_File}    ${GR_Creation_Sheet}      ${row}    8
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_ITEMLIST:SAPLMIGO:0200/tblSAPLMIGOTV_GOITEM/ctxtGOITEM-LGOBE[7,0]    ${Storage_Location}        
        Run Keyword And Ignore Error    Log To Console    ${Storage_Location}
        Sleep    0.5
        Click Element    wnd[0]/tbar[0]/btn[11]
        ${gr_status}    Get Value    wnd[0]/sbar
        ${gr_number}=    Extract Numeric    ${gr_status}
        Log To Console    GR Number : ${gr_number}
        Write Excel    ${PO_Creation_File}    ${GR_Creation_Sheet}   ${row}    9    ${gr_number}
    END
    
