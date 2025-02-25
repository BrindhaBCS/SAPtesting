*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    DateTime
Library    Collections
Library    Replay_Library.py
Library    OperatingSystem
*** Variables ***
${file}    c:\\tmp\\RPA\\ASN_material_quantity_Inbound_delivery.txt
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
Material_code_quantity_from_ASN
    Run Transaction    /nVL33N
    Delete Specific File    file_path=${file}
    ${in}    Get Length    item=${symvar('Inbound_delivery')}
    Create File    path=${file}
    FOR    ${i}     IN RANGE    0    ${in}
        ${value}    Set Variable    InboundDelivery:${symvar('Inbound_delivery')[${i}]}
        Append To File    path=${file}    content=${value}\n
        Input Text    element_id=wnd[0]/usr/ctxtLIKP-VBELN    text=${symvar('Inbound_delivery')[${i}]}
        Send Vkey    vkey_id=0
        Sleep    1
        ${index}    Set Variable    0
        WHILE    True
            ${Status}    Get Value    element_id=wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV50A:1202/tblSAPMV50ATC_LIPS_OVER_INB/txtLIPS-POSNR[0,${index}]
            IF    '${Status}' != '______'
                ${Item}    Get Value    element_id=wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV50A:1202/tblSAPMV50ATC_LIPS_OVER_INB/txtLIPS-POSNR[0,${index}]
                ${Itema}    Set Variable    Item:${Item}
                Append To File    path=${file}    content=${Itema}\n
                ${Material}    Get Value    element_id=wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV50A:1202/tblSAPMV50ATC_LIPS_OVER_INB/ctxtLIPS-MATNR[1,${index}]
                ${Materiala}    Set Variable    Material:${Material}
                Append To File    path=${file}    content=${Materiala}\n
                ${DeliveryQuantity}    Get Value    element_id=wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV50A:1202/tblSAPMV50ATC_LIPS_OVER_INB/txtLIPSD-G_LFIMG[2,${index}]
                ${DeliveryQuantitya}    Set Variable    DeliveryQuantity:${DeliveryQuantity}
                Append To File    path=${file}    content=${DeliveryQuantitya}\n
                ${SU}    Get Value    element_id=wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV50A:1202/tblSAPMV50ATC_LIPS_OVER_INB/ctxtLIPS-VRKME[3,${index}]
                ${SUa}    Set Variable    SU:${SU}
                Append To File    path=${file}    content=${SUa}\n
                ${index}    Evaluate    ${index} + 1
            ELSE IF    '${Status}' == '______'
                Exit For Loop
            END
        END
        Click Element    element_id=wnd[0]/tbar[0]/btn[3]
    END
    ${IBDjson}    Inbounddelivery Json    file_path=${file}
    Log To Console    message=**gbStart**InbounddeliveryJson**splitKeyValue**${IBDjson}**splitKeyValue**object**gbEnd**
    Log To Console    message=**gbStart**asn_materialstatus**splitKeyValue**Asn materialquantity completed**splitKeyValue**object**gbEnd**
    # Delete Specific File    file_path=${file}