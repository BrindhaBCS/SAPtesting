*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    DateTime
Library    Collections
Library    Replay_Library.py
Library    OperatingSystem
*** Variables ***
${filepath}    c:\\tmp\\RPA\\putawayreport.txt
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
Report_data_sym
    Delete Specific File    file_path=${filepath}
    Create File    path=${filepath}
    ${Vehicleentrydate}    Set Variable    Vehicle Entry :Date:${symvar('Rpa_vehicle_Entry_Date')} Time:${symvar('Rpa_vehicle_Entry_Time')}
    Append To File    path=${filepath}    content=${Vehicleentrydate}\n

    Run Transaction    /n/scwm/mon
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
        ${Inbounddeliverycreated}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[0]/shell    row_num=${i}    column_id=TDELIVERY_CRE_DATE
        ${Inbounddeliverycreatedtime}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[0]/shell    row_num=${i}    column_id=TDELIVERY_CRE_TIME
        ${Inbounddeliverycreatedtimea}    Set Variable    Inbound Delivery Created :Date:${Inbounddeliverycreated} Time:${Inbounddeliverycreatedtime}
        Append To File    path=${filepath}    content=${Inbounddeliverycreatedtimea}\n
        Click Toolbar Button    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[0]/shell    button_id=N000000109      #warehousetaskbutton
        Sleep    1
        #Goods Receipt Created
        ${GRcreated}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${i}    column_id=GRDATE
        ${GRcreatedtime}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${i}    column_id=GRTIME
        ${GRcreatedtimea}    Set Variable    Goods Receipt Created :Date:${GRcreated} Time:${GRcreatedtime}
        Append To File    path=${filepath}    content=${GRcreatedtimea}\n

        Click Toolbar Button    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[0]/shell    button_id=N000000110      #warehouseorderbutton
        Sleep    1
        #Warehouse Order or Material placed in Storage Location
        ${warehouseorderconfiremed}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${i}    column_id=CONFIRMED_DATE
        ${warehouseorderconfiremedtime}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${i}    column_id=CONFIRMED_TIME
        ${warehouseorderstatus}    Set Variable    Material placed in Storage Location Confirmed :Date:${warehouseorderconfiremed} Time:${warehouseorderconfiremedtime}
        Append To File    path=${filepath}    content=${warehouseorderstatus}\n
        #Inbounddeliverybutton
        Click Toolbar Button    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[0]/shell    button_id=N000000086
        Sleep    1

        ${Ibddocument}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[0]/shell    row_num=${i}    column_id=DOCNO_H
        ${Ibddocumenta}    Set Variable    Inbound Delivery Number :${Ibddocument}
        Append To File    path=${filepath}    content=${Ibddocumenta}\n

        ${Ibdvehicle}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[0]/shell    row_num=${i}    column_id=TRANSMEANS_ID
        ${Ibdvehiclea}    Set Variable    Vehicle Number :${Ibdvehicle}
        Append To File    path=${filepath}    content=${Ibdvehiclea}\n

        ${Ibdponumber}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${i}    column_id=PO_NUMBER
        ${Ibdponumbera}    Set Variable    Purchase Order :${Ibdponumber}
        Append To File    path=${filepath}    content=${Ibdponumbera}\n

        ${Ibddeviverydate}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[0]/shell    row_num=${i}    column_id=DLV_DATE
        ${Ibddeviverydatea}    Set Variable    Delivery Date :${Ibddeviverydate}
        Append To File    path=${filepath}    content=${Ibddeviverydatea}\n

        ${con}    Get Row Count    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell
        ${count}    Evaluate    ${con}-1
        FOR    ${ind}    IN RANGE    0    ${count}
            ${Ibdpoproduct}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${ind}    column_id=PRODUCTNO
            ${Ibdpoproducta}    Set Variable    Material Number :${Ibdpoproduct}
            Append To File    path=${filepath}    content=${Ibdpoproducta}\n

            ${Ibdpoquanitity}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${ind}      column_id=QTY_UI
            ${Ibdpoquanititya}    Set Variable    Quanitity :${Ibdpoquanitity}
            Append To File    path=${filepath}    content=${Ibdpoquanititya}\n

            ${Ibdpounit}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${ind}      column_id=UOM
            ${Ibdpounita}    Set Variable    Unit :${Ibdpounit}
            Append To File    path=${filepath}    content=${Ibdpounita}\n

            ${Ibdpoproductdescription}    Get Sap Table Value    table_id=wnd[0]/usr/shell/shellcont[1]/shell/shellcont[1]/shell    row_num=${ind}    column_id=MAKTX
            ${Ibdpoproductdescriptiona}    Set Variable    Material Description :${Ibdpoproductdescription}
            Append To File    path=${filepath}    content=${Ibdpoproductdescriptiona}\n
        END
    END
    #vendorname&number&email
    Run Transaction    transaction=/nME23N
    Sleep    1
    Click Element    element_id=wnd[0]/tbar[1]/btn[17]
    Sleep    1
    Input Text    element_id=wnd[1]/usr/subSUB0:SAPLMEGUI:0003/ctxtMEPO_SELECT-EBELN    text=${Ibdponumber}
    Sleep    1
    Send Vkey    vkey_id=0
    Sleep    5
    ${vendornumber&name}    Get Value    element_id=wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB0:SAPLMEGUI:0030/subSUB1:SAPLMEGUI:1105/ctxtMEPO_TOPLINE-SUPERFIELD
    ${vendordata}    Split Numeric Alphabetic    text=${vendornumber&name}

    ${vendornumber}    Set Variable    Vendor Number :${vendordata}[0]
    ${vendorname}    Set Variable    Vendor Name :${vendordata}[1]
    Append To File    path=${filepath}    content=${vendornumber}\n${vendorname}

    Set Focus    element_id=wnd[0]/usr/subSUB0:SAPLMEGUI:0019/subSUB0:SAPLMEGUI:0030/subSUB1:SAPLMEGUI:1105/ctxtMEPO_TOPLINE-SUPERFIELD
    Send Vkey    vkey_id=2
    Sleep    4
    Scroll Pagedown    window_id=wnd[0]/usr/subSCREEN_3000_RESIZING_AREA:SAPLBUS_LOCATOR:2036/subSCREEN_1010_RIGHT_AREA:SAPLBUPA_DIALOG_JOEL:1000/ssubSCREEN_1000_WORKAREA_AREA:SAPLBUPA_DIALOG_JOEL:1100/ssubSCREEN_1100_MAIN_AREA:SAPLBUPA_DIALOG_JOEL:1101/tabsGS_SCREEN_1100_TABSTRIP/tabpSCREEN_1100_TAB_01/ssubSCREEN_1100_TABSTRIP_AREA:SAPLBUSS:0028/ssubGENSUB:SAPLBUSS:7016/subA06P01:SAPLBUA0:0700/subADDR_ICOMM:SAPLSZA11:0100/btnG_PUSH_FOR_MCOM
    Sleep    1
    ${email}    Get Value    element_id=wnd[0]/usr/subSCREEN_3000_RESIZING_AREA:SAPLBUS_LOCATOR:2036/subSCREEN_1010_RIGHT_AREA:SAPLBUPA_DIALOG_JOEL:1000/ssubSCREEN_1000_WORKAREA_AREA:SAPLBUPA_DIALOG_JOEL:1100/ssubSCREEN_1100_MAIN_AREA:SAPLBUPA_DIALOG_JOEL:1101/tabsGS_SCREEN_1100_TABSTRIP/tabpSCREEN_1100_TAB_01/ssubSCREEN_1100_TABSTRIP_AREA:SAPLBUSS:0028/ssubGENSUB:SAPLBUSS:7016/subA06P01:SAPLBUA0:0700/subADDR_ICOMM:SAPLSZA11:0100/txtSZA11_0100-SMTP_ADDR
    Log To Console    message=**gbStart**vendoremail**splitKeyValue**${email}**gbEnd**
    Delete Specific File    file_path=c:\\tmp\\RPA\\Putawaytimelinetrackerreport.html
    Sleep    1
    Rpa Report    file_path=${filepath}    output_file=c:\\tmp\\RPA\\Putawaytimelinetrackerreport.html
    Sleep    2