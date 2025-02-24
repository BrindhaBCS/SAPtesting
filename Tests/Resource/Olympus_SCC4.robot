*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    String
# Library    Merger.py
*** Keywords ***
SCC4
    Connect To Session
    Connect To Existing Connection   ${symvar('Olympus_SAP_connection')}
    Sleep    1  
    Run Transaction    /nSCC4
    Sleep    1
    Take Screenshot    SCC4.jpg
	Sleep	2
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
    Click Element    wnd[0]/tbar[0]/btn[3]