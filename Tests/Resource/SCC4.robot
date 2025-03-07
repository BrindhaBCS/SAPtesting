*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    Merger.py

*** Keywords ***
System Logon
    Start Process     ${symvar('Heineken_SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('Heineken_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Heineken_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Heineken_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}            
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{DL1_PASSWORD}  
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
System Logout
    Run Transaction   /nex
    Sleep    5
    

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
        ${current_screenshot}    Set Variable    000_SCC4_01_${index + 1}.jpg
        Set Focus    wnd[0]/usr/tblSAPL0SZZTCTRL_T000/txtT000-MANDT[0,${index}]
        Sleep    1
        ${double_click_status}    Send Vkey    vkey_id=2    window=0
        Sleep    1
        ${Screen_shot}    Take Screenshot    ${current_screenshot}
        Click Element    wnd[0]/tbar[0]/btn[3]
    END
    Sleep    6
    Merger.Copy Images    ${OUTPUT_DIR}    ${symvar('screenshot_directory')}
    Sleep    1
    