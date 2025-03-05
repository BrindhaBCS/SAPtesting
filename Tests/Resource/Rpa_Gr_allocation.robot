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
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Rpa_UserName')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Rpa_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{Rpa_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction     /nex
GR_Allocation
    Run Transaction    /n/scwm/prdi
    ${in}    Get Length    item=${symvar('Inbound_delivery')}
    Select From List By Label    element_id=wnd[0]/usr/subSUB_COMPLETE_OIP:/SCWM/SAPLUI_DLV_PRD:2000/cmb/SCWM/S_UI_DLV-V_CRITERION    value=Inbound Delivery
    FOR    ${i}     IN RANGE    0    ${in}
        Input Text    element_id=wnd[0]/usr/subSUB_COMPLETE_OIP:/SCWM/SAPLUI_DLV_PRD:2000/subSUB_SEARCH_VALUE:/SCWM/SAPLUI_DLV_PRD:2013/txt/SCWM/S_SP_Q_HEAD-DOCNO_ID    text=${symvar('Inbound_delivery')[${i}]}
        Click Element    element_id=wnd[0]/usr/subSUB_COMPLETE_OIP:/SCWM/SAPLUI_DLV_PRD:2000/subSUB_SEARCH_VALUE:/SCWM/SAPLUI_DLV_PRD:2013/btnCMD_GO
        Click Toolbar Button    table_id=wnd[0]/usr/subSUB_COMPLETE_OIP:/SCWM/SAPLUI_DLV_PRD:2000/subSUB_OIP_DATA_AREA:/SCWM/SAPLUI_DLV_PRD:2210/cntlCONTAINER_TB_OIP_1/shellcont/shell    button_id=OIP_POST_GM
        Sleep    3
        Run Keyword And Ignore Error    Click Element    element_id=wnd[1]/tbar[0]/btn[0]
        Click Element    element_id=wnd[0]/usr/subSUB_COMPLETE_ODP1:/SCWM/SAPLUI_DLV_PRD:3000/tabsTABSTRIP_ODP1/tabpOK_ODP1_TAB9
        ${a}    Get Sap Table Value    table_id=wnd[0]/usr/subSUB_COMPLETE_ODP1:/SCWM/SAPLUI_DLV_PRD:3000/tabsTABSTRIP_ODP1/tabpOK_ODP1_TAB9/ssubSUB_ODP1_TAB9:/SCWM/SAPLUI_DLV_CORE:3290/ssubSUB_ODP1_9_CONTENT:/SCWM/SAPLUI_DLV_CORE:3291/cntlCONTAINER_ALV_ODP1_9/shellcont/shell    row_num=7    column_id=STATUS_TYPE_TEXT
        ${b}    Get Sap Table Value    table_id=wnd[0]/usr/subSUB_COMPLETE_ODP1:/SCWM/SAPLUI_DLV_PRD:3000/tabsTABSTRIP_ODP1/tabpOK_ODP1_TAB9/ssubSUB_ODP1_TAB9:/SCWM/SAPLUI_DLV_CORE:3290/ssubSUB_ODP1_9_CONTENT:/SCWM/SAPLUI_DLV_CORE:3291/cntlCONTAINER_ALV_ODP1_9/shellcont/shell    row_num=7    column_id=STATUS_VALUE
        ${c}    Get Sap Table Value    table_id=wnd[0]/usr/subSUB_COMPLETE_ODP1:/SCWM/SAPLUI_DLV_PRD:3000/tabsTABSTRIP_ODP1/tabpOK_ODP1_TAB9/ssubSUB_ODP1_TAB9:/SCWM/SAPLUI_DLV_CORE:3290/ssubSUB_ODP1_9_CONTENT:/SCWM/SAPLUI_DLV_CORE:3291/cntlCONTAINER_ALV_ODP1_9/shellcont/shell    row_num=7    column_id=STATUS_VALUE_TEXT
        IF    '${a}' == 'Goods Receipt'
            IF    '${b}' == '9'
                IF    '${c}' == 'Completed'
                    Log To Console    message=**gbStart**GR_postingstatus**splitKeyValue**GR Postingcompleted**splitKeyValue**object**gbEnd**
                    Continue For Loop
                ELSE
                    Exit For Loop
                END
            ELSE
                Exit For Loop
            END
        ELSE
            Exit For Loop
        END

    END