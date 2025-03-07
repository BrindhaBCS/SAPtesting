*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py 
Library    Merger.py
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
 
SMLG
    Run Transaction    /NSMLG
	Sleep	2
    Take Screenshot    030_smlg_01.jpg
    Set Focus	wnd[0]/usr/lbl[32,3]
	Sleep	2
	Set Caret Position	wnd[0]/usr/lbl[32,3]	0
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[14]
	Sleep	2
	Click Element	wnd[1]/usr/tabsSEL_TAB/tabpPROP
	Sleep	2
    Take Screenshot    030_smlg_02.jpg
    Close Window	wnd[1]
    Sleep    2
    Click Element	wnd[0]/tbar[1]/btn[5]
	Sleep	2
    Take Screenshot    030_smlg_03.jpg
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}


System logout
    Run Transaction    /nex    
    