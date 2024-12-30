*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
 
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}    
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg

System Logout
    Run Transaction   /nex
    Sleep    5
    Take Screenshot    logoutpage.jpg
    Sleep    10

Transaction SDCCN
    Run Transaction    SDCCN
    Sleep    2
    Take Screenshot    SDCCN_1.JPG
    Sleep    2
    Click Element    wnd[0]/usr/tabsGC_TASK_TABSTRIP/tabpOUTBOX
    Sleep    2
    Take Screenshot    SDCCN_2.JPG
    Sleep    2
    Click Element    wnd[0]/usr/tabsGC_TASK_TABSTRIP/tabpDEL_ITEMS
    Sleep    2
    Take Screenshot    SDCCN_3.JPG
    Sleep    2
    Click Element    wnd[0]/usr/tabsGC_TASK_TABSTRIP/tabpSHOWLOG
    Sleep    2
    Take Screenshot    SDCCN_4.JPG

Transaction SE03
    Run Transaction    SE03
    Sleep    3
    Take Screenshot    SE03_1.JPG
    Sleep    2

Transaction SE06
    Run Transaction    SE06
    Sleep    2
    Take Screenshot    SE06_1.JPG
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[17]
    Sleep    3
    Take Screenshot    SE06_2.JPG

Transaction SLICENSE   
    Run Transaction    SLICENSE
    Sleep    1
    Take Screenshot    slicense1.jpg
    Sleep    2
    Click Element    wnd[0]/usr/tabsTABSTRIP_1000/tabpREMOTE_HWKEY
    Sleep    30
    Take Screenshot    slicense2.robot
    Sleep    2

Transaction SMW0
    SMW0
    Binarydata SMW0

SMW0
    Run Transaction    SMW0
    Sleep    2
    Take Screenshot    SMW02.JPG
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    SMW03.JPG
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    SMW04.JPG
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2

Binarydata SMW0
    Select Radio Button    wnd[0]/usr/radRADIO_MI        
    Sleep    2
    Take Screenshot    SMW05.JPG
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    SMW06.JPG
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    SMW07.JPG

Transaction SM14
    Run Transaction    SM14
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[13]
    Sleep    2
    Take Screenshot    updateProgrammeAdminstration.jpg
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[3] 
    Sleep    2
    Click Element    wnd[0]/usr/tabsFOLDER/tabpSERVERS
    Sleep    5
    Take Screenshot    server.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsFOLDER/tabpGROUPS
    Sleep    10
    Take Screenshot    serverGroup.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsFOLDER/tabpPARAMETERS
    Sleep    2
    Set Focus    wnd[0]/usr/tabsFOLDER/tabpPARAMETERS/ssubSUBSUPDATE:SAPMSM14:1050/tblSAPMSM14PARAMETERLISTE
    Sleep    3
    
    FOR    ${i}    IN RANGE    2
        Send Vkey    82     
        Take Screenshot    ${i+1}parameter.jpg
        Sleep    1
                
    END

Transaction SMICM
    Run Transaction    SMICM
    Sleep    1
    Take Screenshot    SMICM_1.jpg
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[13]
    Sleep    3
    Take Screenshot    SMICM_2.jpg
    Sleep    2

Transaction SWU3
    Run Transaction    SWU3
    Sleep    1
      
    Expand Element    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell    ${space*10}1
    Take Screenshot    SWU3_1.jpg
    Sleep    2
      
    Expand Element    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell    ${space*9}13
    Take Screenshot    SWU3_2.jpg
    Sleep    2
      
    Expand Element    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell    ${space*9}17
    Take Screenshot    SWU3_3.jpg
    Sleep    2
      
    Expand Element    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell    ${space*9}22
    Take Screenshot    SWU3_4.jpg
    Sleep    2
      
    Expand Element    wnd[0]/usr/shellcont/shell/shellcont[0]/shellcont/shell/shellcont[0]/shell    ${space*9}29 
    Take Screenshot    SWU3_5.jpg
    Sleep    2

Transaction DB13
    Run Transaction    DB13
    Sleep    2
    Take Screenshot     DB13_1.jpg

Transaction DBCO
    Run Transaction    /nDBCO
    Sleep    2
    Take Screenshot     DBCO_1.jpg
    Scroll Pagedown    /app/con[0]/ses[0]/wnd[0]/usr/tblSAPLSDB_DBCONTCTRL_DBCON   
    Sleep    5
    Take Screenshot     DBCO_2.jpg

Transaction BD97
    Run Transaction    /nBD97
    Sleep    2
    ${continue_loop}=    Set Variable    ${TRUE}
    ${max_iterations}=    Set Variable    15
    ${i}=    Set Variable    0
    FOR    ${i}    IN RANGE    0    ${max_iterations}
       ${initial_scroll_position}    Get Scroll Position    /app/con[0]/ses[0]/wnd[0]/usr
       Log To Console    ${initial_scroll_position}
       Send Vkey    82
       Take Screenshot    BD97_${i}.jpg
       Sleep    2
       ${final_scroll_position}    Get Scroll Position    /app/con[0]/ses[0]/wnd[0]/usr
       Log To Console    ${final_scroll_position}
       Run Keyword If    '${initial_scroll_position}' == '${final_scroll_position}'    Exit For Loop
    END  

Transaction SM64
    Run Transaction    /nSM64
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/ssubMAIN_SCREEN:RSEVTHIST:4000/tabsEVTHIST/tabpEVTHIST_FC1
    Sleep    5
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/ssubMAIN_SCREEN:RSEVTHIST:4000/tabsEVTHIST/tabpEVTHIST_FC2
    Sleep    5
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/ssubMAIN_SCREEN:RSEVTHIST:4000/tabsEVTHIST/tabpEVTHIST_FC3
    Sleep    5
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/ssubMAIN_SCREEN:RSEVTHIST:4000/tabsEVTHIST/tabpEVTHIST_FC4
    Sleep    5
    FOR    ${i}     IN RANGE    1    8
        ${i} =    Evaluate    ${i}*31
        ${selected_rows}    Selected_rows    wnd[0]/usr/ssubMAIN_SCREEN:RSEVTHIST:4000/tabsEVTHIST/tabpEVTHIST_FC4/ssubEVTHIST_SCA:RSEVTHIST:4040/cntlBATCH_EVENTS/shellcont/shell    ${i}
        Log To Console    ${i}    
        Take Screenshot    SM64_${i}st.jpg
        Sleep    1
    END

Transaction SECSTORE
    Run Transaction    /nSECSTORE
    Sleep    2
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP_TAB/tabpT_CHECK
    Sleep    1
    Take Screenshot    SECSTORE_1.jpg
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP_TAB/tabpT_KEY
    Sleep    1
    Take Screenshot    SECSTORE_2.jpg
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP_TAB/tabpT_GLOB
    Sleep    1
    Take Screenshot    SECSTORE_3.jpg
    Sleep    1
    Click Element    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP_TAB/tabpT_CHECK
    Sleep    1
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Sleep    25s
    FOR    ${i}    IN RANGE    13
            Selected Rows    /app/con[0]/ses[0]/wnd[0]/usr/subSUBSCREEN:SAPLSBAL_DISPLAY:0101/cntlSAPLSBAL_DISPLAY_CONTAINER/shellcont/shell/shellcont[1]/shell    ${i*34}
            Sleep    1
            Take Screenshot    SECSTORE_${i+3}.jpg
    END

Transaction AL11
    Run Transaction    /nAL11
    Sleep    2
    Select Table Row    wnd[0]/usr/cntlGRID1/shellcont/shell   0
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/cntlGRID1/shellcont/shell
    Sleep    1
    Take Screenshot    AL11.jpg
    Sleep    2

Transaction RZ03
    Run Transaction    /nRZ03
    Sleep    2
    Take Screenshot    RZ03.jpg
    Sleep    2

Transaction RZ04
    Run Transaction    /nRZ04
    Sleep    2
    Take Screenshot    RZ04.jpg
    Sleep    2

Transaction RZ10
    Run Transaction    /nRZ10
    Sleep    2
    Send Vkey    4    window=0
    Sleep    1
    Set Focus    wnd[1]/usr/lbl[32,3]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Select Radio Button    wnd[0]/usr/radSPFL1010-EXPERT
    Sleep    1
    Click Element   wnd[0]/usr/btnSHOW_PUSH
    Sleep    1
    Take Screenshot    RZ10_Default_profile_parameter.jpg
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Send Vkey    4    window=0
    Sleep    1
    Set Focus    wnd[1]/usr/lbl[32,5]
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Click Element   wnd[0]/usr/btnSHOW_PUSH
    Sleep    1
    Take Screenshot    RZ10_Instance_profile_parameter.jpg
    Sleep    1

RZ12
    Run Transaction    /nRZ12
    Sleep    2
    Take Screenshot    RZ12.jpg
    Sleep    1

RZ70
    Run Transaction    /nRZ70
    Sleep    2
    Take Screenshot    RZ70.jpg
    Sleep    1

Sldapicust
    Run Transaction    /nsldapicust
    Sleep    2
    Take Screenshot     sldapicust_1.jpg
    ${destination}  get cell value from gridtable       wnd[0]/usr/cntlCONTAINER/shellcont/shell
    Log     ${destination}
    Run Transaction     /nsm59
    Take Screenshot     sldapicust_2.jpg
    Click Element   wnd[0]/mbar/menu[1]/menu[5]
    Input Text  wnd[1]/usr/tabsG_SELONETABSTRIP/tabpTAB001/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/txtG_SELFLD_TAB-LOW[0,24]       ${destination}
    Sleep   5
    Take Screenshot     sldapicust_3.jpg
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep  5s
    Take Screenshot     sldapicust_4.jpg
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   5s
    Take Screenshot     sldapicust_5.jpg
    Sleep   5s
    Click Element   wnd[0]/usr/tabsTAB_SM59/tabpSIGN
    Sleep   5s
    Take Screenshot     sldapicust_6.jpg  

SMLG 
    Run Transaction     SMLG
    Sleep   10s
    Take Screenshot     SMLG_1.jpg
    SMLG Attributes
    SMLG Load Distributions

SMLG Attributes
    Select Item From Guilable   wnd[0]/usr      BCSIDESSYS_BIS_00    
    Sleep   2s
    Click Element   wnd[0]/tbar[1]/btn[14]
    Sleep   5s
    Take Screenshot     SMLG_2.jpg
    Click Element   wnd[1]/usr/tabsSEL_TAB/tabpPROP
    Sleep   5s
    Take Screenshot     SMLG_3.jpg
    Click Element   wnd[1]/tbar[0]/btn[12]
    Sleep   5s
    Take Screenshot     SMLG_4.jpg

SMLG Load Distributions
    Click Element   wnd[0]/tbar[1]/btn[5]
    Sleep   10s
    Take Screenshot     SMLG_5.jpg

Transaction SPAD
    Run Transaction     /nSPAD
    Sleep   5s
    Take Screenshot     SPAD_1.jpg
    ARCH Screenshot
    LOCL Screenshot
    LP01 Screenshot
    ZPDF Screenshot

ARCH Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    ARCH
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   5s
    Take Screenshot     SPAD_2.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   5s
    
LOCL Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    Ctrl+A
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    LOCL
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   5s
    Take Screenshot     SPAD_3.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   5s

LP01 Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    Ctrl+A
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    LP01
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   5s
    Take Screenshot     SPAD_4.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   5s
    
ZPDF Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    Ctrl+A
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    ZPDF
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   5s
    Take Screenshot     SPAD_5.jpg

Transaction STMS
    Run Transaction     /nSTMS
    Sleep   5s
    Take Screenshot
    Click Element   wnd[0]/mbar/menu[0]/menu[4]
    Sleep   5s
    Take Screenshot     STMS_1.jpg
    Doubleclick Element     wnd[0]/usr/cntlGRID1/shellcont/shell    0   0
    Sleep   10s
    Click Element   wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpDOMA
    Sleep   5s
    Take Screenshot     STMS_2.jpg
    
    Click Element   wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpTPPE
    Sleep   5s
    Take Screenshot     STMS_3.jpg
    Import Overview
    Transport Routes 

Import Overview
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   2s
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   2s
    Click Element   wnd[0]/tbar[1]/btn[5]
    Sleep   5s
    Take Screenshot     STMS_4.jpg

Transport Routes
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   5s
    Click Element   wnd[0]/tbar[1]/btn[19]
    Sleep   5s
    Take Screenshot     STMS_5.jpg
    Transport Layers

Transport Layers
    Click Element   wnd[0]/mbar/menu[2]/menu[1]
    Sleep   5s
    Take Screenshot     STMS_6.jpg

SCC4
    Run Transaction    /nSCC4
    Sleep    2
    ${count_row}    Get Value    wnd[0]/usr/txtVIM_POSITION_INFO
    Log    ${count_row}
    ${start_index}    Set Variable    ${count_row.find("of ") + 3}
    ${end_index}    Set Variable    ${count_row.find("of ") + 4}
    ${number_value}    Get Substring    ${count_row}    ${start_index}    ${end_index}
    Log    ${number_value}
    FOR    ${index}    IN RANGE    ${number_value}
        ${current_screenshot}    Set Variable    SCC4${index + 1}.jpg
        Set Focus    wnd[0]/usr/tblSAPL0SZZTCTRL_T000/txtT000-MANDT[0,${index}]
        Sleep    1
        ${double_click_status}    Send Vkey    vkey_id=2    window=0
        Sleep    1
        ${Screen_shot}    Take Screenshot    ${current_screenshot}
        Click Element    wnd[0]/tbar[0]/btn[3]
    END
SCOT
    Run Transaction    /nSCOT
    Sleep    2
    Click Toolbar Button    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_NODES:0100/cntlSMTP_NODES_TOOLBAR_CONTAINER/shellcont/shell    EXPA
    Sleep    1
    Take Screenshot    SCOT.jpg
    Sleep    2

SM49
    Run Transaction    /nSM49
    Sleep    2
    FOR    ${i}    IN RANGE    6
        ${selected_rows}    Selected Rows    /app/con[0]/ses[0]/wnd[0]/usr/cntlEXT_COM/shellcont/shell    ${i*30}    
        Take Screenshot    SM49_${i}.jpg
        Sleep    1
    END

SM61
    Run Transaction    /nSM61 
    Sleep    2
    Click Element    wnd[0]/usr/tabsCONTROL_TAB/tabpOBJT
    Sleep    1
    Take Screenshot    SM61_Object.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsCONTROL_TAB/tabpTRCT
    Sleep    1
    Take Screenshot    SM61_Trace.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsCONTROL_TAB/tabpTENV
    Sleep    1
    Take Screenshot    SM16_Health_check.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsCONTROL_TAB/tabpTENV/ssubSUB_OBJ:SAPLCOBJ:0140/btnBUTTON2
    Sleep    2
    Take Screenshot    SM16_Health_check_All_background_server_check.jpg
    Sleep    2

SM63
    Run Transaction    /nSM63
    Sleep    2
    Click Element    wnd[0]/usr/btnANZEIGEN
    Sleep    1
    Take Screenshot    SM63.jpg
    Sleep    2

SM20
    Run Transaction    /nSM20
    Sleep    2
    Take Screenshot    SM20.jpg
    Sleep    2

SMQR
    Run Transaction    /nSMQR
    Sleep    2
    Take Screenshot    SMQR.jpg
    Sleep    2

SMQS
    Run Transaction    /nSMQS 
    Sleep    2
    Take Screenshot    SMQS.jpg
    Sleep    2

STRUSTSSO2_SSL
    Run Transaction    /nSTRUSTSSO2
    Sleep    2
    Take Screenshot    ssl.jpg
    STRUSTSSO2_SSL_System_PSE
    STRUSTSSO2_SSL_Sever_Standard
    STRUSTSSO2_SSL client SSL Client Anonymous
    STRUSTSSO2_SSL client SSL Client Standard
    
STRUSTSSO2_SSL_System_PSE
    Double Click On Tree Item    wnd[0]/shellcont/shell    PROG<SYST>    
    Sleep    2
    Take Screenshot    SSL_System_PSE1.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    SSL_System_PSE2.jpg
    Sleep    2
STRUSTSSO2_SSL_Sever_Standard       
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLSDFAULT    
    Sleep    2
    Take Screenshot    SSL_Sever_Standard1.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL      
    Sleep   2
    Take Screenshot    SSL_Sever_Standard2.jpg
    Sleep    2

STRUSTSSO2_SSL client SSL Client Anonymous
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCANONYM    
    Sleep    2
    Take Screenshot    SSL client SSL Client Anonymous1.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    SSL client SSL Client Anonymous2.jpg
    Sleep    2

STRUSTSSO2_SSL client SSL Client Standard
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCDFAULT    
    Sleep    2
    Take Screenshot    SSL client SSL Client Standard1.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    SSL client SSL Client Standard2.jpg
    Sleep    2