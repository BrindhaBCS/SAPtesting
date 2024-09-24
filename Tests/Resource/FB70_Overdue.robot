*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    Collections
*** Variables *** 
${Results_Directory_Path}    ${CURDIR}
# ${company_code}    ${symvar('company_code')}
# ${Customer}    ${symvar('Customer')} 
# ${Invoice_date}    ${symvar('Invoice_date')} 
# ${Posting_Date}    ${symvar('Posting_Date')} 
# ${Amount}    ${symvar('Amount')} 
# ${Text}    ${symvar('Text')} 
# ${G/L_acct}    ${symvar('G/L_acct')}
# ${FILE_NAME}    ${symvar('FILE_NAME')}
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    4
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
checking for Customer Overdue
	Run Transaction    /nfb70
	Sleep    1
	# Click Element	wnd[0]/tbar[1]/btn[7]
    # Sleep	0.5 seconds
	# Clear Field Text    wnd[1]/usr/ctxtBKPF-BUKRS
	# Sleep	0.5 seconds
	# Input Text    wnd[1]/usr/ctxtBKPF-BUKRS    ${symvar('company_code')}
    # Sleep	0.5 seconds
	# Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep	0.5 seconds
	Input Text	wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0510/ctxtINVFO-ACCNT    ${symvar('Customer')} 
    Sleep	0.5 seconds
	Input Text	wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0510/ctxtINVFO-BLDAT	${symvar('Invoice_date')} 
	Sleep	0.5 seconds
	Input Text	wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0510/ctxtINVFO-BUDAT	${symvar('Posting_Date')} 
	Sleep	0.5 seconds
	Run Keyword And Ignore Error    Send Vkey    vkey_id=0
	Run Keyword And Ignore Error    Send Vkey    vkey_id=0
	Run Keyword And Ignore Error    Send Vkey    vkey_id=0
    Sleep	0.5 seconds
	Input Text	wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0510/txtINVFO-WRBTR	${symvar('Amount')} 
    Sleep	0.5 seconds
	Input Text	wnd[0]/usr/tabsTS/tabpMAIN/ssubPAGE:SAPLFDCB:0510/ctxtINVFO-SGTXT	${symvar('Text')} 
    Sleep	0.5 seconds
	Input Text	wnd[0]/usr/subITEMS:SAPLFSKB:0100/tblSAPLFSKBTABLE/ctxtACGL_ITEM-HKONT[1,0]    ${symvar('GL_acct')}
    Sleep	0.5 seconds
	Input Text	wnd[0]/usr/subITEMS:SAPLFSKB:0100/tblSAPLFSKBTABLE/txtACGL_ITEM-WRBTR[4,0]	*
    Sleep	0.5 seconds
	Input Text	wnd[0]/usr/subITEMS:SAPLFSKB:0100/tblSAPLFSKBTABLE/ctxtACGL_ITEM-SGTXT[11,0]	+
	Sleep	0.5 seconds
	Set Focus	wnd[0]/usr/subITEMS:SAPLFSKB:0100/tblSAPLFSKBTABLE/ctxtACGL_ITEM-SGTXT[11,0]
	Sleep	0.5 seconds
	Click Element	wnd[0]/tbar[0]/btn[11]
	Sleep	5
	Run Transaction    /nfbl5n
	Sleep	2
	Input Text    wnd[0]/usr/ctxtDD_KUNNR-LOW    ${symvar('Customer')}
	Sleep    1   

    Send Vkey    vkey_id=8
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[56,8]
	Sleep	2
	Send Vkey    2
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[38]
	Sleep	2
	sendVKey    4
	Sleep	2
	Click Element	wnd[2]/tbar[0]/btn[0]
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[1]
	Sleep	2
	Input Text	wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_GUI_CUL_EXPORT_AS:0512/txtGS_EXPORT-FILE_NAME	${symvar('FILE_NAME')}
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[20]
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\tmp
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_PATH	${Results_Directory_Path}
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2

	
	