*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py


*** Variables ***
${tree_id}      wnd[0]/usr/cntlTREE_CONTROL_CONTAINER/shellcont/shell
${link_id1}     02${SPACE*2}1${SPACE*6}2
${link_id2}     01${SPACE*2}1${SPACE*6}1
${link_id3}    03${SPACE*2}2${SPACE*6}7
${link_id4}    04${SPACE*2}2${SPACE*6}8
${link_id5}    1
${link_id6}    02${SPACE*2}1${SPACE*5}10
${link_id7}    01${SPACE*2}1${SPACE*6}1
${link_id8}    03${SPACE*2}2${SPACE*6}1
${link_id9}    04${SPACE*2}2${SPACE*6}2
${link_id10}    1
# ${link_id11}    02${SPACE*2}1${SPACE*6}2
# ${link_id12}    01${SPACE*2}1${SPACE*6}1
${link_id13}    03${SPACE*2}2${SPACE*5}16
${link_id14}    1
${Authorization Object 1 VALUE}    S_TCODE
${value_01}    01
${value_02}    02
${VALUE_05}    05
${Execute}    wnd[0]/tbar[1]/btn[8]
${TCD VALUE}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101
${AUTHORIZATION TAB}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4
${AUTHORIZATION OBJECT 1}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ1
${AUTHORIZATION OBJECT 2}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ2
${AUTHORIZATION OBJECT 3}    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/ctxtOBJ3
${BACK}    wnd[0]/tbar[0]/btn[3]
${local file}    wnd[0]/tbar[1]/btn[45]
${Text with tabs Button}    wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]
${local file continue}    wnd[1]/tbar[0]/btn[0]
${Object 3}    \#*
${Results_Directory_Path}    C:\\Users\\BCS268\\Documents\\Results
# ${file_path}    ${CURDIR}\\${symvar('filename')}
${Req_Result11_Filename}      SAP_QUERY.xls
${Req_Result12_Filename}    SAP_PROGRAMS.xls
${Req_Result13_Filename}    Authorization Profiles.xls
${Req_Result14_Filename}    Maintenance Workflow.xls
${Req_Result15_Filename}    Access password.xls
${Req_Result16_Filename}    User Control.xls
${Req_Result17_Filename}     Control Access.xls
${Req_Result17.1_Filename}    Control Access1.xls
${TARGET_TABLE_ID}       wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE
${Req_Result19_Filename}    Release Debug.xls
${Req_Result20_Filename}    Control SAP.xls
${Req_Result21_Filename}    Mandantonderhoud.xls
${Req_Result22_Filename}    Control Booking.xls
${Req_Result22.1_Filename}    Control Booking1.xls
${Req_Result_Filename}    Deleteaudit.xls
${directory}    C://SAP_Robot//SAPtesting//Output//pabot_results//0
${excel_directory}    C://SAP_Robot//SAPtesting//Execution//MCR_REPORT.xlsx
${images_directory}    C://SAP_Robot//SAPtesting//Output//pabot_results//0//



*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    5
    Connect To Session
    Open Connection    ${symvar('MCR_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MCR_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MCR_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MCR_User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{MCR_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    

System Logout
    Run Transaction   /nex
    Sleep    2
    

Autorisaties SAP Query
    Maximize Window
    Run Transaction     SUIM
    Sleep    2
    Click Node Link     ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
    Sleep    2
    Take Screenshot    SAPQUERY1_output.jpg
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    ${Authorization Object 1 VALUE}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    ${TCD VALUE}    SQ03    
    Sleep    2
    Take Screenshot    SAPQUERY2_output.jpg
    Click Element    ${Execute}
    Sleep    2
    Take Screenshot    SAPQUERY3_output.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result11_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 11 completed
    Click Element    ${BACK}
    Sleep    1
Check to start Programs immediately
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    ${Authorization Object 1 VALUE}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    ${TCD VALUE}    S*38
    Sleep    2  
    Input Text    ${AUTHORIZATION OBJECT 3}    S_PROGRAM
    Sleep    2
    Send Vkey    0
    Sleep    2
    Scroll    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004    position=150
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL301    ${Object 3}
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL311    SUBMIT
    Sleep    2
    Take Screenshot    start_Programs1.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    start_Programs2.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result12_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 12 completed
    Click Element    ${BACK}
    Sleep    1
Authorization profiles maintenance
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    S_USER_AGR
    Sleep    2
    Send Vkey    0
    Sleep    2
    Clear Field Text    ${TCD VALUE} 
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL111    ${value_01}
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL112    ${value_02}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 2}    S_USER_PRO
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211    ${value_01}
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL212    ${value_02}
    Sleep    2
    Clear Field Text    ${AUTHORIZATION OBJECT 3}
    Sleep    2
    Clear Field Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL301
    Sleep    2
    Clear Field Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL311
    Sleep    2
    Take Screenshot    profiles_maintenance1.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    profiles_maintenance2.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result13_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 13 completed
    Click Element    ${BACK}
    Sleep    1

Access to Maintained Workflow
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    ${Authorization Object 1 VALUE}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    ${TCD VALUE}    SWDC    
    Sleep    2
    Clear Field Text    ${AUTHORIZATION OBJECT 2}
    Clear Field Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211
    Clear Field Text    nd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL212
    Sleep    2
    Take Screenshot    Maintained_Workflow1.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Maintained_Workflow2.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result14_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 14 completed
    Click Element    ${BACK}
    Sleep    1

Access Password Manager
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    ${Authorization Object 1 VALUE}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    ${TCD VALUE}    SU01
    Sleep    2
    Input Text    ${TCD VALUE}    SU10
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 2}    S_USER_GRP
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211    ${VALUE_05}
    Sleep    2
    Take Screenshot    Password_Manager1.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Password_Manager2.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result15_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 15 completed
    Click Element    ${BACK}
    Sleep    1

Usercontrol gebruikers met User Maintenance
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 2}    S_USER_GRP
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211    ${value_02}
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL213    ${VALUE_05}
    Sleep    2
    Take Screenshot    User_Maintenance1.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    User_Maintenance2.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result16_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 16 completed
    Click Element    ${BACK}
    Sleep    1
    
Control access to customizing
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    ${Authorization Object 1 VALUE}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    ${TCD VALUE}   SPRO
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 2}    S_TABU_DIS
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL201    ${Object 3}
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211    ${value_02}
    Sleep    2
    Take Screenshot    Control_access1.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_access2.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result17_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Click Element    ${BACK}
    Sleep    1
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Clear Field Text    ${AUTHORIZATION OBJECT 1}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Clear Field Text    ${AUTHORIZATION OBJECT 2}    
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    ${Authorization Object 1 VALUE}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    ${TCD VALUE}   SPRO
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 2}    S_TABU_NAM
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL201    ${value_02}
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211    ${Object 3}
    Sleep    2
    Take Screenshot    Control_access3.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_access4.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result17.1_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 17 completed
    Click Element    ${BACK}
    Sleep    1



Release Debug Privilege on Production
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    S_DEVELOP
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL111    DEBUG
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL141    ${value_02}
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL142    03
    Sleep    2
    Take Screenshot    Release_Debug1.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Release_Debug2.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result19_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 18 completed
    Click Element    ${BACK}
    Sleep    1
    
Mandantonderhoud
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    ${Authorization Object 1 VALUE}
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    SE03
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL102    SE06
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL103    SCC4
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL104    SCC5
    Sleep    2
    Take Screenshot    Mandantonderhoud1.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Mandantonderhoud2.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result21_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 20 completed
    Click Element    ${BACK}
    Sleep    1

Control Booking Period 
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
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result22_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 19 completed
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
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result22.1_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 19.1 completed
    Click Element    ${BACK}
    Sleep    1
Control SAP standard users
    Run Transaction    /nRSUSR003
    Sleep    2
    Take Screenshot    Control_SAP_standard_users1.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_SAP_standard_users2.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result20_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 21 completed
    Click Element    ${BACK}
    Sleep    1
    Click Element    ${BACK}
    Sleep    1

Control table logging

    Run Transaction    /nSE16
    Sleep    2
    Take Screenshot    Control_table_logging1.jpg
    Input Text    wnd[0]/usr/ctxtDATABROWSE-TABLENAME    DD09L
    Sleep    2
    Send Vkey    0
    Sleep    2
    Take Screenshot    Control_table_logging2.jpg
    Input Text    wnd[0]/usr/ctxtI11-LOW    01.07.2024
    Sleep    2
    Input Text    wnd[0]/usr/ctxtI11-HIGH    17.07.2024
    Sleep    2
    Input Text    wnd[0]/usr/ctxtI8-LOW    X
    Sleep    2
    Take Screenshot    Control_table_logging3.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_table_logging4.jpg
    Click Element    ${BACK}
    Sleep    1
    Log To Console    Requirement 22 completed


Control mandant changes
    Run Transaction    /nSCU3
    Sleep    2
    Take Screenshot    Control_mandant_changes1.jpg
    Click Element    wnd[1]/usr/btnSPOP-VAROPTION1
    Sleep    2
    Click Element    wnd[0]/usr/btnBUTTON_AUSWERTEN
    Sleep    2
    Input Text    wnd[0]/usr/ctxtCUSOBJ-LOW    T000
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/ctxtDBEG    01.07.2024
    Sleep    2
    Input Text    wnd[0]/usr/ctxtDEND    16.07.2024
    Sleep    2
    Take Screenshot    Control_mandant_changes2.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_mandant_changes3.jpg
    Log To Console    Requirement 23 completed
    Click Element    ${BACK}
    Sleep    1

Control blocking transactions
    Run Transaction    /nSM01_CUS
    Sleep    2
    Take Screenshot    Control_blocking_transactions1.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_blocking_transactions2.jpg
    Click Element    ${BACK}
    Sleep    1
    Log To Console    Requirement 24 completed
    

Audit log configuration
    Run Transaction    SM19
    Sleep    2
    Take Screenshot    Audit_log_configuration1.jpg
    Click Element    ${BACK}
    Sleep    1
    Log To Console    Requirement 25 completed


Control RFC connections users
    Run Transaction    SUIM
    Sleep    2
    Take Screenshot    Control_RFC1.jpg  
    Click Node Link 3    ${tree_id}    ${link_id1}      ${link_id2}    ${link_id13}    ${link_id14}
    Sleep    2
    Take Screenshot    Control_RFC2.jpg
    Unselect Checkbox    wnd[0]/usr/chkDIAGUSER
    Sleep    2
    Unselect Checkbox    wnd[0]/usr/chkREFUSER
    Sleep    2
    Take Screenshot    Control_RFC3.jpg
    Click Element    ${Execute}
    Sleep    5
    Take Screenshot    Control_RFC4.jpg
    Select Table Column    wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell    BNAME
    Sleep    2
    ${Read}    Read Table Column    wnd[0]/usr/cntlGRID1/shellcont/shell/shellcont[1]/shell    BNAME
    Sleep    2
    Log To Console    ${Read}  
    Sleep    2
    ${Count}    Get Length    ${Read}
    Log    ${Count}
    Log To Console    ${Count}
    Take Screenshot    Control_RFC5.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Click Element   wnd[0]/usr/btn%_BNAME_%_APP_%-VALU_PUSH
    Sleep    2
    Set Focus    wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL_255-SLOW_I[1,0]
    Send Vkey    0    1
    Sleep    2
    ${row_index}    Set Variable    0
    ${visible_rows}    Set Variable    7
    FOR  ${value}  IN RANGE	${Count}
        ${cell_locator}    Set Variable    wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL_255-SLOW_I[1,${row_index}]
        Log To Console    Trying to set value ${value} in cell ${cell_locator}
        Input Text    ${cell_locator}   ${Read}[${value}]
        ${row_index}=  Evaluate  ${row_index} + 1
        IF  ${row_index} >= ${visible_rows}
            ${row_index}    Set Variable    0
            Send Vkey    vkey_id=82    window=1
            Sleep    1
        END
    END
    setFocus    wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/btnRSCSEL_255-SOP_I[0,3]
    Sleep    2
    Click Element   wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/btnRSCSEL_255-SOP_I[0,3]
    Sleep    2
    Click Current Cell  wnd[2]/usr/cntlOPTION_CONTAINER/shellcont/shell    "TEXT"
    Sleep    2
    Take Screenshot    Control_RFC6.jpg
    Click Element   wnd[2]/tbar[0]/btn[0]
    Sleep    2
    Click Element   wnd[1]/tbar[0]/btn[8]
    Sleep    2
    Log To Console    Requirement 26 completed

Delete audit audit files
    Run Transaction    /nSE38
    Sleep    2
    Take Screenshot    Delete_audit_audit_files1.jpg
    Input Text    wnd[0]/usr/ctxtRS38M-PROGRAMM    RSPARAM
    Sleep    2
    Take Screenshot    Delete_audit_audit_files2.jpg
    Click Element    ${Execute}
    Sleep    2
    Take Screenshot    Delete_audit_audit_files3.jpg
    Select Checkbox    wnd[0]/usr/chkALSOUSUB
    Sleep    2
    Take Screenshot    Delete_audit_audit_files4.jpg
    Click Element    ${Execute}
    Sleep    2
    Take Screenshot    Delete_audit_audit_files5.jpg
    ${path}    Get Cell Value    wnd[0]/usr/cntlGRID1/shellcont/shell    3    PAR_USER_WERT
    Log To Console    ${path}
    Sleep    2
    Run Transaction    /nSUIM
    Sleep    2
    Click Node Link     ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
    Sleep    2
    Take Screenshot    Delete_audit_audit_files6.jpg
    Click Element    ${AUTHORIZATION TAB}
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 1}    S_ADMI_FCD
    Sleep    2
    Send Vkey    0
    Sleep    2
    Input Text    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL101    AUDA
    Sleep    2
    Input Text    ${AUTHORIZATION OBJECT 2}    S_DATASET
    Sleep    2
    Send Vkey    0
    Sleep    2
    Scroll    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004    position=150
    Sleep    2
    Input Text	wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL211	06
    Sleep    2
    Input Text	wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB4/ssub%_SUBSCREEN_TAB:RSUSR002:1004/txtVAL221	${path}
    Sleep    5
    Take Screenshot    Delete_audit_audit_files7.jpg
    Click Element    ${Execute}
    Sleep    2
    Take Screenshot    Delete_audit_audit_files8.jpg
    Click Element    ${local file}
    Sleep    2
    Select Radio Button    ${Text with tabs Button}
    Click Element    ${local file continue}
    Sleep    1
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${Results_Directory_Path}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${Req_Result_Filename}
    Sleep    1
    Click Element    ${local file continue}
    Sleep    1
    Log To Console    Requirement 27 completed
    Click Element    ${BACK}
    Sleep    1


Table maintenance without restrictions
    Run Transaction    /nSUIM
    Sleep    1
    Take Screenshot    Table_maintenance1.jpg
    Click Node Link 1    ${tree_id}    ${link_id1}    ${link_id2}    ${link_id3}     ${link_id4}    ${link_id5}
    Sleep    1
    Take Screenshot    Table_maintenance2.jpg
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
    Take Screenshot    Table_maintenance3.jpg
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Take Screenshot    Table_maintenance4.jpg
    Log To Console    Requirement 27 completed
    Click Element    ${BACK}
    Sleep    1

Emergency User Edition
    Run Transaction     /nSUIM
    Sleep    2
    Take Screenshot    Emergency_User_Edition1.jpg
    Click Node Link 1   ${tree_id}    ${link_id6}    ${link_id7}    ${link_id8}     ${link_id9}    ${link_id10}
    Sleep    5
    Take Screenshot    Emergency_User_Edition2.jpg
    Input Text    wnd[0]/usr/ctxtUSER-LOW    *SAP*
    Sleep    1
    Input Text    wnd[0]/usr/ctxtFDATE    16.07.2024
    Sleep    1
    Select Checkbox    wnd[0]/usr/tabsTABSTRIP_TAB/tabpTAB1/ssub%_SUBSCREEN_TAB:RSUSR100N:1100/chkPASS
    Sleep    1
    Take Screenshot    Emergency_User_Edition3.jpg
    Click Element    ${Execute}
    Sleep    1
    Take Screenshot    Emergency_User_Edition4.jpg
    Log To Console    Requirement 28 completed
    Click Element    ${BACK}
    Sleep    1
USMM
    Run Transaction    /nusmm
    Sleep    2
    Take Screenshot    USMM1.jpg
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    1
    Send Vkey    0
    Sleep    10
    Take Screenshot    USMM2.jpg
    Click Element    wnd[0]/tbar[1]/btn[7]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Take Screenshot    USMM3.jpg
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    Take Screenshot    USMM4.jpg

Generate report
    Image Resize    ${directory}
    Mcr Report Pdf    ${excel_directory}    ${images_directory}    Doc_name=MCR_OUTPUT