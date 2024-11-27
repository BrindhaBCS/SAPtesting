*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    Merger.py
Library    OperatingSystem
Library    String
Library    DateTime
*** Variables ***
${STEP}    30
${TREE_PATH}    wnd[0]/usr/cntlCONTAINER_0100/shellcont/shell/shellcont[0]/shell
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
PVH_SM21
    Run Transaction    /nSM21
    Sleep    1
    ${FROM_DATE}    Get Current Date    result_format=%d.%m.%Y    increment=-1 day
    Clear Field Text    wnd[0]/usr/ctxtDATE_FR
    SAP_Tcode_Library.Input Text    wnd[0]/usr/ctxtDATE_FR    ${FROM_DATE}
    ${current_utc_time}=    Get Current Date    result_format=%H:%M:%S
    Log    Current IST time: ${current_utc_time}
    SAP_Tcode_Library.Input Text    wnd[0]/usr/ctxtTIME_FR    ${current_utc_time}
    ${TO_DATE}    Get Current Date    result_format=%d.%m.%Y
    Clear Field Text    wnd[0]/usr/ctxtDATE_TO
    SAP_Tcode_Library.Input Text    wnd[0]/usr/ctxtDATE_TO    ${TO_DATE}
    SAP_Tcode_Library.Input Text    wnd[0]/usr/ctxtTIME_TO    ${current_utc_time}
    SAP_Tcode_Library.Click Element	wnd[0]/tbar[1]/btn[8]
	Sleep	1
    ${row_count}    Get Row Count    wnd[0]/usr/cntlCONTAINER_0100/shellcont/shell/shellcont[0]/shell
    Log    Total Row Count: ${row_count}
    ${counter}=    Set Variable    1
    FOR    ${i}    IN RANGE    1    ${row_count + 1}    39
        Log    Processing row ${i}
        ${selected_rows}    Selected_rows    ${TREE_PATH}    ${i}
        Log To Console    Selected rows: ${selected_rows}
        Take Screenshot    SM21_${counter}st.jpg
        ${counter}=    Evaluate    ${counter} + 1
        Sleep    1
    END
    Copy Images    ${OUTPUT_DIR}    ${symvar('PVH_Target_Dir')}


