*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py


*** Variables ***    
# ${SAP_SERVER}     C:\\Program Files (x86)\\SAP\\FrontEnd\\SAPgui\\saplogon.exe     
# ${logon}    /app/con[0]/ses[0]/wnd[0]/mbar/menu[0]/menu[0]
# ${FIELD_CLIENT}     wnd[0]/usr/txtRSYST-MANDT
# ${FIELD_USER}   wnd[0]/usr/txtRSYST-BNAME
# ${FIELD_PASSWORD}   wnd[0]/usr/pwdRSYST-BCODE


*** Keywords ***
Transaction SM69
    Run Transaction     /nsm69
    Send Vkey    0
    # Take Screenshot    001_sm69.jpg
    Sleep    1

External Operating System Commands        
    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    23    
    Sleep    1
    # Take Screenshot    002_sm69.jpg

SM69 Scroll
    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    46    
    Sleep    1
    # Take Screenshot    003_sm69.jpg

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    69    
    Sleep    1
    # Take Screenshot    004_sm69.jpg

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    92    
    Sleep    1
    # Take Screenshot    005_sm69.jpg

    selected_rows   wnd[0]/usr/cntlEXT_COM/shellcont/shell    103   
    Sleep    1
    # Take Screenshot    006_sm69.jpg
    
Transaction SMQS
    Run Transaction     /nsmqs
    Send Vkey    0
    Take Screenshot    007_smqs_QRFC Monitor.jpg
    Sleep    1

QRFC Administration     
    Click Element  wnd[0]/mbar/menu[2]/menu[0]
    Take Screenshot     008_smqs_QRFC Administration1.jpg
    Send Vkey    82
    Take Screenshot     009_smqs_QRFC Administration2.jpg
    Send Vkey    82
    Take Screenshot     010_smqs_QRFC Administration3.jpg
    Send Vkey    82
    Take Screenshot     011_smqs_QRFC Administration4.jpg
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1

QRFC Administration INBOUND
    Click Element  wnd[0]/mbar/menu[2]/menu[0]
    Click Element  wnd[0]/mbar/menu[2]/menu[0]/menu[1]
    Sleep    1
    Take Screenshot        012_smqs_QRFC Administration INBOUND.jpg
    Click Element  wnd[0]/tbar[0]/btn[3]

QRFC Administration OUTBOUND
    Click Element  wnd[0]/mbar/menu[2]/menu[0]/menu[0]
    Sleep    1
    Take Screenshot        013_smqs_QRFC Administration OUTBOUND.jpg
    Click Element  wnd[0]/tbar[0]/btn[3]


QRFC Administration OUTBOUND SCHEDULER
    Click Element  wnd[0]/mbar/menu[2]/menu[0]/menu[2]
    Sleep    1
    Take Screenshot        014_smqs_QRFC Administration OUTBOUND SCHEDULER.jpg
    Click Element  wnd[0]/tbar[0]/btn[3]

QRFC Administration INBOUND SCHEDULER
    Click Element  wnd[0]/mbar/menu[2]/menu[0]/menu[3]
    Sleep    1
    Take Screenshot        015_smqs_QRFC Administration INBOUND SCHEDULER.jpg
    Click Element  wnd[0]/tbar[0]/btn[3]
    Click Element    wnd[0]/tbar[0]/btn[3]

Display Possible Resources
    Click Element  wnd[0]/mbar/menu[2]/menu[1]
    Sleep    1
    Take Screenshot        016_smqs_Display Possible Resources.jpg
    Click Element    wnd[0]/tbar[0]/btn[3]

Transaction SCOT
    Run Transaction     /nscot
    Send Vkey    0
    Take Screenshot    017_scot.jpg
    Sleep    1
    
SMTP Nodes    
    Click Toolbar Button    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_NODES:0100/cntlSMTP_NODES_TOOLBAR_CONTAINER/shellcont/shell  EXPA
    Doubleclick Element    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_NODES:0100/cntlSMTP_NODES_COLUMN_TREE_CONT/shellcont/shell    SMTP    Node
    Sleep    1
    Take Screenshot    018_SMTP.jpg
    Send Vkey    0        
    Doubleclick Element    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_NODES:0100/cntlSMTP_NODES_COLUMN_TREE_CONT/shellcont/shell    SMTP&-&INT    Node
    Sleep    1
    Take Screenshot    019_SMTP&INT.jpg
    Send Vkey   0

Settings Nodes
    Scot Tree    wnd[0]/shellcont/shell/shellcont[1]/shell           
    Sleep    1
    Take Screenshot    020_OutboundSettings.jpg

    Click Element    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_SETTINGS:0200/tabsGV_CNT_TABSTR_OUT/tabpSTATUS
    Sleep    1
    Take Screenshot    021_Statusrequest.jpg    
    
    Click Element    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_SETTINGS:0200/tabsGV_CNT_TABSTR_OUT/tabpA_OUT
    Sleep    1
    Take Screenshot    022_Anlys.jpg
    
    Click Element    wnd[0]/usr/subCONTENT:SAPLSBCS_ADM:0104/subSUB_CONTENT:SAPLSBCS_SETTINGS:0200/tabsGV_CNT_TABSTR_OUT/tabpSIGN_ENCRYPT
    Sleep    1
    Take Screenshot    023_sig&encry.jpg
    Sleep    1

Transaction SMQR
    Run Transaction     /nsmqr
    Send Vkey    0
    Take Screenshot    024_smqr.jpg
    Sleep    1

Transaction AL11
    Run Transaction     /nal11
    Send Vkey    0
    Take Screenshot    025_al11.jpg
    Sleep    2
    Table Scroll   wnd[0]/usr/cntlEXT_COM/shellcont/shell    23 
    Sleep    2
    Take Screenshot    026_al11.jpg

Transaction SHMM
    Run Transaction     /nshmm
    Send Vkey    0
    Take Screenshot    027_shmm.jpg
    Sleep    1
    Click Element    wnd[0]/usr/tabsTAB_0100/tabpTAB_0100_TUNE
    Take Screenshot    028_shmm_shared_Memory.jpg

Transaction STRUST
    Run Transaction     /nstrust
    Send Vkey    0
    Take Screenshot    029_PSE.jpg
    Sleep    2
    
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL      
    Sleep   2
    Take Screenshot    030_PSE.jpg
    Sleep    2

SSL server standard        
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLSDFAULT    
    Sleep    2
    Take Screenshot    031_SSLSDFAULT.jpg
    Sleep    2

    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL      
    Sleep   2
    Take Screenshot    032_SSLSDFAULT.jpg
    Sleep    2

SSL client SSL Client (Anonymous)
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCANONYM    
    Sleep    2
    Take Screenshot    033_SSLCANONYM.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    034_SSLCANONYM.jpg
    Sleep    2

SSL client SSL Client (Standard)
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCDFAULT    
    Sleep    2
    Take Screenshot    035_SSLCDFAULT.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    036_SSLCDFAULT.jpg
    Sleep    2

WS Security Other System Encryption
    Double Click On Tree Item    wnd[0]/shellcont/shell    WSSEWSSCRT    
    Sleep    2
    Take Screenshot    037_WSSEWSSCRT.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    038_WSSEWSSCRT.jpg
    Sleep    2
SSF Logon Ticket
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSFASSO2    
    Sleep    2
    Take Screenshot    039_SSFASSO2.jpg
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    040_SSFASSO2.jpg

Transaction SMLG
    Run Transaction     /nSMLG
    Sleep   1
    Take Screenshot     041_smlg.jpg

SMLG Attributes
    Select Item From Guilabel   wnd[0]/usr      BCSIDESSYS_BIS_00    
    Sleep   1
    Take Screenshot    042_smlg.jpg
    Click Element   wnd[0]/tbar[1]/btn[14]
    Sleep   1
    Take Screenshot    043_smlg.jpg
    Click Element   wnd[1]/usr/tabsSEL_TAB/tabpPROP
    Sleep   1
    Take Screenshot    044_smlg.jpg
    Click Element   wnd[1]/tbar[0]/btn[12]
    Sleep   1
    Take Screenshot    045_smlg.jpg

SMLG Load Distributions
    Click Element   wnd[0]/tbar[1]/btn[5]
    Sleep   1
    Take Screenshot    046_smlg.jpg

Transaction Uconcockpit
    Run Transaction     /nUconcockpit
    Send Vkey    0
    Take Screenshot    047_Uconcockpit.jpg
    Sleep    2

RFC Basic Scenario
    Select From List by Label   wnd[0]/usr/cmbP_SCEN    RFC Basic Scenario
    Sleep    2
    Take Screenshot    048_Uconcockpit.jpg
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    049_Uconcockpit.jpg
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Take Screenshot    050_Uconcockpit.jpg
Role Building Scenario
    Select From List by Label   wnd[0]/usr/cmbP_SCEN    Role Building Scenario
    Sleep    2
    Take Screenshot    051_Uconcockpit.jpg
    Click Element    wnd[0]/tbar[1]/btn[8]
    Sleep    2
    Take Screenshot    052_Uconcockpit.jpg
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    2
    Take Screenshot    053_Uconcockpit.jpg
    
Transaction OACO
    Run Transaction     /nOAC0
    Sleep   1
    Take Screenshot
    Scroll      wnd[0]/usr/tblSAPLSCMS_CREPC_SREP       35
    Sleep   1
    Take Screenshot    054_OACO.jpg
    Scroll      wnd[0]/usr/tblSAPLSCMS_CREPC_SREP       70
    Sleep   1
    Take Screenshot    055_OACO.jpg
    Scroll      wnd[0]/usr/tblSAPLSCMS_CREPC_SREP       105
    Sleep   1
    Take Screenshot    056_OACO.jpg
    Scroll      wnd[0]/usr/tblSAPLSCMS_CREPC_SREP       140
    Sleep   1
    Take Screenshot    057_OACO.jpg

Transaction SPAD
    Run Transaction     /nSPAD
    Sleep   1
    Take Screenshot    058_spad.jpg
    
ARCH Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    ARCH
    Take Screenshot    059_spad_arch.jpg
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   1
    Take Screenshot    060_spad_arch.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    061_spad_arch.jpg
    
LOCL Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    Ctrl+A
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    LOCL
    Take Screenshot    062_spad_locl.jpg
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   1
    Take Screenshot    063_spad_locl.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    064_spad_locl.jpg

LP01 Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    Ctrl+A
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    LP01
    Take Screenshot    065_spad_lp01.jpg
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   1    
    Take Screenshot    066_spad_lp01.jpg    
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    067_spad_lp01.jpg

ZPDF Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    Ctrl+A
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    ZPDF
    Take Screenshot    068_spad_zpdf.jpg
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   1
    Take Screenshot    069_spad_zpdf.jpg

Transaction SLDAPICUST
    Run Transaction     /nSldapicust
    Sleep   1
    Take Screenshot    070_Sldapicust.jpg

Sldapicust display
    ${destination}  get cell value from gridtable   wnd[0]/usr/cntlCONTAINER/shellcont/shell
    Log     ${destination}
    Run Transaction     /nsm59
    Click Element   wnd[0]/mbar/menu[1]/menu[5]
    Input Text   wnd[1]/usr/tabsG_SELONETABSTRIP/tabpTAB001/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/txtG_SELFLD_TAB-LOW[0,24]       SLD_BCSCLNTPO
    Sleep   5
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep  5s
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   5s
    Take Screenshot    071_display.jpg
    Sleep   5s
    Click Element   wnd[0]/usr/tabsTAB_SM59/tabpSIGN
    Sleep   5s
    Take Screenshot    072_display.jpg  
 

Transaction STMS
    Run Transaction     /nSTMS
    Sleep   1
    Take Screenshot    073_stms.jpg
    Click Element   wnd[0]/mbar/menu[0]/menu[4]
    Sleep   1
    Take Screenshot    074_stms.jpg
    
    Rows From Stms    wnd[0]/usr/cntlGRID1/shellcont/shell
    Sleep   1
    Take Screenshot    075_stms.jpg

    Click Element    wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpATTR
    Sleep    2
    Take Screenshot    076_stms.jpg

    Click Element   wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpDOMA
    Sleep   1
    Take Screenshot    077_stms.jpg    
    
    Click Element   wnd[0]/usr/tabsGN_DYN150_TAB_STRIP/tabpTPPE
    Sleep   1
    Take Screenshot    078_stms.jpg
    
Import Overview
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    079_stms.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    080_stms.jpg
    Click Element   wnd[0]/tbar[1]/btn[5]
    Sleep   1
    Take Screenshot    081_stms.jpg

Transport Routes
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   1
    Take Screenshot    082a_stms.jpg
    Click Element   wnd[0]/tbar[1]/btn[19]
    Sleep   1
    Take Screenshot    082b_stms.jpg
   

Transport Layers
    Click Element   wnd[0]/mbar/menu[2]/menu[1]
    Sleep   1
    Take Screenshot    083_stms.jpg

Transaction WE20
    Run Transaction     /nwe20
    Sleep   1
    Take Screenshot    084_WE20.jpg

Partner type LS
    Select Node     wnd[0]/shellcont/shell  LS
    Sleep   1
    Take Screenshot    085_typeLS.jpg
    Click Element   wnd[0]/tbar[1]/btn[46]
    Sleep   1
    Take Screenshot    086_typeLS.jpg
    Input Text  wnd[1]/usr/ctxtGSO_PTYP-LOW     LS
    Sleep   1
    Take Screenshot    087_typeLS.jpg
    Click Element   wnd[1]/tbar[0]/btn[8]
    Sleep   2
    Take Screenshot    088_typeLS.jpg
    Get No Entries Found Text   wnd[0]/sbar/pane[0]
    Sleep   1  
    Take Screenshot    089_typeLS.jpg

Partner type LI
    Select Node     wnd[0]/shellcont/shell  LI
    Sleep   1
    Take Screenshot    090_typeLI.jpg
    Click Element   wnd[0]/tbar[1]/btn[46]
    Sleep   1
    Take Screenshot    091_typeLI.jpg
    Input Text  wnd[1]/usr/ctxtGSO_PTYP-LOW     LI
    Sleep   1
    Take Screenshot    092_typeLI.jpg
    Click Element   wnd[1]/tbar[0]/btn[8]
    Sleep   2
    Take Screenshot    093_typeLI.jpg
    Get No Entries Found Text   wnd[0]/sbar/pane[0]
    Sleep   1
    Take Screenshot    094_typeLI.jpg

Transaction WE21
    Run Transaction     /nwe21
    Sleep   1
    Take Screenshot    095_WE21.JPG
 
Transactional RFC
    Select Node     wnd[0]/shellcont/shell  A
    Sleep   1
    Take Screenshot    096_rfc.JPG
    Click Element   wnd[0]/mbar/menu[0]/menu[2]
    Sleep   1
    Take Screenshot    097_rfc.JPG
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    098_rfc.JPG

File Port
    Select Node     wnd[0]/shellcont/shell  D
    Sleep   1
    Take Screenshot    099_fileport.jpg
    Click Element   wnd[0]/tbar[1]/btn[20]
    Sleep   1
    Take Screenshot    100_fileport.jpg
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    101_fileport.jpg

ABAP-PI
    Select Node     wnd[0]/shellcont/shell  S
    Sleep   1
    Take Screenshot    102_ABAP-PI.jpg
    Click Element   wnd[0]/tbar[1]/btn[20]
    Sleep   1
    Take Screenshot    103_ABAP-PI.jpg
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    104_ABAP-PI.jpg
XML File
    Select Node     wnd[0]/shellcont/shell  X
    Sleep   1
    Take Screenshot    105_XML.jpg
    Click Element   wnd[0]/tbar[1]/btn[20]
    Sleep   1
    Take Screenshot    106_XML.jpg
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    107_XML.jpg

XML HTTP
    Select Node     wnd[0]/shellcont/shell  H
    Sleep   1
    Take Screenshot    108_HTTP.jpg
    Click Element   wnd[0]/tbar[1]/btn[20]
    Sleep   1
    Take Screenshot    109_HTTP.jpg
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep   1
    Take Screenshot    110_HTTP.jpg

    
