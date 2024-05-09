*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    PDF.py

*** Variables ***
${screenshot_directory}     ${OUTPUT_DIR}
${PDF_Dir}    ${OUTPUT_DIR}\\SM61_REFRESH.pdf

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

SM61_T_CODE
    Run Transaction    /nSM61 
    Sleep    2
    Click Element    wnd[0]/usr/tabsCONTROL_TAB/tabpOBJT
    Sleep    1
    Take Screenshot    01_SM61_Object.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsCONTROL_TAB/tabpTRCT
    Sleep    1
    Take Screenshot    02_SM61_Trace.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsCONTROL_TAB/tabpTENV
    Sleep    1
    Take Screenshot    03_SM16_Health_check.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsCONTROL_TAB/tabpTENV/ssubSUB_OBJ:SAPLCOBJ:0140/btnBUTTON2
    Sleep    2
    Take Screenshot    04_SM16_Health_check_All_background_server_check.jpg
    Sleep    2