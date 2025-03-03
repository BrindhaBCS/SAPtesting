*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    Merger.py

*** Keywords ***
System Logon
    Start Process    ${symvar('GR_IR_SERVER')}
    Connect To Session
    Open Connection     ${symvar('GR_IR_Connection')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('GR_IR_Client')}
    Sleep    1
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('GR_IR_User')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('GR_IR_PASSWORD')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{GR_IR_PASSWORD}
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

    ### Copy To Clipboard
    Click Element   wnd[1]/tbar[0]/btn[24]
    Sleep   2
    ###

    Click Element   wnd[1]/tbar[0]/btn[8]
    Sleep   2
    Click Element   wnd[0]/tbar[1]/btn[8]

    ### Layout changes
    Click Element   wnd[0]/tbar[1]/btn[32]
    ${row}      Get Row Count   wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/cntlCONTAINER2_LAYO/shellcont/shell
    Log To Console      ${row}
    ${count}    Get Length    ${symvar('GR1_Layout')}
    FOR    ${i}    IN RANGE    0    ${count}
        ${value}    Set Variable    ${symvar('GR1_Layout')}[${i}]
        FOR    ${lp}    IN RANGE    0    ${row}
            ${layout}    Get Sap Table Value    table_id=wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_CUL_LAYOUT_CHOOSE:0500/cntlD500_CONTAINER/shellcont/shell    row_num=${lp}    column_id=TEXT
            IF    '${value}' != '${layout}'
                Click Element   wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/btnAPP_FL_SING
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
    Input Text      wnd[1]/usr/ctxtDY_FILENAME      ${symvar('me2n_file')}
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${EMPTY}
    Input Text      wnd[1]/usr/ctxtDY_PATH      ${symvar('download_path')}
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   2