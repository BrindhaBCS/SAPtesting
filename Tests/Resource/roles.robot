*** Settings ***
Library    Process
Library    roleprocess.py

*** Keywords ***
START
    Start Process    ${sapvar('role_sapserver')}
    Sleep    2
    Connect To Session
    Open Connection    ${sapvar('role_server')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${sapvar('role_name')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${sapvar('role_password')}
	Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{role_password}
    Send Vkey    wnd[0]    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

PFCG_TCODE
	Run Transaction	wnd[0]/tbar[0]/okcd	PFCG
	Sleep	2
	Send Vkey	wnd[0]	0
	Sleep	2
	Input Text	wnd[0]/usr/ctxtAGR_NAME_NEU	ZS_TEST_DEMO
	Sleep	2
	Caret Position	wnd[0]/usr/ctxtAGR_NAME_NEU	12
	Sleep	2
	Click Element	wnd[0]/usr/btn%#AUTOTEXT002
	Sleep	2
	Click Element	wnd[0]/usr/btn%#AUTOTEXT003
	Sleep	2
	Input Text	wnd[0]/usr/txtS_AGR_TEXTS-TEXT	Test
	Sleep	2
	Caret Position	wnd[0]/usr/txtS_AGR_TEXTS-TEXT	4
	Sleep	2
	Click Element	wnd[0]/usr/tabsTABSTRIP1/tabpTAB9
	Sleep	2
	Click Element	wnd[1]/usr/btnBUTTON_1
	Sleep	2
	Click Toolbar Button	wnd[0]/usr/tabsTABSTRIP1/tabpTAB9/ssubSUB1:SAPLPRGN_TREE:0321/cntlTOOL_CONTROL/shellcont/shell	TB03
	Sleep	2
	Input Text	wnd[1]/usr/tblSAPLPRGN_WIZARDCTRL_TCODE/ctxtS_TCODES-TCODE[0,0]	SU01
	Sleep	2
	Input Text	wnd[1]/usr/tblSAPLPRGN_WIZARDCTRL_TCODE/ctxtS_TCODES-TCODE[0,1]	SU10
	Sleep	2
	Set Focus	wnd[1]/usr/tblSAPLPRGN_WIZARDCTRL_TCODE/ctxtS_TCODES-TCODE[0,1]
	Sleep	2
	Caret Position	wnd[1]/usr/tblSAPLPRGN_WIZARDCTRL_TCODE/ctxtS_TCODES-TCODE[0,1]	4
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[19]
	Sleep	2
	Click Element	wnd[0]/usr/tabsTABSTRIP1/tabpTAB5
	Sleep	2
	Click Element	wnd[0]/usr/tabsTABSTRIP1/tabpTAB5/ssubSUB1:SAPLPRGN_TREE:0350/btnPROFIL1
	Sleep	2
	Click Element	wnd[1]/usr/btnBUTTON_1
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Close Window	wnd[1]
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[5,4]
	Sleep	2
	Caret Position	wnd[0]/usr/lbl[5,4]	1
	Sleep	2
	Send Vkey	wnd[0]	2
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[9,6]
	Sleep	2
	Caret Position	wnd[0]/usr/lbl[9,6]	1
	Sleep	2
	Send Vkey	wnd[0]	2
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[5,12]
	Sleep	2
	Caret Position	wnd[0]/usr/lbl[5,12]	0
	Sleep	2
	Send Vkey	wnd[0]	2
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[9,14]
	Sleep	2
	Caret Position	wnd[0]/usr/lbl[9,14]	1
	Sleep	2
	Send Vkey	wnd[0]	2
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[9,21]
	Sleep	2
	Caret Position	wnd[0]/usr/lbl[9,21]	1
	Sleep	2
	Send Vkey	wnd[0]	2
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[9,28]
	Sleep	2
	Caret Position	wnd[0]/usr/lbl[9,28]	0
	Sleep	2
	Send Vkey	wnd[0]	2
	Sleep	2
	Scroll	wnd[0]/usr	1 
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[9,35]
	Sleep	2
	Caret Position	wnd[0]/usr/lbl[9,35]	0
	Sleep	2
	Send Vkey	wnd[0]	2
	Sleep	2
	Scroll	wnd[0]/usr	3 
	Sleep	2
	Scroll	wnd[0]/usr	4 
	Sleep	2
	Scroll	wnd[0]/usr	5 
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[7,34]
	Sleep	2
	Caret Position	wnd[0]/usr/lbl[7,34]	2
	Sleep	2
	Scroll	wnd[0]/usr	6 
	Sleep	2
	Scroll	wnd[0]/usr	7 
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[9,36]
	Sleep	2
	Caret Position	wnd[0]/usr/lbl[9,36]	0
	Sleep	2
	Send Vkey	wnd[0]	2
	Sleep	2
	Scroll	wnd[0]/usr	10 
	Sleep	2
	Scroll	wnd[0]/usr	11 
	Sleep	2
	Scroll	wnd[0]/usr	12 
	Sleep	2
	Scroll	wnd[0]/usr	13 
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[9,37]
	Sleep	2
	Caret Position	wnd[0]/usr/lbl[9,37]	0
	Sleep	2
	Send Vkey	wnd[0]	2
	Sleep	2
	Scroll	wnd[0]/usr	20 
	Sleep	2
	Scroll	wnd[0]/usr	21 
	Sleep	2
	Scroll	wnd[0]/usr	22 
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[9,38]
	Sleep	2
	Caret Position	wnd[0]/usr/lbl[9,38]	1
	Sleep	2
	Send Vkey	wnd[0]	2
	Sleep	2
	Scroll	wnd[0]/usr	27 
	Sleep	2
	Scroll	wnd[0]/usr	26 
	Sleep	2
	Scroll	wnd[0]/usr	25 
	Sleep	2
	Scroll	wnd[0]/usr	24 
	Sleep	2
	Scroll	wnd[0]/usr	23 
	Sleep	2
	Scroll	wnd[0]/usr	22 
	Sleep	2
	Scroll	wnd[0]/usr	21 
	Sleep	2
	Scroll	wnd[0]/usr	20 
	Sleep	2
	Scroll	wnd[0]/usr	19 
	Sleep	2
	Scroll	wnd[0]/usr	18 
	Sleep	2
	Scroll	wnd[0]/usr	17 
	Sleep	2
	Scroll	wnd[0]/usr	16 
	Sleep	2
	Scroll	wnd[0]/usr	15 
	Sleep	2
	Scroll	wnd[0]/usr	14 
	Sleep	2
	Scroll	wnd[0]/usr	13 
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[11]
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[17]
	Sleep	2
	Click Element	wnd[1]/usr/btnBUTTON_1
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Click Element	wnd[0]/usr/btn%#AUTOTEXT002
	Sleep	2
	Click Element	wnd[0]/usr/tabsTABSTRIP1/tabpTAB5
	Sleep	2
	Set Focus	wnd[0]/usr/tabsTABSTRIP1/tabpTAB5/ssubSUB1:SAPLPRGN_TREE:0350/txtG_PROFILE
	Sleep	2
	Caret Position	wnd[0]/usr/tabsTABSTRIP1/tabpTAB5/ssubSUB1:SAPLPRGN_TREE:0350/txtG_PROFILE	8
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Click Element	wnd[0]/mbar/menu[0]/menu[6]
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\RobotFramework
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_FILENAME	demo2
	Sleep	2
	Caret Position	wnd[1]/usr/ctxtDY_FILENAME	5
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[11]
	Sleep	2
	Current Cell Column	wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell	ROLE
	Sleep	2
	Select Table Row	wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell	0
	Sleep	2
	Current Cell Column	wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell	ROLE
	Sleep	2
	# Click Current Cell	wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell
	# Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Click Element	wnd[0]/mbar/menu[0]/menu[7]
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\RobotFramework
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_FILENAME	demo2
	Sleep	2
	Caret Position	wnd[1]/usr/ctxtDY_FILENAME	5
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Run Transaction	wnd[0]/tbar[0]/okcd	pfcg
	Sleep	2
	Send Vkey	wnd[0]	0
	Sleep	2
	Click Element	wnd[0]/usr/btn%#AUTOTEXT002
	Sleep	2
	Click Element	wnd[0]/usr/tabsTABSTRIP1/tabpTAB5
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[14]
	Sleep	2
	Click Element	wnd[1]/usr/btnBUTTON_1
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Run Transaction	wnd[0]/tbar[0]/okcd	/n
	Sleep	2
	Send Vkey	wnd[0]	0
	Sleep	2
