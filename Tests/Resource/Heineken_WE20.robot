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

WE20_Tcode
    Run Transaction    /nWE20
	Sleep    2
	Send Vkey    0
	Take Screenshot    WE20.jpg
	Expand Element    wnd[0]/shellcont/shell    LS
	Sleep	2
	Take Screenshot    We20_1.jpg
	Select Node    wnd[0]/shellcont/shell	1${SPACE*9}LS    Column1
	Sleep	2
	Take Screenshot    We20_2.jpg
	Select Node Link	wnd[0]/shellcont/shell	1${SPACE*9}LS	Column1
	Sleep	2
	Take Screenshot    We20_3.jpg
	Click Element	wnd[0]/usr/tabsTABSTRIP/tabpTAB2
	Sleep	2
	Take Screenshot    We20_4.jpg
	Select Node    	wnd[0]/shellcont/shell    2${SPACE*9}LS    Column1
	Sleep	2
	Take Screenshot    We20_5.jpg
	Select Node Link	wnd[0]/shellcont/shell	2${SPACE*9}LS	Column1
	Sleep	2
	Click Element	wnd[0]/usr/tabsTABSTRIP/tabpTAB2
	Sleep	2
	Take Screenshot    We20_6.jpg
    Run Transaction    /nex
	Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}

	