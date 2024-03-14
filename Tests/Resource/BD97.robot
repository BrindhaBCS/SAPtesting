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
    Sleep    10

BD97
    Run Transaction    /nBD97
    Sleep    2
    ${continue_loop}=    Set Variable    ${TRUE}
    ${max_iterations}=    Set Variable    15
    ${i}=    Set Variable    0
    FOR    ${i}    IN RANGE    0    ${max_iterations}
       ${initial_scroll_position}    Get Scroll Position    /app/con[0]/ses[0]/wnd[0]/usr
       Log To Console    ${initial_scroll_position}
       Send Vkey    82
       Take Screenshot    BD97_${i}.jpg
       Sleep    2
       ${final_scroll_position}    Get Scroll Position    /app/con[0]/ses[0]/wnd[0]/usr
       Log To Console    ${final_scroll_position}
       Run Keyword If    '${initial_scroll_position}' == '${final_scroll_position}'    Exit For Loop
    END  
    Sleep    6