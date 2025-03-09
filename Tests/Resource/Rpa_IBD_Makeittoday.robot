*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    DateTime
Library    Collections
Library    Replay_Library.py
Library    OperatingSystem
*** Variables ***

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
Reschedule_date
    Run Transaction    transaction=/nVL60
    Sleep    1
    Select Inboud Delivery
    Click Element    element_id=wnd[0]/tbar[1]/btn[9]
    Sleep    1
    Click Element    element_id=wnd[1]/usr/tabsTABSTRIP_TABSTR1/tabpBORGR_DY8000_BUT2
    Sleep    1
    Input Text    element_id=wnd[1]/usr/tabsTABSTRIP_TABSTR1/tabpBORGR_DY8000_BUT2/ssub%_SUBSCREEN_TABSTR1:/SPE/INB_GR:8021/ctxtSD_VBELN-LOW    text=${symvar('current_month_IBD')}
    Click Element    element_id=wnd[1]/tbar[0]/btn[8]
    Sleep    1
    Select Context Menu Item    element_id=wnd[0]/shellcont/shell/shellcont[2]/shell    menu_or_button_id=$CT$D    item_id=BORGR_CTM_DISP
    Sleep    1
    Click Toolbar Button    table_id=wnd[0]/usr/subDY0100_SUB_WORKAREA_NEW:/SPE/INB_GR:0101/cntlDY0100_CTRL_TOOLBAR/shellcont/shell    button_id=BORGR_TTB_TDC
    Sleep    1
    ${IBDdelivery}    Get Value    element_id=wnd[0]/usr/subDY0100_SUB_WORKAREA_NEW:/SPE/INB_GR:0101/subDY0100_SUB_WORKAREA:/SPE/INB_GR:1100/subDY1100_SUB:/SPE/INB_GR:2005/subSUB_MAIN1:/SPE/INB_GR:2051/tabsDY2000_TABSTR0/tabpDY2000_TAB01/ssubDY2000_TABSTR0_SUB1:/SPE/INB_GR:1180/ctxtBORGR_LIKP-VBELN
    IF    '${IBDdelivery}' == '${symvar('current_month_IBD')}'
        Scroll Pagedown    window_id=wnd[0]/usr/subDY0100_SUB_WORKAREA_NEW:/SPE/INB_GR:0101/subDY0100_SUB_WORKAREA:/SPE/INB_GR:1100/subDY1100_SUB:/SPE/INB_GR:2005/subSUB_MAIN1:/SPE/INB_GR:2051/tabsDY2000_TABSTR0/tabpDY2000_TAB01/ssubDY2000_TABSTR0_SUB1:/SPE/INB_GR:1180/ctxtBORGR_LIKP-DIMP_LGBZO
        Sleep    1
        ${Get Current Date}    Get Current Date    result_format=%d.%m.%Y
        Input Text    element_id=wnd[0]/usr/subDY0100_SUB_WORKAREA_NEW:/SPE/INB_GR:0101/subDY0100_SUB_WORKAREA:/SPE/INB_GR:1100/subDY1100_SUB:/SPE/INB_GR:2005/subSUB_MAIN1:/SPE/INB_GR:2051/tabsDY2000_TABSTR0/tabpDY2000_TAB01/ssubDY2000_TABSTR0_SUB1:/SPE/INB_GR:1180/ctxtBORGR_LIKP-LFDAT    text=${Get Current Date}
        Sleep    1
        Click Element    element_id=wnd[0]/tbar[0]/btn[11]        #save
        Sleep    1
        Click Element    element_id=wnd[1]/tbar[0]/btn[0]
        Sleep    2
    END