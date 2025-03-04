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
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{HEINEKEN_PASSWORD}   
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

SCC4
    Run Transaction    scc4
    Sleep    3

    ${count_row}    Get Value    wnd[0]/usr/txtVIM_POSITION_INFO
    Log    ${count_row}
    ${start_index}    Set Variable    ${count_row.find("of ") + 3}
    ${end_index}    Set Variable    ${count_row.find("of ") + 4}
    ${number_value}    Get Substring    ${count_row}    ${start_index}    ${end_index}
    Log    ${number_value}
    FOR    ${index}    IN RANGE    ${number_value}
        ${current_screenshot}    Set Variable    SCC4${index + 1}.jpg
        Set Focus    wnd[0]/usr/tblSAPL0SZZTCTRL_T000/txtT000-MANDT[0,${index}]
        Sleep    1
        ${double_click_status}    Send Vkey    vkey_id=2    window=0
        Sleep    1
        ${Screen_shot}    Take Screenshot    ${current_screenshot}
        Click Element    wnd[0]/tbar[0]/btn[3]
    END
    Sleep    6
    