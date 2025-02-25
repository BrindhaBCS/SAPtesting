*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Idoc_SID')}
    Sleep    1   
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Idoc_Client')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Idoc_User')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Idoc_Pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Idoc_Pass}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
  
System Logout
    Run Transaction   /nex

Changing_Port
    Run Transaction    /nWE20
    Sleep    2
    Expand Node    wnd[0]/shellcont/shell    LS
    Sleep    1
    Select Node Link	wnd[0]/shellcont/shell	92${SPACE*8}LS	Column1
	Sleep	2
	Set Focus	wnd[0]/usr/tblSAPMSEDIPARTNERTC_EDP13/ctxtTCEDP13-RCVPOR[5,0]
	Sleep	2
	Send Vkey	2
	Sleep	2
	Send Vkey	2
	Sleep	2
    Clear Field Text    wnd[0]/usr/ctxtVED_EDIPOA-LOGDES
    Sleep    1
    Input Text	wnd[0]/usr/ctxtVED_EDIPOA-LOGDES	BCSIDESSYSBIS00
	Sleep	2
    Click Element	wnd[0]/tbar[0]/btn[11]
	Sleep	2
Creating_PO
    Run Transaction    /nme21n
	Sleep	2
	Send Vkey	0
	Sleep	2
	Click Element    wnd[0]/usr/subSUB0:SAPLMEGUI:0016/subSUB1:SAPLMEVIEWS:1100/subSUB1:SAPLMEVIEWS:4000/btnDYN_4000-BUTTON
    Sleep    1
	Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB0:SAPLMEGUI:0030/subSUB1:SAPLMEGUI:1105/ctxtMEPO_TOPLINE-SUPERFIELD    5000000040
	Sleep	2
	Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT10/ssubTABSTRIPCONTROL2SUB:SAPLMEGUI:1221/ctxtMEPO1222-EKORG    BCPR
	Sleep	2
	Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT10/ssubTABSTRIPCONTROL2SUB:SAPLMEGUI:1221/ctxtMEPO1222-EKGRP    001
	Sleep	2
	Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB1:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1102/tabsHEADER_DETAIL/tabpTABHDT10/ssubTABSTRIPCONTROL2SUB:SAPLMEGUI:1221/ctxtMEPO1222-BUKRS    BCS1
	Sleep	2
	Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-EMATN[4,0]    50066603
	Sleep	2
	Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/txtMEPO1211-MENGE[6,0]    1
	Sleep	2
	Input Text    wnd[0]/usr/subSUB0:SAPLMEGUI:0013/subSUB2:SAPLMEVIEWS:1100/subSUB2:SAPLMEVIEWS:1200/subSUB1:SAPLMEGUI:1211/tblSAPLMEGUITC_1211/ctxtMEPO1211-NAME1[15,0]    BCSP
	Sleep	2
	Send Vkey	0
    Click Element	wnd[0]/mbar/menu[0]/menu[5]
	Sleep	2
	Select From List By key    wnd[0]/usr/tblSAPDV70ATC_NAST3/cmbNAST-NACHA[3,0]	A
	Sleep	2
	Set Focus    wnd[0]/usr/tblSAPDV70ATC_NAST3/cmbNAST-NACHA[3,0]
	Sleep	2
	Click Element    wnd[0]/tbar[1]/btn[5]
	Sleep	2
	Select From List By key    wnd[0]/usr/cmbNAST-VSZTP    4
	Sleep	2
	Click Element    wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Click Element    wnd[0]/tbar[0]/btn[11]
	Sleep	2