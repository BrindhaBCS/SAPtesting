*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py
*** Variables ***

${TREE_PATH}    wnd[0]/usr/tblSAPL0SFNTCTRL_V_FILENACI
*** Keywords ***
System Logon
    Start Process     ${symvar('Heineken_SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('Heineken_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Heineken_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Heineken_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}            
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{DL1_PASSWORD}  
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1

RSA1
    Run Transaction    /NRSA1
    Sleep   2
    Take Screenshot    015_RSA1_01.jpg
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    5
    TRY
    Collapse Node	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	${SPACE*10}1
	Sleep	2
    EXCEPT
    Collapse Node	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	${SPACE*9}1
    END
    Click Toolbar Button	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[0]/shell	%AWB_SUBTREE_EXPAND
	Sleep	5

	Select Item	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	${SPACE*9}16	COL1
	Sleep	2
	Ensure Visible Horizontal Item	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	${SPACE*9}16	COL1
	Sleep	2
	itemContextMenu	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	 ${SPACE*9}16	 COL1
	Sleep	2
	Select Context Menu Item Customised	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	CHECK_LSYS
    Sleep    2
    Take Screenshot    015_RSA1_02.jpg
	Close Window	wnd[0]/shellcont[2]
	Sleep	2



	Select Item	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	${SPACE*9}18	COL1
	Sleep	2
	Ensure Visible Horizontal Item	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	${SPACE*9}18	COL1
	Sleep	2
	itemContextMenu	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	   ${SPACE*9}18	 COL1
	Sleep	2
	Select Context Menu Item Customised	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	CHECK_LSYS
	Sleep	10
    Take Screenshot    015_RSA1_03.jpg
	Close Window	wnd[0]/shellcont[2]
	Sleep	2
  




	Select Item	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	${SPACE*9}19	COL1
	Sleep	2
	Ensure Visible Horizontal Item	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	${SPACE*9}19	COL1
	Sleep	2
	itemContextMenu	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	  ${SPACE*9}19	 COL1
	Sleep	10
	Close Window	wnd[1]
	Sleep	2
	Select Context Menu Item Customised	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	CHECK_LSYS
	Sleep	20
    Take Screenshot    015_RSA1_04.jpg
	Close Window	wnd[0]/shellcont[2]
	Sleep	2
    # Collapse Node	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	${SPACE*10}9
	# Sleep	2



    # Expand Node	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	${SPACE*9}12
	# Sleep	2
	Select Item	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	${SPACE*9}20	COL1
	Sleep	2
	Ensure Visible Horizontal Item	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	${SPACE*9}20	COL1
	Sleep	2
	itemContextMenu	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	  ${SPACE*9}20	 COL1
	Sleep	2
	Select Context Menu Item Customised	wnd[0]/shellcont[1]/shell/shellcont[0]/shell/shellcont[1]/shell/shellcont[1]/shell	CHECK_LSYS
	Sleep	2
    Take Screenshot    015_RSA1_05.jpg
    ${status}    Get Status Pane    wnd[0]/sbar/pane[0]

    Take Screenshot   015_RSA1_06.jpg
	Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}



System logout
    Run Transaction    /nex
    