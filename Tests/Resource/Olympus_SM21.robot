*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py 
Library    Merger.py

*** Keywords ***
System Logon
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
    Multiple Logon Handling   wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
 
SM21_Tcodes
    Run Transaction    /nSM21
    Sleep    2
    Input Text	wnd[0]/usr/ctxtDATE_FR	${EMPTY}
	Sleep	2
    Input Text	wnd[0]/usr/txtMANDTOPT-LOW	*
	Sleep	2
    Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	2
    Take Screenshot    048_SM21_01.jpg
    First Visible Row	wnd[0]/usr/cntlCONTAINER_0100/shellcont/shell/shellcont[0]/shell	247
	Sleep	2
    Take Screenshot    048_SM21_02.jpg 
    run Transaction    /nex    
   Sleep    5
   Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}