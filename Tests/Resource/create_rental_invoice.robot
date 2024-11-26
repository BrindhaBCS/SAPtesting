*** Settings ***
Library    Process
Library    OperatingSystem
Library    String
Library    SAP_Tcode_Library.py
Library     DateTime
*** Variables ***
${rental_date}  01.10.2025
${Text}     Rent for the month of November 2024.
${rental_text}  wnd[0]/usr/tabsTABSTRIP_OVERVIEW/tabpKFTE/ssubSUBSCREEN_BODY:SAPLV70T:2100/cntlSPLITTER_CONTAINER/shellcont/shellcont/shell/shellcont[1]/shell
${rental_form}  wnd[0]/usr/tabsTABSTRIP_OVERVIEW/tabpKFTE/ssubSUBSCREEN_BODY:SAPLV70T:2100/cntlSPLITTER_CONTAINER/shellcont/shellcont/shell/shellcont[0]/shell
*** Keywords *** 
System Logon
    Start Process    ${symvar('SAP_SERVER')}
    Connect To Session
    Open Connection     ${symvar('Rental_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Rental_Client')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Rental_User')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('RENTAL_PASSWORD')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{RENTAL_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
System Logout
    Run Transaction   /nex
Rental Invoice
    FOR     ${contract}     IN     @{symvar('documents')}
        Set Global Variable     ${contract}
        Run Transaction     /nVA42
        Input Text  wnd[0]/usr/ctxtVBAK-VBELN   ${contract}
        # Input Text  wnd[0]/usr/ctxtVBAK-VBELN   40000029
        Send Vkey    0
        Sleep   2
        Click Element   wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/btnBT_HEAD
        Sleep   5
        Click Element   wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\05
        Sleep   2
        ${row}  Get Row Count   wnd[0]/usr/tabsTAXI_TABSTRIP/tabpT\\05/ssubSUBSCREEN_BODY:SAPLV60F:4201/tblSAPLV60FTCTRL_FPLAN_PERIOD
        Log To Console      ${row}
        FOR     ${i}    IN RANGE    0   ${row}
            ${is_visible}   Run Keyword And Return Status   Get Value   wnd[0]/usr/tabsTAXI_TABSTRIP/tabpT\\05/ssubSUBSCREEN_BODY:SAPLV60F:4201/tblSAPLV60FTCTRL_FPLAN_PERIOD/ctxtRV60F-ABRBE[0,${i}]
            Run Keyword If    "${is_visible}" == "False"    Exit For Loop
            ${date}     Get Value   wnd[0]/usr/tabsTAXI_TABSTRIP/tabpT\\05/ssubSUBSCREEN_BODY:SAPLV60F:4201/tblSAPLV60FTCTRL_FPLAN_PERIOD/ctxtRV60F-ABRBE[0,${i}]
            # Run Keyword If  '${date}' == '${rental_date}'   Process rental invoice
            IF  '${date}' == '${rental_date}'
                Process rental invoice
                Exit For Loop
            END
        END
    END

Process rental invoice
    Send Vkey    2
    Input Text   wnd[0]/usr/ctxtFPLT-FAKSP  ${EMPTY }
    Click Element   wnd[0]/tbar[0]/btn[3]
    Click Element   wnd[0]/tbar[0]/btn[3]
    Click Element   wnd[0]/tbar[0]/btn[11]
    Sleep   5

    Run Transaction     /nVF01
    Sleep   5
    Input Text  wnd[0]/usr/tblSAPMV60ATCTRL_ERF_FAKT/ctxtKOMFK-VBELN[0,0]   ${contract}
    ${current_date}     Get Current Date    result_format=%d.%m.%Y
    Input Text  wnd[0]/usr/ctxtRV60A-FKDAT  ${current_date}
    Send Vkey   0
    ${status}   Get Value   wnd[0]/sbar/pane[0]
    IF  '${status}' == 'No billing documents were generated. Please see log.'
        Log To Console  For ${contract} ${status}
    ELSE IF     '${status}' == '${EMPTY}'
        Sleep   10
        Click Element   wnd[0]/usr/btnTC_HEAD
        Click Element   wnd[0]/usr/tabsTABSTRIP_OVERVIEW/tabpKFTE
        Doubleclick Element     ${rental_form}  0001    Column1
        Input Text  ${rental_text}  ${Text}
        Sleep   5
        Click Element   wnd[0]/usr/tabsTABSTRIP_OVERVIEW/tabpKFCU
        Input Text      wnd[0]/usr/tabsTABSTRIP_OVERVIEW/tabpKFCU/ssubSUBSCREEN_BODY:SAPMV60A:6101/ssubCUSTOMER_SCREEN:ZZBILLHEADER:0100/txtVBRK-ZEINVOICE  NA
        Sleep   2
        Click Element   wnd[0]/tbar[0]/btn[11]
        Sleep   5
    END
    


