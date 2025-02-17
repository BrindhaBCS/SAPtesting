*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py
*** Keywords ***
SM59
    # Connect To Session
    # Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    # Sleep    1  
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
    Run Transaction    /nSM59
    Sleep    1
    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}1
	Sleep	1
    Take Screenshot    SM59.jpg01
    Collapse Node	wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}1
	Sleep	2
    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}2
	Sleep	1
    Take Screenshot    SM59.jpg02
    Collapse Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}2
	Sleep	1
    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}3
	Sleep	1
      ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    10
        ${scroll}    Scroll    wnd[0]/usr   ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    SM59_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Collapse Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}3
	Sleep	1
    Expand Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}4
	Sleep	1
    Take Screenshot    SM59.jpg04
    Collapse Node    wnd[0]/usr/cntlSM59CNTL_AREA/shellcont/shell/shellcont[1]/shell[1]	${SPACE*10}4
	Sleep	1
    Run Transaction    /nex 
