*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    ExcelLibrary
Library    String
Library    DateTime
*** Variables ***
${filename}    ${symvar('MSO_filename')}
${sheetname}    ${symvar('MSO_sheetname1')}
${START_ROW}    3
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('MSO_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('MSO_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MSO_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MSO_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{MSO_User_Password}
    Send Vkey    0
    Sleep    2
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction   /nex

SalesOrderCreation
    Run Transaction    /nVA01
    Sleep    2
    ${ROWS_COUN}=    get total row    ${filename}    ${sheetname}
    Log    Total rows count: ${ROWS_COUN}
    Sleep    1
    ${ROWS_COUNT} =    Evaluate    ${ROWS_COUN} + 1
    FOR    ${row_index}    IN RANGE    3    ${ROWS_COUNT}    
        
        
        # Send Vkey    vkey_id=0
        # Sleep    1.5
        # Run Keyword And Ignore Error    Click Element    wnd[0]/usr/ctxtVBAK-AUART
        ${Order_Type}    Read Value From Excel    file_path=${filename}    sheet_name=${sheetname}    cell=C${row_index}
        Clear Field Text    wnd[0]/usr/ctxtVBAK-AUART    
        Input Text    wnd[0]/usr/ctxtVBAK-AUART    ${Order_Type}
        Sleep    0.5
       
        Clear Field Text    wnd[0]/usr/ctxtVBAK-VKORG
        ${Sales_Organization}    Read Value From Excel    file_path=${filename}    sheet_name=${sheetname}    cell=D${row_index}
        
        Input Text    wnd[0]/usr/ctxtVBAK-VKORG    ${Sales_Organization}
        Sleep    0.5
        
        ${Distribution Channel}    Read Value From Excel    file_path=${filename}    sheet_name=${sheetname}    cell=E${row_index}
        Input Text    wnd[0]/usr/ctxtVBAK-VTWEG    ${Distribution Channel}
        Sleep    0.5
        ${Division}    Read Value From Excel    file_path=${filename}    sheet_name=${sheetname}    cell=F${row_index}
        Input Text    wnd[0]/usr/ctxtVBAK-SPART   ${Division}
        Sleep    0.5
        ${Sales_Office}    Read Value From Excel    file_path=${filename}    sheet_name=${sheetname}    cell=G${row_index}
        Input Text    wnd[0]/usr/ctxtVBAK-VKBUR       ${Sales_Office}
        Sleep    0.5
        ${Sales_Group}    Read Value From Excel    file_path=${filename}    sheet_name=${sheetname}    cell=H${row_index}
        Input Text    wnd[0]/usr/ctxtVBAK-VKGRP       ${Sales_Group}
        Sleep    0.5
        Click Element	wnd[0]/tbar[0]/btn[0]
	    Sleep	0.5
        ${Sold-to-Party}    Read Value From Excel    file_path=${filename}    sheet_name=${sheetname}    cell=J${row_index}
        Run Keyword And Ignore Error    Input Text	wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/subPART-SUB:SAPMV45A:4701/ctxtKUAGV-KUNNR	${Sold-to-Party}
	    Sleep	0.5
        
        ${Ship-to-Party}    Read Value From Excel    file_path=${filename}    sheet_name=${sheetname}    cell=K${row_index}
        Run Keyword And Ignore Error    Input Text	wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/subPART-SUB:SAPMV45A:4701/ctxtKUWEV-KUNNR	${Ship-to-Party}
	    Sleep	0.5
        
        ${Customer_Reference}    Read Value From Excel    file_path=${filename}    sheet_name=${sheetname}    cell=L${row_index}
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/txtVBKD-BSTKD	${Customer_Reference}
	    Sleep	0.5
        ${Cust_Ref_Date}    Read Value From Excel    file_path=${filename}    sheet_name=${sheetname}    cell=M${row_index}
        Run Keyword And Ignore Error    Input Text	wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/ctxtVBKD-BSTDK    ${Cust_Ref_Date} 
	    Sleep	0.5
        ${Current_Date}    Get Current Date    result_format=%d.%m.%Y
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/ssubHEADER_FRAME:SAPMV45A:4440/ctxtRV45A-KETDAT    ${Current_Date}
        Sleep	0.5
        Set Focus	wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG/ctxtRV45A-MABNR[1,0]
	    Sleep	0.5
	    Send Vkey    4
	    Sleep	0.5
        Input Text	wnd[1]/usr/tabsG_SELONETABSTRIP/tabpTAB008/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/txtG_SELFLD_TAB-LOW[0,24]	TESTING - SAMPLE MATERIAL
	    Send Vkey    4
	    Sleep	0.5
	    Click Element	wnd[1]/tbar[0]/btn[0]
	    Sleep	0.5
	    Click Element	wnd[1]/tbar[0]/btn[0]
	    Sleep	0.5
        Set Focus	wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG/txtRV45A-KWMENG[3,0]
	    Sleep	0.5
	    
        
        Input Text	wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG/txtRV45A-KWMENG[3,0]	10
	    Sleep	0.5
	    Set Focus    wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG/txtKOMV-KBETR[15,0]    
	    Input Text	wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG/txtKOMV-KBETR[15,0]	50
	    Sleep	0.5
        Set Focus	wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG/ctxtRV45A-MABNR[1,0]
	    Sleep	0.5
        Send Vkey    2
        Send Vkey    2
        Sleep	0.5
	    Click Element	wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\03
        Sleep	0.5
	    Set Focus	wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\03/ssubSUBSCREEN_BODY:SAPMV45A:4452/ctxtVBAP-LGORT
	    Sleep	0.5
	    Send Vkey    4
	    Sleep	0.5
        Input Text    wnd[0]/usr/tabsTAXI_TABSTRIP_ITEM/tabpT\\03/ssubSUBSCREEN_BODY:SAPMV45A:4452/ctxtVBAP-LGORT    FERT    
	    # Set Focus	wnd[1]/usr/lbl[1,4]	
	    Sleep	0.5
	    Click Element	wnd[1]/tbar[0]/btn[0]
	    Sleep	0.5
	    Click Element	wnd[0]/tbar[0]/btn[11]
        Sleep	0.5
        ${Text}=    Get Value    wnd[0]/sbar/pane[0]
        Sleep    1
        ${SO_Number}=    Extract Numeric    ${Text}
        Log To Console    ${SO_Number}
        Sleep    1
        Write Value To Excel    file_path=${filename}    sheet_name=${sheetname}    cell=R${row_index}   value=${SO_Number}
        Click Element	wnd[0]/tbar[0]/btn[3]
    END
    
    

    