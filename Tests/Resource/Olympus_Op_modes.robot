*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
os_modes
    Start Process     ${symvar('Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Olympus_User_Name')}
    Sleep    1
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Olympus_User_Password')}      
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1 
    Run Transaction    /nRZ04
    Sleep    1
    Take Screenshot    RZ04.jpg
    Set Focus	wnd[0]/usr/lbl[2,5]
	Sleep	2
	set Caret Position	wnd[0]/usr/lbl[2,5]	8
	Sleep	2
	Send Vkey	2
	Sleep	2
    Take Screenshot    RZ04.jpg01
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[2,6]
	Sleep	2
	Set Caret Position	wnd[0]/usr/lbl[2,6]	3
	Sleep	2
	Send Vkey    2  
	Sleep	2
    Take Screenshot    RZ04.jpg02
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Run Transaction    /nex


