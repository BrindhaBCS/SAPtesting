*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    DateTime
Library    Collections
Library    Replay_Library.py
Library    OperatingSystem
*** Variables ***
${filepath}    c:\\tmp\\RPA\\Bin_allocation.txt

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('Rpa_Connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Rpa_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Rpa_UserName')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Rpa_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Rpa_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction     /nex
BIN_Allocation
    Run Transaction    /n/scwm/mon
    Delete Specific File    file_path=${filepath}
    Create File    path=${filepath}
    Run Keyword And Ignore Error    Input Text    element_id=wnd[1]/usr/ctxtP_LGNUM    text=BC01
    Run Keyword And Ignore Error    Input Text    element_id=wnd[1]/usr/ctxtP_MONIT    text=SAP
    Run Keyword And Ignore Error    Click Element    element_id=wnd[1]/tbar[0]/btn[8]
    Click Element    element_id=wnd[0]/tbar[1]/btn[18]
    Expand Element    tree_id=wnd[0]/usr/shell/shellcont[0]/shell    node_id=C000000002
    Expand Element    tree_id=wnd[0]/usr/shell/shellcont[0]/shell    node_id=C000000005
    Expand Element    tree_id=wnd[0]/usr/shell/shellcont[0]/shell    node_id=N000000085
    ${in}    Get Length    item=${symvar('Inbound_delivery')}
    FOR    ${i}     IN RANGE    0    ${in}
        Double Click On Tree Item    tree_id=wnd[0]/usr/shell/shellcont[0]/shell    id=N000000085
        Sleep    1
        Input Text    element_id=wnd[1]/usr/txtS_DOCNO-LOW    text=${symvar('Inbound_delivery')[${i}]}
        Sleep    1
        Click Element    element_id=wnd[1]/tbar[0]/btn[8]
        Sleep    1
        Click Toolbar Button    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[0]/shell    button_id=N000000109
        Sleep    1
        ${con}    Get Row Count    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell
        ${count}    Evaluate    ${con}-1
        FOR    ${ind}    IN RANGE    0    ${count}
            IF    '${ind}' == '0'
                ${IBD}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[0]/shell    row_num=${ind}    column_id=DOCNO_H
                ${IBDa}    Set Variable    InboundDelivery:${IBD}
                Append To File    path=${filepath}    content=${IBDa}\n
                ${Vehicle}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[0]/shell    row_num=${ind}    column_id=TRANSMEANS_ID
                ${Vehiclea}    Set Variable    VehicleNumber:${Vehicle}
                Append To File    path=${filepath}    content=${Vehiclea}\n
            END
            ${Warehousetask}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${ind}    column_id=TANUM
            ${Warehousetaska}    Set Variable    WarehousetaskNumber:${Warehousetask}
            Append To File    path=${filepath}    content=${Warehousetaska}\n
            ${Sourcebin}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${ind}    column_id=VLPLA
            ${Sourcebina}    Set Variable    Sourcebin:${Sourcebin}
            Append To File    path=${filepath}    content=${Sourcebina}\n
            ${Destbin}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${ind}    column_id=NLPLA
            ${Destbina}    Set Variable    Destbin:${Destbin}
            Append To File    path=${filepath}    content=${Destbina}\n
        END
    END
    ${Binallocation_result}   Binallocation Json    file_path=${filepath}
    Log To Console    message=**gbStart**Binallocation_result_json**splitKeyValue**${Binallocation_result}**splitKeyValue**object**gbEnd**
    Delete Specific File    file_path=${filepath}