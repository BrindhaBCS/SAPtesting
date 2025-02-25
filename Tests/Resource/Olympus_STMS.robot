*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
*** Keywords ***
STMS
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
    Run Transaction    /nSTMS
    Sleep    1
    Take Screenshot    STMS01.jpg
    Click Element	wnd[0]/tbar[1]/btn[19]
	Sleep	2
    Take Screenshot    STMS02.jpg
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Click Element	wnd[0]/tbar[1]/btn[18]
	Sleep	2
    Take Screenshot    STMS03.jpg
    Double Click Current Cell	wnd[0]/usr/cntlGRID1/shellcont/shell
	Sleep	2
    Take Screenshot    STMS04.jpg
    Click Element	wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpDOMA
	Sleep	2
    Take Screenshot    STMS05.jpg
    Click Element	wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpTPPE
	Sleep	2
    Take Screenshot    STMS06.jpg
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Connection_test
Connection_test    
	Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[0]
	Sleep	2
    Take Screenshot    STMS08.jpg
    Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[1]
	Sleep	2
    Set Focus	wnd[0]/usr/lbl[8,3]
	Sleep	2
	Set Caret Position	wnd[0]/usr/lbl[8,3]	0
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[47]
	Sleep	2
        ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    20
        ${scroll}    Scroll    wnd[0]/usr   ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    SM59_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[2]
	Sleep	2
	Set Focus	wnd[0]/usr/lbl[8,3]
	Sleep	2
	Set Caret Position	wnd[0]/usr/lbl[8,3]	0
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[47]
	Sleep	2
    ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    10
        ${scroll}    Scroll    wnd[0]/usr   ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    SM59_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Run Transaction    /nex