*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
 
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}    
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg
System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10
SECSTORE
    Run Transaction    /nSECSTORE
    Sleep    2
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP_TAB/tabpT_CHECK
    Sleep    1
    Take Screenshot    SECSTORE_1.jpg
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP_TAB/tabpT_KEY
    Sleep    1
    Take Screenshot    SECSTORE_2.jpg
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP_TAB/tabpT_GLOB
    Sleep    1
    Take Screenshot    SECSTORE_3.jpg
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP_TAB/tabpT_CHECK
    Sleep    1
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    25s
    FOR    ${i}    IN RANGE    13
            Selected Rows    /app/con[0]/ses[0]/wnd[0]/usr/subSUBSCREEN:SAPLSBAL_DISPLAY:0101/cntlSAPLSBAL_DISPLAY_CONTAINER/shellcont/shell/shellcont[1]/shell    ${i*34}
            Sleep    1
            Take Screenshot    SECSTORE_${i+3}.jpg
    END
    Sleep    6