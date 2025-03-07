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
 
RZ12
    Run Transaction    RZ12
	Sleep	2
    Take Screenshot    018_RZ12_01.jpg
    Send Vkey    0
    Set Focus	wnd[0]/usr/lbl[13,3]
	Sleep	2
    Click Element	wnd[0]/tbar[1]/btn[2]
	Sleep	2
    Take Screenshot    018_RZ12_02.jpg
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}


System logout
    Run Transaction    /nex
    