*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    ExcelLibrary
Library    String
Library    DateTime
*** Variables ***
${filename}    ${symvar('MSO_filename')}
${sheetname}    ${symvar('MSO_sheetname1')}
${sheetname2}    ${symvar('MSO_sheetname2')}


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
    Sleep    2


Delivery_Post_Goods_Issue
    
    ${ROWS_COUN}=    get total row    ${filename}    ${sheetname}
    Log    Total rows count: ${ROWS_COUN}
    Sleep    1
    ${ROWS_COUNT} =    Evaluate    ${ROWS_COUN} + 1
    FOR    ${row_index}    IN RANGE    3    ${ROWS_COUNT}
        Run Transaction    /nVL01N
        Sleep	2
        ${Shipping_Point}    Read Value From Excel    file_path=${filename}    sheet_name=${symvar('MSO_sheetname2')}    cell=C${row_index}
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/ctxtLIKP-VSTEL    ${Shipping_Point} 
        Sleep	2
        # Run Keyword And Ignore Error    Click Element    wnd[0]/usr/ctxtLV50C-VBELN
        ${SO_Number}    Read Value From Excel    file_path=${filename}    sheet_name=Sales Order Creation    cell=R${row_index}
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/ctxtLV50C-VBELN    ${SO_Number}   
        Sleep	2
        Click Element	wnd[0]/tbar[0]/btn[0]
        Sleep	2
        Input Text	wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV50A:1102/tblSAPMV50ATC_LIPS_OVER/txtLIPSD-PIKMG[18,0]	10
	    Sleep	2
        Click Element	wnd[0]/tbar[1]/btn[20]
        Sleep	2
        
	   
        ${Text}=    Get Value    wnd[0]/sbar/pane[0]
        
        ${Outbound_delivery_number}=    Extract Numeric    ${Text}
        Log To Console    ${Outbound_delivery_number}
        Sleep    1
        Write Value To Excel    file_path=${filename}    sheet_name=${sheetname2}    cell=G${row_index}   value=${Outbound_delivery_number}
        Sleep    1
        
        


    END

        
        