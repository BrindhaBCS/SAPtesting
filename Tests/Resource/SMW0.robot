*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
*** Variables ***
${max_scroll}    800
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
SMW0
    Run Transaction    /nSMW0
    Sleep    2
    Take Screenshot    SMW0.JPG
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    SMW0.JPG
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    ${continue_loop}=    Set Variable    ${TRUE}
    ${max_iterations}=    Set Variable    50
    FOR    ${i}    IN RANGE    1    ${max_iterations}
        Set Focus    wnd[0]/usr/tblSAPMWWW0OBJECT_LIST/txtWWWDATA_TAB-OBJID[0,1]    
        Sleep    5
        ${initial_scroll_position}    Get Scroll Position    wnd[0]/usr/tblSAPMWWW0OBJECT_LIST
        Log To Console    ${initial_scroll_position}
        Scroll    wnd[0]/usr/tblSAPMWWW0OBJECT_LIST    ${i*23}
        Take screenshot    ${i}.jpg
        Log To Console    ${i*23}
        Sleep    2
        ${final_scroll_position}    Get Scroll Position    wnd[0]/usr/tblSAPMWWW0OBJECT_LIST
        Log To Console    ${final_scroll_position}
        Run Keyword If    '${initial_scroll_position}' == '${final_scroll_position}'    Exit For Loop
     
    END
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
Binarydata SMW0
    Select Radio Button    wnd[0]/usr/radRADIO_MI        
    Sleep    2
    Take Screenshot    SMW0.JPG
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    SMW0.JPG
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    SMW0.JPG
    Sleep    2
    ${continue_loop}=    Set Variable    ${TRUE}
    ${max_iterations}=    Set Variable    150
    FOR    ${i}    IN RANGE    1    ${max_iterations}
        Set Focus    wnd[0]/usr/tblSAPMWWW0OBJECT_LIST/txtWWWDATA_TAB-OBJID[0,1]    
        Sleep    5
        ${initial_scroll_position}    Get Scroll Position    wnd[0]/usr/tblSAPMWWW0OBJECT_LIST
        Log To Console    ${initial_scroll_position}
        Scroll    wnd[0]/usr/tblSAPMWWW0OBJECT_LIST    ${i*23}
        Take screenshot    ${i}.jpg
        Log To Console    ${i*23}
        Sleep    2
        ${final_scroll_position}    Get Scroll Position    wnd[0]/usr/tblSAPMWWW0OBJECT_LIST
        Log To Console    ${final_scroll_position}
        Run Keyword If    '${initial_scroll_position}' == '${final_scroll_position}'    Exit For Loop
     
    END
    Sleep    6

