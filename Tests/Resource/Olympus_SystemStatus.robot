*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
SystemStatus
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
    Click Element	wnd[0]/mbar/menu[4]/menu[11]
	Sleep	2
    Take Screenshot    SystemStatus.jpg
    Click Element	wnd[1]/tbar[0]/btn[17]
	Sleep	2
    Take Screenshot    Kernal.jpg
    Close Window	wnd[2]
	Sleep	2
    Click Element	wnd[1]/usr/btnPRELINFO
	Sleep	2
    Take Screenshot    SAP_systemdata.jpg
    Click Element	wnd[2]/usr/tabsVERSDETAILS/tabpPROD_VERS
	Sleep	2
    Take Screenshot    installationdetails.jpg
    Close Window	wnd[2]
	Sleep	2
	Close Window	wnd[1]
	Sleep	2
    Run Transaction    /nex
 
   
