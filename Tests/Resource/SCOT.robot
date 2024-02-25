*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py


*** Keywords ***

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
