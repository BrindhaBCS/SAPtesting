*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    Collections
Library    ../../Symphony/Lib/site-packages/SeleniumLibrary/__init__.py
Resource    ../Web/Support_Web.robot
Library    ExcelLibrary
 
*** Variables ***

#${PO_Status}      C:\\Robot_SAP\\SAPtesting\\Tests\\Resource\\PO_Status.xlsx
${PO_Status}    C:\\RobotFramework\\sap_testing\\Tests\\Resource\\PO_Status.xlsx
${PO_Status_Sheet}     PO Status

${PO_Number}    4500002772

*** Keywords ***
Write Excel
    [Arguments]    ${filepath}    ${sheetname}    ${rownum}    ${colnum}    ${cell_value}
    Open Excel Document    ${filepath}    1
    Get Sheet    ${sheetname}  
    Write Excel Cell      ${rownum}       ${colnum}     ${cell_value}       ${sheetname}
    Save Excel Document     ${filepath}
    Close Current Excel Document

System Logon
    Start Process     ${symvar('P2P_SAP_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('P2P_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('P2P_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('P2P_User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('P2P_User_Password')}
    #Input Password   wnd[0]/usr/pwdRSYST-BCODE    %('User_Password')
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
    Sleep    5
    Sleep    10

Executing PO Status
    Run Transaction    /nme21n
    Send Vkey    0
    Sleep    0.1
    Click Element	wnd[0]/mbar/menu[0]/menu[0]
	Sleep	0.1
	Input Text	    wnd[1]/usr/subSUB0:SAPLMEGUI:0003/ctxtMEPO_SELECT-EBELN    ${PO_Number}
	Sleep	0.1
    Click Element	wnd[1]/tbar[0]/btn[0]
    ${po_type}    get_value    wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB0:SAPLMEGUI:0030/subSUB1:SAPLMEGUI:1105/cmbMEPO_TOPLINE-BSART
    ${po_creation_date}    get_value    wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB0:SAPLMEGUI:0030/subSUB1:SAPLMEGUI:1105/ctxtMEPO_TOPLINE-BEDAT
    Click Element   wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT16
    Sleep    0.1
    #${gr_number}    get_cell_value    wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT16/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1316/ssubPO_HISTORY:SAPLMMHIPO:0100/cntlMEALV_GRID_CONTROL_MMHIPO/shellcont/shell    0    BELNR

    Click Current Cell	wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT16/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1316/ssubPO_HISTORY:SAPLMMHIPO:0100/cntlMEALV_GRID_CONTROL_MMHIPO/shellcont/shell    BELNR
    ${gr_number}    get_value    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_FIRSTLINE:SAPLMIGO:0011/subSUB_FIRSTLINE_REFDOC:SAPLMIGO:2010/txtGODYNPRO-MAT_DOC    #wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT16/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1316/ssubPO_HISTORY:SAPLMMHIPO:0100/cntlMEALV_GRID_CONTROL_MMHIPO/shellcont/shell    0    BELNR
    ${gr_creation_date}    get_value    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_HEADER:SAPLMIGO:0101/subSUB_HEADER:SAPLMIGO:0100/tabsTS_GOHEAD/tabpOK_GOHEAD_CREATEDBY/ssubSUB_TS_GOHEAD_CREATEDBY:SAPLMIGO:0130/ctxtGOHEAD-CPUDT
    ${gr_creation_time}    get_value    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_HEADER:SAPLMIGO:0101/subSUB_HEADER:SAPLMIGO:0100/tabsTS_GOHEAD/tabpOK_GOHEAD_CREATEDBY/ssubSUB_TS_GOHEAD_CREATEDBY:SAPLMIGO:0130/ctxtGOHEAD-CPUTM
    Click Element	wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_HEADER:SAPLMIGO:0101/subSUB_HEADER:SAPLMIGO:0100/tabsTS_GOHEAD/tabpOK_GOHEAD_CREATEDBY/ssubSUB_TS_GOHEAD_CREATEDBY:SAPLMIGO:0130/btnOK_FI_DOC
    Sleep    0.1
    ${Account_GR_Number}    get_cell_value    wnd[1]/usr/cntlCONTAINER/shellcont/shell    0    DOCNR
    Sleep    0.1
    Click Element	wnd[1]/tbar[0]/btn[12]
    Sleep    0.1
    Click Element    wnd[0]/tbar[0]/btn[3] 
    ${invoice_number1}    get_cell_value    wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT16/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1316/ssubPO_HISTORY:SAPLMMHIPO:0100/cntlMEALV_GRID_CONTROL_MMHIPO/shellcont/shell    2    BELNR
    ${invoice_number2}    get_cell_value    wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT16/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1316/ssubPO_HISTORY:SAPLMMHIPO:0100/cntlMEALV_GRID_CONTROL_MMHIPO/shellcont/shell    3    BELNR
    Sleep    0.1
	#Click Current Cell	wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT16/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1316/ssubPO_HISTORY:SAPLMMHIPO:0100/cntlMEALV_GRID_CONTROL_MMHIPO/shellcont/shell
    Sleep    0.1
    #${invoice1_creation_date}    get_value    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/ctxtINVFO-BLDAT
    ${invoice1_creation_date}    get_cell_value    wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT16/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1316/ssubPO_HISTORY:SAPLMMHIPO:0100/cntlMEALV_GRID_CONTROL_MMHIPO/shellcont/shell    2    BUDAT
    ${invoice2_creation_date}    get_cell_value    wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT16/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1316/ssubPO_HISTORY:SAPLMMHIPO:0100/cntlMEALV_GRID_CONTROL_MMHIPO/shellcont/shell    3    BUDAT
    #Click Element	wnd[0]/tbar[1]/btn[8]
    #${invoice1_account_number}    get_value    wnd[0]/usr/txtBKPF-BELNR
    #Click Element	wnd[0]/tbar[0]/btn[3]
	#Click Element	wnd[0]/tbar[0]/btn[3]
    #Sleep    0.1
	#Click Current Cell	wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB3:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1301/subSUB2:SAPLMEGUI:1303/tabsITEM_DETAIL/tabpTABIDT16/ssubTABSTRIPCONTROL1SUB:SAPLMEGUI:1316/ssubPO_HISTORY:SAPLMMHIPO:0100/cntlMEALV_GRID_CONTROL_MMHIPO/shellcont/shell    BELNR
    #${invoice2_creation_date}    get_value    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/ctxtINVFO-BLDAT
    #Click Element	wnd[0]/tbar[1]/btn[8]
    #${invoice2_account_number}    get_value    wnd[0]/usr/txtBKPF-BELNR
    Log To Console   PO Number: ${PO_Number}
    Write Excel    ${PO_Status}    ${PO_Status_Sheet}    2    2    ${PO_Number}
    Sleep    0.1
    Write Excel    ${PO_Status}    ${PO_Status_Sheet}    3    2    ${po_type}
    Sleep    0.1
    Write Excel    ${PO_Status}    ${PO_Status_Sheet}    4    2    ${po_creation_date}
    Log To Console   GR Number: ${gr_number}
    Write Excel    ${PO_Status}    ${PO_Status_Sheet}    5    2    ${gr_number}
    Sleep    0.1
    Write Excel    ${PO_Status}    ${PO_Status_Sheet}    6    2    ${gr_creation_date}
    Write Excel    ${PO_Status}    ${PO_Status_Sheet}    7    2    ${gr_creation_time}
    Write Excel    ${PO_Status}    ${PO_Status_Sheet}    8    2    ${Account_GR_Number}

    Log To Console   Invoice Number: ${invoice_number1}
    Write Excel    ${PO_Status}    ${PO_Status_Sheet}    9    2    ${invoice_number1}
    Write Excel    ${PO_Status}    ${PO_Status_Sheet}    10    2    ${invoice1_creation_date}
    #Write Excel    ${PO_Status}    ${PO_Status_Sheet}    11    2    ${invoice1_account_number}
    Sleep    0.1
    Log To Console   Invoice Number: ${invoice_number2}
    Write Excel    ${PO_Status}    ${PO_Status_Sheet}    12    2    ${invoice_number2}
    Write Excel    ${PO_Status}    ${PO_Status_Sheet}    13    2    ${invoice2_creation_date}
    #Write Excel    ${PO_Status}    ${PO_Status_Sheet}    14    2    ${invoice2_account_number}
Result
    ${json}    Excel To Json    excel_file=C:\\RobotFramework\\sap_testing\\Tests\\Resource\\PO_Status.xlsx    json_file=C:\\tmp\\Json\\PO_Status.json
    Sleep    0.5
    Log To Console    **gbStart**copilot_Json**splitKeyValue**${json}**gbEnd**
    #Delete Specific File    file_path=C:\\tmp\\Json\\PO_Status.json





