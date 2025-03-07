*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py 
Library    Merger.py
*** Keywords ***
System Logon
    Start Process     ${symvar('Heineken_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Heineken_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Heineken_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Heineken_User_Name')}
    Sleep    1
     # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Heineken_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Heineken_User_Password}
    Send Vkey    0
    Multiple Logon Handling   wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
 
SMLG
    Run Transaction    /NSMLG
	Sleep	2
    Take Screenshot    smlg.jpg01
    Set Focus	wnd[0]/usr/lbl[32,3]
	Sleep	2
	Set Caret Position	wnd[0]/usr/lbl[32,3]	0
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[14]
	Sleep	2
	Click Element	wnd[1]/usr/tabsSEL_TAB/tabpPROP
	Sleep	2
    Take Screenshot    SMLG.jpg02
    Close Window	wnd[1]
    Sleep    2
    Click Element	wnd[0]/tbar[1]/btn[5]
	Sleep	2
    Take Screenshot    smlg.jpg03


System logout
    Run Transaction    /nex    
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}