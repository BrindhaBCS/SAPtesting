*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Keywords ***
System Logon
    Start Process     ${symvar('ABIN_SAP_SERVER')}    
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('ABIN_SAP_connection')}
    Sleep    1    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABIN_Client_Id')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABIN_User_Name')}
    Sleep    1
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABLN_User_Password')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABIN_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
 
   
System Logout
    Run Transaction   /nex
    # Sleep    2

ABB_SM59
    Run Transaction    /nSM59
    Sleep    1
    Take Screenshot    00_Pre_SM59.jpg
    Run Keyword And Ignore Error    Click Element    wnd[1]/tbar[0]/btn[0]
    


    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}7
	Sleep	1
    Take Screenshot    01_Pre_SM59_1.jpg
    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}6
	Sleep	1
    Take Screenshot    02_Pre_SM59_2.jpg
    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}5
	Sleep	1
    Take Screenshot    03_Pre_SM59_3.jpg
    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}4
	Sleep	1
    Take Screenshot    04_Pre_SM59_4.jpg
    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}3
	Sleep	1
    Take Screenshot    05_Pre_SM59_5.jpg
    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}2
	Sleep	1
    Take Screenshot    06_Pre_SM59_6.jpg
    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}1
	Sleep	2
    Take Screenshot    07_Pre_SM59_7.jpg
    
	Doubleclick Element	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*9}52	&Hierarchy
	Sleep	2
    Take Screenshot    08_Pre_SM59_8.jpg
	Click Element	wnd[0]/tbar[1]/btn[27]
	Sleep	2
    Take Screenshot    09_Pre_SM59_9.jpg

    
	
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
	Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Take Screenshot    010_Pre_SM59_10.jpg
    Doubleclick Element	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*9}59	&Hierarchy
	Sleep	2

    Take Screenshot    011_Pre_SM59_11.jpg
    ${Host_name}    Get Value    wnd[0]/usr/tabsTAB_SM59/tabpTECH/ssubSUB_SM59:SAPLCRFC:0500/txtHOSTNAME
    Log To Console    ${Host_name}
    Log To Console    **gbStart**Target_Host**splitKeyValue**${Host_name}**gbEnd**
    
    

    















