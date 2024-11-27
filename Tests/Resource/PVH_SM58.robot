*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py
Library    OperatingSystem
Library    String
Library    DateTime
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('PVH_connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('PVH_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('PVH_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('PVH_User_Password')}  
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{PVH_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 

System Logout
    Run Transaction     /nex

PVH_SM58
    Run Transaction    /nSM58
    Sleep    1
    ${FROM_DATE}    Get Current Date    result_format=%d.%m.%Y    increment=-1 day
    Clear Field Text    wnd[0]/usr/ctxtZEITRAUM-LOW
    Input Text    wnd[0]/usr/ctxtZEITRAUM-LOW    ${FROM_DATE}
    ${TO_DATE}    Get Current Date    result_format=%d.%m.%Y
    Clear Field Text    wnd[0]/usr/ctxtZEITRAUM-HIGH
    Input Text    wnd[0]/usr/ctxtZEITRAUM-HIGH    ${TO_DATE}
    Clear Field Text    wnd[0]/usr/txtBENUTZER-LOW
    Sleep    1
    Input Text    wnd[0]/usr/txtBENUTZER-LOW    *
    Sleep    1
    Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	1
    Send Vkey	82
    Take Screenshot    SM58_1.jpg
	Sleep	2
	Send Vkey	82
    Take Screenshot    SM58_2.jpg
	Sleep	2
	Send Vkey	82
    Take Screenshot    SM58_3.jpg
	Sleep	2
	Send Vkey	82
    Take Screenshot    SM58_4.jpg
	Sleep	2
    Copy Images    ${OUTPUT_DIR}    ${symvar('PVH_Target_Dir')}