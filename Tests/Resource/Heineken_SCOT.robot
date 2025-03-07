*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py 
Library    Merger.py
*** Variables ***

${TREE_PATH}    wnd[0]/usr
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
 
scot
    Run Transaction    SCOT
	Sleep	2
    Take Screenshot    022_SCOT_01.jpg
    TRY
    Double Click On Tree Item	wnd[0]/shellcont/shell/shellcont[1]/shell	${SPACE*9}22
	Sleep	2
    Doubleclick Element	wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_NODES:0100/cntlSMTP_NODES_COLUMN_TREE_CONT/shellcont/shell	SMTP1	Node
	Sleep	2
    Take Screenshot    022_SCOT_02.jpg
    Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[12]
	Sleep	2
    EXCEPT
    Log    No option available
    END

    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}    

System logout
    Run Transaction    /nex
   
