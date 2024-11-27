*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    DateTime
Library    Merger.py
*** Variables ***
${STEP}    30
${TREE_PATH}    wnd[0]/usr/cntlRSSHOWRABAX_ALV_100/shellcont/shell

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

PVH_ST22
    Run Transaction    /nST22
    Sleep    1
    ${FROM_DATE}    Get Current Date    result_format=%d.%m.%Y    increment=-1 day
    Clear Field Text    wnd[0]/usr/ctxtS_DATUM-LOW
    Input Text    wnd[0]/usr/ctxtS_DATUM-LOW    ${FROM_DATE}
    ${TO_DATE}    Get Current Date    result_format=%d.%m.%Y
    Clear Field Text    wnd[0]/usr/ctxtS_DATUM-HIGH 
    Input Text    wnd[0]/usr/ctxtS_DATUM-HIGH    ${TO_DATE}
    ${current_utc_time}=    Get Current Date    result_format=%H:%M:%S
    Log    Current IST time: ${current_utc_time}
    Input Text    wnd[0]/usr/ctxtS_UZEIT-HIGH    ${current_utc_time}
    Clear Field Text    wnd[0]/usr/txtS_UNAME-LOW 
    # Input Text    wnd[0]/usr/txtS_UNAME-LOW    *
    Click Element    wnd[0]/usr/btnSTARTSEL
    Sleep    10
    ${row_count}    Get Row Count    wnd[0]/usr/cntlRSSHOWRABAX_ALV_100/shellcont/shell
    Log    Total Row Count: ${row_count}
    FOR    ${i}     IN RANGE    1    ${row_count + 1}    39
        Log    Processing row ${i}
        ${selected_rows}    Selected_rows    ${TREE_PATH}    ${i}
        Log To Console    Selected rows: ${i}
        Take Screenshot    SM21_${i}st.jpg
        Sleep    1
    END
    Copy Images    ${OUTPUT_DIR}    ${symvar('PVH_Target_Dir')}
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('PVH_Target_Dir')}