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

WE20_Tcode
    Run Transaction    /nWE20
	Sleep    2
	Send Vkey    0
	Take Screenshot    039_WE20_01.jpg
	Expand Element    wnd[0]/shellcont/shell    LS
	Sleep	2
	Take Screenshot    039_WE20_02.jpg
	Select Node    wnd[0]/shellcont/shell	1${SPACE*9}LS    Column1
	Sleep	2
	Take Screenshot    039_WE20_03.jpg
	Select Node Link	wnd[0]/shellcont/shell	1${SPACE*9}LS	Column1
	Sleep	2
	Take Screenshot    039_WE20_04.jpg
	Click Element	wnd[0]/usr/tabsTABSTRIP/tabpTAB2
	Sleep	2
	Take Screenshot    039_WE20_05.jpg
	Select Node    	wnd[0]/shellcont/shell    2${SPACE*9}LS    Column1
	Sleep	2
	Take Screenshot    039_WE20_06.jpg
	Select Node Link	wnd[0]/shellcont/shell	2${SPACE*9}LS	Column1
	Sleep	2
	Click Element	wnd[0]/usr/tabsTABSTRIP/tabpTAB2
	Sleep	2
	Take Screenshot    039_WE20_07.jpg
    
	Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}

System logout
    Run Transaction    /nex

	