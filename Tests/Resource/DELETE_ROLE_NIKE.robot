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
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
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

delete_role
    Run Transaction    /nPFCG
    Sleep    3
    FOR    ${delete_index}    IN RANGE    0    1000
        ${delete_role_input} =    Run Keyword And Return Status    Input Text    wnd[0]/usr/ctxtAGR_NAME_NEU    ${symvar('Delete_role_names')}[${delete_index}]
        Run Keyword If    not ${delete_role_input}    Exit For Loop
        Sleep    1
        Click Element    wnd[0]/tbar[1]/btn[14]            #delete 
        Sleep    1
        Click Element    wnd[1]/usr/btnBUTTON_1    #yes
        Sleep    1
        Take Screenshot
        Click Element    wnd[1]/tbar[0]/btn[0]    #tick
        Take Screenshot
        Sleep    1
    END