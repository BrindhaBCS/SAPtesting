*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${Olympus_filename}    ${symvar('Olympus_filename')}
   

${ABB_Olympus_SAP_SERVER}    ${symvar('ABB_Olympus_SAP_SERVER')}
${ABB_Olympus_SAP_connection}    ${symvar('ABB_Olympus_SAP_connection')}

*** Keywords ***
System Logon
# ABAP system credentials and server
    Start Process     ${symvar('ABB_Olympus_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('ABB_Olympus_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABB_Olympus_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABB_Olympus_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABB_Olympus_User_Password')}     
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABB_lympus_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
SA38  
    Run Transaction    /nSA38
    Sleep   2
    Input Text	wnd[0]/usr/ctxtRS38M-PROGRAMM	RSRFCCHK
	Sleep	2
	Click Element	wnd[0]/mbar/menu[0]/menu[0]
	Sleep	2
	Select Checkbox    wnd[0]/usr/chkALL_DEST	
	Sleep	2
	Select Checkbox    wnd[0]/usr/chkEXCL_LOC	
	Sleep	2
	Select Checkbox    wnd[0]/usr/chkCONN_TST	
	Sleep	2
    Input Text	wnd[0]/usr/ctxtSTYPE-LOW	*
    Sleep    2
	Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	6
    Send Vkey    0
    Sleep    1
    Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[1]
	Sleep	2
    Delete Specific File    C:\\tmp\\${Olympus_filename}
    Sleep    2
	# Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[1]
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_PATH	C:\\tmp
	Sleep	2
	Input Text	wnd[1]/usr/ctxtDY_FILENAME	${Olympus_filename}
	Sleep	2
	Click Element	wnd[1]/tbar[0]/btn[0]
	Sleep	2

System Logout
    Run Transaction    /nex
    Sleep    1