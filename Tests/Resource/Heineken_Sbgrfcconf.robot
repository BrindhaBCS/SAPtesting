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

Sbgrfcconf_Tcode
    Run Transaction    /nSbgrfcconf
    Sleep    2
    Take Screenshot    Sbgrfcconf.jpg
    Sleep    2
    Click Element    wnd[0]/usr/tabsMAINSTRIP/tabpMAINSTRIP_FC2
	Sleep	2
    Take Screenshot    Sbgrfcconf1.jpg
	Click Element    wnd[0]/usr/tabsMAINSTRIP/tabpMAINSTRIP_FC3
	Sleep	2
    Take Screenshot    Sbgrfcconf2.jpg
	Click Element    wnd[0]/usr/tabsMAINSTRIP/tabpMAINSTRIP_FC4
	Sleep	2
    Take Screenshot    Sbgrfcconf3.jpg
	Click Element    wnd[0]/usr/tabsMAINSTRIP/tabpMAINSTRIP_FC5
	Sleep	2
    Take Screenshot    Sbgrfcconf4.jpg
    Run Transaction    /nex
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}