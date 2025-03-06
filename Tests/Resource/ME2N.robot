*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    multiple_selection.py

*** Variable ***
${table_id} = wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/cntlCONTAINER2_LAYO/shellcont/shell
${button_id} = wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/btnAPP_FL_SING

*** Keywords ***
System Logon
    Start Process    ${symvar('GR_IR_SERVER')}
    Connect To Session
    Open Connection     ${symvar('GR_IR_Connection')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('GR_IR_Client')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('GR_IR_User')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('GR_IR_PASSWORD')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{GR_IR_PASSWORD}
    Send Vkey    0   
    ${logon_status}    Multiple logon Handling     wnd[1]   wnd[1]/usr/radMULTI_LOGON_OPT2
    IF    '${logon_status}' == "Multiple logon found. Please terminate all the logon & proceed"
        Log To Console    **gbStart**logon_status**splitKeyValue**${logon_status}**gbEnd**

    END

System Logout
    Run Transaction   /nex
    Sleep    5

ME2N
    Run Transaction     /nME2N
    Sleep   2
    Input Text   wnd[0]/usr/ctxtLISTU   ${symvar('scope_of_list')}
    Sleep   2
    Click Element   wnd[0]/usr/btn%_EN_EBELN_%_APP_%-VALU_PUSH
    Sleep   2
    ### Delete Specific files
    Delete Specific File    ${symvar('download_path')}\\${symvar('me2n_file')}
    Delete Specific File    ${symvar('download_path')}\\Purchase_DocumentOnly.txt

    ### Copy To Clipboard
    Get Column Excel To Text Create    C:\\tmp\\GR.XLSX   C:\\tmp\\Purchase_DocumentOnly.txt     Purchasing Document     Sheet1
    Click Element   wnd[1]/tbar[0]/btn[23]
    Input Text    wnd[2]/usr/ctxtDY_PATH    C:\\tmp\\
    Input Text    wnd[2]/usr/ctxtDY_FILENAME    Purchase_DocumentOnly.txt
    Click Element    wnd[2]/tbar[0]/btn[0]
    Click Element    wnd[1]/tbar[0]/btn[8]
    Sleep   2

    ### execute to get table
    Click Element   wnd[0]/tbar[1]/btn[8]

    ### Layout changes
    Click Element   wnd[0]/tbar[1]/btn[32]
    ${row}      Get Row Count   wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/cntlCONTAINER2_LAYO/shellcont/shell
    ${rows}     Evaluate    ${row} + 1
    ${count}    Get Length    ${symvar('GR1_Layout')}
    FOR    ${lp}    IN RANGE    0    ${rows}
        Log     ${lp}
        Click Element   wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/btnAPP_FL_SING
        ${row}      Get Row Count   wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/cntlCONTAINER2_LAYO/shellcont/shell
        IF    '${row}' == '0'
            Exit For Loop
        END
        ${rows}      Set Variable    ${row} + 1
    END
    Sleep   5
    Gr Ir Window Handling    ${table_id}    ${button_id}
    Sleep   5
    FOR    ${i}    IN RANGE    0    ${count}
        ${value}    Set Variable    ${symvar('GR1_Layout')}[${i}]
        Log To Console      ${value}
        ${row1}      Get Row Count   wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/cntlCONTAINER1_LAYO/shellcont/shell
        Log To Console      ${row1}
        FOR    ${loop}    IN RANGE    0    ${row1}
            ${layout}    Get Sap Table Value    table_id=wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/cntlCONTAINER1_LAYO/shellcont/shell    row_num=${loop}    column_id=SELTEXT
            # Log To Console      ${layout}
            IF    '${value}' == '${layout}'
                Click Element   wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/btnAPP_WL_SING
            END
        END  
    END
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   5

    ### File download
    Click Element   wnd[0]/mbar/menu[0]/menu[3]/menu[1]
    Sleep   2
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   2

    Input Text      wnd[1]/usr/ctxtDY_FILENAME      ${EMPTY}
    Sleep   5
    Input Text      wnd[1]/usr/ctxtDY_FILENAME      ${symvar('me2n_file')}
    Sleep   5
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${EMPTY}
    Sleep   5
    Input Text      wnd[1]/usr/ctxtDY_PATH      ${symvar('download_path')}
    Sleep   5
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   2
