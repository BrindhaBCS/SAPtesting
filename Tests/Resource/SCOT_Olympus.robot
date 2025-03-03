*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py
*** Variables ***
${ABB_Olympus_SAP_SERVER}    ${symvar('ABB_Olympus_SAP_SERVER')}
${ABB_Olympus_SAP_connection}    ${symvar('ABB_Olympus_SAP_connection')}

*** Keywords ***
System Logon
# ABAP system credentials and server
    Start Process     ${symvar('ABB_Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('ABB_Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABB_Olympus_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABB_Olympus_User_Password')}        
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Olympus_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
SCOT   
    Run Transaction    /nSCOT 
    Sleep   2
    # Click Element	wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Select Top Node	wnd[0]/shellcont/shell/shellcont[1]/shell	${SPACE*10}1
	Sleep	2
	Click Toolbar Button	wnd[0]/shellcont/shell/shellcont[0]/shell	&TB_COMP
	Sleep	2
	Click Toolbar Button	wnd[0]/shellcont/shell/shellcont[0]/shell	&TB_EXPA
	Sleep	2
    Double Click On Tree Item	wnd[0]/shellcont/shell/shellcont[1]/shell	${SPACE*9}12
	Sleep	2
    Take Screenshot    SCOT.jpg
    Double Click On Tree Item	wnd[0]/shellcont/shell/shellcont[1]/shell	${SPACE*9}22
	Sleep	2
    Doubleclick Element	wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_NODES:0100/cntlSMTP_NODES_COLUMN_TREE_CONT/shellcont/shell	SMTP1	Node
	Sleep	2
    Take Screenshot    SCOT_01.jpg
    Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[12]
	Sleep	2
    
System Logout
    Run Transaction    /nex
    Sleep    5
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}