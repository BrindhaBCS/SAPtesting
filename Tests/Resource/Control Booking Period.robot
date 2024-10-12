*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py

*** Variables ***
${tree_id}      wnd[0]/usr/cntlTREE_CONTROL_CONTAINER/shellcont/shell
${link_id1}     02${SPACE*2}1${SPACE*6}2
${link_id2}     01${SPACE*2}1${SPACE*6}1
${link_id3}    03${SPACE*2}2${SPACE*6}7
${link_id4}    04${SPACE*2}2${SPACE*6}8
${AUTHORIZATION TAB}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
${AUTHORIZATION OBJECT 1}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1
${AUTHORIZATION OBJECT 2}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2
${link_id5}    1
${Authorization Object 1 VALUE}    S_TCODE
${value_02}    02
${BACK}    wnd[0]/tbar[0]/btn[3]
${local file}    wnd[0]/tbar[1]/btn[45]
${Text with tabs Button}    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
${local file continue}    wnd[1]/tbar[0]/btn[0]
${Execute}    wnd[0]/tbar[1]/btn[8]
${Replace}    /app/con[0]/ses[0]/wnd[1]/tbar[0]/btn[11]
${Req_Result22_Filename}    Control Booking.xls
${Req_Result22.1_Filename}    Control Booking1.xls


*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    5
    Connect To Session
    Open Connection    ${symvar('MCR_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MCR_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MCR_User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MCR_User_Password')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{MCR_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction   /nex
    Sleep    2

Control Booking Period 
    Maximize Window
    Run Transaction     SUIM
    Sleep    2
    Click Node Link     ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
    Sleep    2
    Take Screenshot    Control_Booking_Period_0.jpg
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    ${Authorization Object 1 VALUE}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    F60
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 2}    S_TABU_DIS
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL201    FC31
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211    ${value_02}
    Sleep    2
    Take Screenshot    Control_Booking_Period_1.jpg
    Sleep    2
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_Booking_Period_2.jpg
    Sleep    2
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result22_Filename}
    Sleep    1
    Click Element    ${Replace}
    Sleep    1
    Click Element    ${BACK}
    Sleep    1
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    ${Authorization Object 1 VALUE}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    F60
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 2}    S_TABU_NAM
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL201    ${value_02}
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211    V_T001B  
    Sleep    2
    Take Screenshot    Control_Booking_Period_3.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_Booking_Period_4.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('MCR_Results_Directory_Path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result22.1_Filename}
    Sleep    1
    Click Element    ${Replace}
    Sleep    1
    Log To Console    Control Booking Period  completed
    Click Element    ${BACK}
    Sleep    1