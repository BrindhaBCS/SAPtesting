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

download_role
    Run Transaction    /nPFCG
    Sleep    3
    FOR    ${download_index}    IN RANGE    0    1000
        ${download_role_input} =    Run Keyword And Return Status    Input Text    wnd[0]/usr/ctxtAGR_NAME_NEU    ${symvar('Download_role_names')}[${download_index}]
        Run Keyword If    not ${download_role_input}    Exit For Loop
        Click Element    wnd[0]/mbar/menu[0]/menu[6]        
        Sleep    1
        Click Element    wnd[1]/tbar[0]/btn[0]            
        Sleep    1
        Input Text    wnd[1]/usr/ctxtDY_PATH    ${EMPTY}
        Sleep    1
        Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('download_path')}
        Sleep    3
        Click Element    wnd[1]/tbar[0]/btn[0]       
        Sleep    1
        Take Screenshot
        Click Element    wnd[0]/tbar[0]/btn[3]        
        Sleep    2
        Take Screenshot    download_role_01.jpg
    END