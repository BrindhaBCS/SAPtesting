*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process

*** Variables ***
${tree_id}      wnd[0]/usr/cntlTREE_CONTROL_CONTAINER/shellcont/shell
${link_id6}    02${SPACE*2}1${SPACE*5}10
${link_id7}    01${SPACE*2}1${SPACE*6}1
${link_id8}    03${SPACE*2}2${SPACE*6}1
${link_id9}    04${SPACE*2}2${SPACE*6}2
${link_id10}    1
# ${tree_id}      wnd[0]/usr/cntlTREE_CONTROL_CONTAINER/shellcont/shell
${link_id1}     02${SPACE*2}1${SPACE*6}2
${link_id2}     01${SPACE*2}1${SPACE*6}1
${link_id3}    03${SPACE*2}2${SPACE*6}7
${link_id4}    04${SPACE*2}2${SPACE*6}8
${link_id5}    1
 

*** Keywords ***
SAP Logonn
    Start Process    ${symvar('sap_server')}
    Sleep    2
    Connect To Session
    Sleep    2
    Open Connection    ${symvar('server')}
    Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('user_name')}
    Sleep    2
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{password}
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[0]
    Sleep    2
    Multiple logon Handling     wnd[1]    wnd[1]/usr/radMULTI_LOGON_OPT2    wnd[1]/tbar[0]/btn[0]
    Sleep   1

USMM
    Run Transaction    /nusmm
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Send Vkey    0
    Sleep    10
    Click Element    wnd[0]/tbar[1]/btn[7]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    
Emergency User Edition
    Maximize Window
    Run Transaction     /nSUIM
    Sleep    2
    Click Node Link 1   ${tree_id}    ${link_id6}    ${link_id7}    ${link_id8}     ${link_id9}    ${link_id10}
    Sleep    5
    Input Text    wnd[0]/usr/ctxtUSER-LOW    *SAP*
    Sleep    1
    Input Text    wnd[0]/usr/ctxtFDATE    16.07.2024
    Sleep    1
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkPASS
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1

DELETE_AUDIT_FILES
    Maximize Window
    Run Transaction    /NSE38
    Sleep    1
    Input Text    wnd[0]/usr/ctxtRS38M-PROGRAMM    RSPARAM
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Select Checkbox    wnd[0]/usr/chkALSOUSUB
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Table Scroll    wnd[0]/usr/cntlGRID1/shellcont/shell    3
    Sleep    1
    # Send Vkey    92
    Run Transaction    /nsuim
    Sleep    1
    # Maximize Window
    Run Transaction     SUIM
    Sleep    2
    Click Node Link     ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
    Sleep    2
    Click Element    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1    S_ADMI_FCD
    Send Vkey    0
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    AUDA
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2    S_DATASET
    Send Vkey    0
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211    06
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL221    E:\usr\sap\DEV\D00\log
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    10
SUIM
    Run Transaction    /NSUIM
    Sleep    1
    Click Node Link 1    ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
    Sleep    1
    Click Element    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1    S_TABU_DIS
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    *
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL111    02
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2    S_TCODE
    Sleep    1
    Set Caret Position    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2    7
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL201    SE16*
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL203    SE17*
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ3    S_TCODE
    Sleep    1
    Set Caret Position    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ3    7
    Send Vkey    0
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL301    SM30
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL303    SM31
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ4    S_TABU_NAM
    Sleep    1
    Set Caret Position    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ4    10
    Send Vkey    0
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL401    SE16*
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL403    SE17*
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL411    SM30
    Sleep    1
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL413    SM31
    Sleep    1
    Scroll    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004    position=150
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1

LOGOUT
    Run Transaction    /nex
    
    