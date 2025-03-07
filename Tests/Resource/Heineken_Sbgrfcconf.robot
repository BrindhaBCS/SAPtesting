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

Sbgrfcconf_Tcode
    Run Transaction    /nSbgrfcconf
    Sleep    2
    Take Screenshot    021_Sbgrfcconf_01.jpg
    Sleep    2
    Click Element    wnd[0]/usr/tabsMAINSTRIP/tabpMAINSTRIP_FC2
	Sleep	2
    Take Screenshot    021_Sbgrfcconf_02.jpg
	Click Element    wnd[0]/usr/tabsMAINSTRIP/tabpMAINSTRIP_FC3
	Sleep	2
    Take Screenshot    021_Sbgrfcconf_03.jpg
	Click Element    wnd[0]/usr/tabsMAINSTRIP/tabpMAINSTRIP_FC4
	Sleep	2
    Take Screenshot    021_Sbgrfcconf_04.jpg
	Click Element    wnd[0]/usr/tabsMAINSTRIP/tabpMAINSTRIP_FC5
	Sleep	2
    Take Screenshot    021_Sbgrfcconf_05.jpg
    
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}

System logout
    Run Transaction    /nex