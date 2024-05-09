*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    PDF.py

*** Variables ***
${screenshot_directory}     ${OUTPUT_DIR}
${PDF_Dir}    ${OUTPUT_DIR}\\DB01_databaselock.REFRESH.pdf

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}   
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg
 
System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    2
    Create Pdf    ${screenshot_directory}   ${PDF_Dir}
    Sleep    2

scenario-databaselock
    Run Transaction    /nDB01
    Sleep    2
    ${db01}=    Set Variable     ${SPACE*7}1003-
    Log To Console    ${db01}
    Expand Node    wnd[0]/shellcont[1]/shell/shellcont[1]/shell    ${db01}
    Sleep    2
    ${value1}=    Set Variable     ${SPACE*9}62
    Log To Console    ${value1}
    Select Item    wnd[0]/shellcont[1]/shell/shellcont[1]/shell    ${value1}    Task
    Sleep    2
    Doubleclick Element    wnd[0]/shellcont[1]/shell/shellcont[1]/shell    ${Value1}    Task
    Sleep    2
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP_DBOPT/tabpCURR
    Sleep    2
    FOR    ${i}    IN RANGE    8
        ${selected_rows}    Selected Rows    wnd[0]/usr/tabsTABSTRIP_DBOPT/tabpCURR/ssubCURR:SAPLSMSSCCMS:1401/cntlCURR_DBCONF/shellcont/shell    ${i*5}
        Log To Console    ${selected_rows}    
        Take Screenshot    ${i+1}st.jpg
        Sleep    1
    END