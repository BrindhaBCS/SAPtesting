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
 
SM51
    Run Transaction    SM51
	Sleep	2
    Take Screenshot    025_SM51_01.jpg
    Click Element	wnd[0]/tbar[0]/btn[0]
	Sleep	2
	Double Click Current Cell	wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell
	Sleep	2
    Take Screenshot    025_SM51_02.jpg
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}

System logout
    Run Transaction    /nex
    