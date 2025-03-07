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

STMS
    Run Transaction    /nSTMS
    Sleep    1
    Take Screenshot    035_STMS_01.jpg
    Click Element	wnd[0]/tbar[1]/btn[19]
	Sleep	2
    Take Screenshot    035_STMS_02.jpg
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Click Element	wnd[0]/tbar[1]/btn[18]
	Sleep	2
    Take Screenshot    035_STMS_03.jpg
    Double Click Current Cell	wnd[0]/usr/cntlGRID1/shellcont/shell
	Sleep	2
    Take Screenshot    035_STMS_04.jpg
    Click Element	wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpDOMA
	Sleep	2
    Take Screenshot    035_STMS_05.jpg
    Click Element	wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpTPPE
	Sleep	2
    Take Screenshot    035_STMS_06.jpg
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Connection_test
Connection_test    
	Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[0]
	Sleep	2
    Take Screenshot    035_STMS_07.jpg
    Click Element	wnd[0]/mbar/menu[0]/menu[3]/menu[1]
	Sleep	2
    Set Focus	wnd[0]/usr/lbl[8,3]
	Sleep	2
	Set Caret Position	wnd[0]/usr/lbl[8,3]	0
	Sleep	2
	Click Element	wnd[0]/tbar[1]/btn[47]
	Sleep	2
        ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    1    20    5
        ${scroll}    Scroll    wnd[0]/usr   ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    035_STMS_08_${counter}.jpg
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
    FOR    ${index}    IN RANGE    1    13    3
        ${scroll}    Scroll    wnd[0]/usr   ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    035_STMS_09_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Click Element	wnd[0]/tbar[0]/btn[3]
	Sleep	2
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}

System logout
    Run Transaction    /nex  
    