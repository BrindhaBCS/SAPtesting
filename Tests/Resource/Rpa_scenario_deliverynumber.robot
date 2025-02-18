*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    DateTime
Library    Collections
Library    Replay_Library.py

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('Rpa_Connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Rpa_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Rpa_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Rpa_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Rpa_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction     /nex
Vehicle_number_plate
    Run Transaction    /nVL33N
    Sleep    1
    Send Vkey    vkey_id=4
    Click Element    element_id=wnd[1]/usr/tabsG_SELONETABSTRIP/tabpTAB004
    Input Text    element_id=wnd[1]/usr/tabsG_SELONETABSTRIP/tabpTAB004/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/txtG_SELFLD_TAB-LOW[0,24]    text=${symvar('Rpa_vehicle_number')}
    ${Get_Current_Date}    Get Current Date    result_format=%d.%m.%Y
    # Input Text    element_id=wnd[1]/usr/tabsG_SELONETABSTRIP/tabpTAB004/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/ctxtG_SELFLD_TAB-LOW[1,24]    text=${Get_Current_Date}
    Input Text    element_id=wnd[1]/usr/tabsG_SELONETABSTRIP/tabpTAB004/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/ctxtG_SELFLD_TAB-LOW[1,24]    text=15.02.2025
    Click Element    element_id=wnd[1]/tbar[0]/btn[0]
    ${status}    Get Value    element_id=wnd[0]/sbar/pane[0]
    IF    '${status}' == ''
        ${delivery}    Run Keyword And Return Status        Get Value    element_id=wnd[1]/usr/lbl[1,3]
        IF    '${delivery}' == 'True'
            ${Forindex}    Set Variable    3
            ${Stone}    Create List
            WHILE    True 
                ${delivery_data_status}    Run Keyword And Return Status    Get Value    element_id=wnd[1]/usr/lbl[1,${Forindex}]
                IF    '${delivery_data_status}' == 'True'
                    Log To Console    message=**gbStart**Get_Pass**splitKeyValue**Vehicle_Allow**gbEnd**
                    ${delivery_data}    Get Value    element_id=wnd[1]/usr/lbl[1,${Forindex}]
                    Append To List    ${Stone}    ${delivery_data}
                    Log To Console    ${Stone}
                    ${Forindex}    Evaluate    ${Forindex} + 1
                ELSE
                    Exit For Loop
                END
            END
            ${jsondata}    Generate List To Json    numbers=${stone}
            Log To Console    message=**gbStart**Delivery_json**splitKeyValue**${jsondata}**gbEnd**
            Log To Console    message=${jsondata}
        ELSE
            Log To Console    message=**gbStart**Get_Pass**splitKeyValue**Vehicle_Block**gbEnd**
            System Logout
        END
    ELSE IF    '${status}' =='No values for this selection'
        Log To Console    message=**gbStart**Get_Pass**splitKeyValue**Vehicle_Block**gbEnd**
        System Logout
    ELSE
        Log To Console    message=**gbStart**Get_Pass**splitKeyValue**Vehicle_InputIssue_Block**gbEnd**
        System Logout
    END