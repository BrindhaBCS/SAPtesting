*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
SM14
    Start Process     ${symvar('Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Olympus_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Olympus_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Olympus_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Run Transaction    /nSM14
    Sleep    1
    Take Screenshot    024_SM14_01.jpg
    Click Element	wnd[0]/usr/tabsFOLDER/tabpUPDATE/ssubSUBSUPDATE:SAPMSM14:1010/btnALL_REQUESTS
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Take Screenshot    024_SM14_02.jpg
	Click Element	wnd[0]/usr/tabsFOLDER/tabpSERVERS
	Sleep	2
    Take Screenshot    024_SM14_03.jpg
	Click Element	wnd[0]/usr/tabsFOLDER/tabpGROUPS
	Sleep	2
    Take Screenshot    024_SM14_04.jpg
	Click Element	wnd[0]/usr/tabsFOLDER/tabpPARAMETERS
	Sleep	2
    Take Screenshot    024_SM14_05.jpg
    Click Element    wnd[0]/tbar[0]/btn[3]
    Run Transaction    /nex