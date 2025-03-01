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
 
SMQ2_Tcodes
    Run Transaction     /nSMQ2
    Sleep    2
    Input Text	wnd[0]/usr/txtCLIENT	*
	Sleep	2
    Take Screenshot    SMQ2.jpg
	Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	2
    ${counter}=    Set Variable    1
    FOR    ${index}    IN RANGE    2
        ${scroll}    Scroll    wnd[0]/usr      ${index}
        Log To Console    Selected rows: $${scroll}
        Take Screenshot    SMQ2_${counter}.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
     END
    Run Transaction     /nex
    Sleep    5
    Copy Images    ${OUTPUT_DIR}    ${symvar('target_directory')}