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

SCC4_T_CODE
    Run Transaction    /nSCC4
    Sleep    2
<<<<<<< HEAD
    FOR    ${index}    IN RANGE    1000
=======
    ${count_row}    Get Row Count    /app/con[0]/ses[0]/wnd[0]/usr/tblSAPL0SZZTCTRL_T000
    Log    ${count_row}
    FOR    ${index}    IN RANGE    9
>>>>>>> fb08de5b1bb700eb6621249137922e6bb249e3d8
        ${current_screenshot}    Set Variable    SCC4${index + 1}.jpg
        ${focus}=    Run Keyword And Return Status    Set Focus    wnd[0]/usr/tblSAPL0SZZTCTRL_T000/txtT000-MANDT[0,${index}]
        Run Keyword If    not ${focus}    Exit For Loop
        Sleep    1
        ${double_click_status}=    Run Keyword And Return Status    Send Vkey    vkey_id=2    window=0
<<<<<<< HEAD
        Run Keyword If    not ${double_click_status}    Exit For Loop    
        Sleep    1
        ${Screen_shot}    Take Screenshot    ${current_screenshot}
        Click Element    wnd[0]/tbar[0]/btn[3]    
=======
        Sleep    1
        ${Screen_shot}    Take Screenshot    ${current_screenshot}
        Click Element    ${Back}
        Run Keyword If    not ${double_click_status}    Exit For Loop     
>>>>>>> fb08de5b1bb700eb6621249137922e6bb249e3d8
    END