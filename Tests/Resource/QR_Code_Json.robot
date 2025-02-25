*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    DateTime
Library    Collections
Library    Replay_Library.py
Library    OperatingSystem
Library    qr.py
*** Variables ***
${file}    c:\\tmp\\RPA\\QRcode.txt

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
Qr_code
    Delete Specific File    file_path=${file}
    ${in}    Get Length    item=${symvar('Inbound_delivery')}
    Create File    path=${file}
    FOR    ${i}     IN RANGE    0    ${in}
        Run Transaction    /nVL33N
        ${value}    Set Variable    InboundDelivery:${symvar('Inbound_delivery')[${i}]}
        Append To File    path=${file}    content=${value}\n
        Input Text    element_id=wnd[0]/usr/ctxtLIKP-VBELN    text=${symvar('Inbound_delivery')[${i}]}
        Send Vkey    vkey_id=0
        Sleep    1
        ${index}    Set Variable    0
        WHILE    True
            ${Status}    Get Value    element_id=wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV50A:1202/tblSAPMV50ATC_LIPS_OVER_INB/txtLIPS-POSNR[0,${index}]
            IF    '${Status}' != '______'
                ${Material}    Get Value    element_id=wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV50A:1202/tblSAPMV50ATC_LIPS_OVER_INB/ctxtLIPS-MATNR[1,${index}]
                ${Materiala}    Set Variable    Material:${Material}
                Append To File    path=${file}    content=${Materiala}\n
                ${DeliveryQuantity}    Get Value    element_id=wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV50A:1202/tblSAPMV50ATC_LIPS_OVER_INB/txtLIPSD-G_LFIMG[2,${index}]
                ${DeliveryQuantitya}    Set Variable    DeliveryQuantity:${DeliveryQuantity}
                Append To File    path=${file}    content=${DeliveryQuantitya}\n
                ${index}    Evaluate    ${index} + 1
            ELSE IF    '${Status}' == '______'
                Exit For Loop
            END
        END
        Click Element    element_id=wnd[0]/tbar[0]/btn[3]
        Run Transaction    /n/scwm/mon
        Run Keyword And Ignore Error    Input Text    element_id=wnd[1]/usr/ctxtP_LGNUM    text=BC01
        Run Keyword And Ignore Error    Input Text    element_id=wnd[1]/usr/ctxtP_MONIT    text=SAP
        Run Keyword And Ignore Error    Click Element    element_id=wnd[1]/tbar[0]/btn[8]
        Click Element    element_id=wnd[0]/tbar[1]/btn[18]
        Expand Element    tree_id=wnd[0]/usr/shell/shellcont[0]/shell    node_id=C000000002
        Expand Element    tree_id=wnd[0]/usr/shell/shellcont[0]/shell    node_id=C000000005
        Expand Element    tree_id=wnd[0]/usr/shell/shellcont[0]/shell    node_id=N000000085
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
            ${Warehousetask}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${ind}    column_id=TANUM
            ${Warehousetaska}    Set Variable    WarehousetaskNumber:${Warehousetask}
            Append To File    path=${file}    content=${Warehousetaska}\n
            ${Sourcebin}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${ind}    column_id=VLPLA
            ${Sourcebina}    Set Variable    Sourcebin:${Sourcebin}
            Append To File    path=${file}    content=${Sourcebina}\n
            ${Destbin}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${ind}    column_id=NLPLA
            ${Destbina}    Set Variable    Destbin:${Destbin}
            Append To File    path=${file}    content=${Destbina}\n
        END
    END
    Sleep    2
    ${json_qr}    Parse Txt To Json        file_path=${file}
    Sleep    1
    Log To Console    message=**gbStart**QR_CODE_JSON**splitKeyValue**${json_qr}**splitKeyValue**object**gbEnd**
    Delete Specific File    file_path=${file}