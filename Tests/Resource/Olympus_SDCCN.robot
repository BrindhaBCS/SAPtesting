*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py

*** Keywords ***
SDCCN
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
    Run Transaction    /nSDCCN
    Sleep    1
    Take Screenshot    023_Sdccn_01.jpg
    Click Element	wnd[0]/usr/tabsGC_TASK_TABSTRIP/tabpOUTBOX
	Sleep	2
    Take Screenshot    023_Sdccn_02.jpg
	Click Element	wnd[0]/usr/tabsGC_TASK_TABSTRIP/tabpDEL_ITEMS
	Sleep	2
    Take Screenshot    023_Sdccn_03.jpg
	Click Element	wnd[0]/usr/tabsGC_TASK_TABSTRIP/tabpSHOWLOG
	Sleep	2
    Take Screenshot    023_Sdccn_04.jpg
    Click Element    wnd[0]/tbar[0]/btn[3]
    Run Transaction    /nex
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}