*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
   

*** Keywords ***
System Logon
    Start Process     ${symvar('SALES_SAP_SERVER')}    
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('SALES_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('SALES_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('SALES_User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('SALES_User_Password')}
    Send Vkey    0
    Sleep    5
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1

SLAES_ORDER_CREATION
    Run Transaction    VA01
	Sleep	2
	
	Input Text	wnd[0]/usr/ctxtVBAK-AUART	ZOR
	Sleep	2
	Send Vkey	0
	Sleep	2
	Send Vkey	4
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Set Focus	wnd[1]/usr/lbl[7,15]
	Sleep	2
	Send Vkey	2
	Sleep	2
	Set Focus	wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/subPART-SUB:SAPMV45A:4701/ctxtKUWEV-KUNNR
	Sleep	2
	Send Vkey	4
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Set Focus	wnd[1]/usr/lbl[7,15]
	Sleep	2
	Send Vkey	2
	Sleep	2
	Input Text	wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/txtVBKD-BSTKD	BCS - Aug - 021
	Sleep	2
	
    Print Table Row    ${symvar('Material_number')}    ${symvar('order_quantity')}    ${symvar('amount')}
    Take Screenshot
    
    Click Element	wnd[0]/tbar[0]/btn[11]
	Sleep	2
    ${order_meaasage}    Get Value    wnd[0]/sbar
    Log To Console    ${order_meaasage}
    ${order_number}=    Extract Order Number    ${order_meaasage}
    Set Global Variable    ${order_number}
    Log To Console    **gbStart**Copilot_Status**splitKeyValue**${order_number}**gbEnd**

System Logout
    Run Transaction   /nex
    Sleep    5

    

	






        