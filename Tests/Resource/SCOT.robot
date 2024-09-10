*** Settings ***
Library    SAP_Tcode_Library.py
Library    Process

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
Scot_tcodes
    Run Transaction    /nscot
    Sleep    5
    Scot Tree    wnd[0]/shellcont/shell/shellcont[1]/shell        
    Sleep    2
    Double Click On Tree Item    wnd[0]/shellcont/shell/shellcont[1]/shell    24
    Take Screenshot
    Sleep    2
    Take Screenshot
    Sleep    2
SM69_tcodes
    Run Transaction    /nsm69
    Sleep    2
    Take Screenshot
    Sleep    2
    First Visbible Row    wnd[0]/usr/cntlEXT_COM/shellcont/shell    54
    Take Screenshot
    First Visbible Row    wnd[0]/usr/cntlEXT_COM/shellcont/shell    99
    Sleep    2
    Take Screenshot
    Sleep    2

AL11_tcodes
    Run Transaction    /nal11
    Sleep    1
    Take Screenshot    

STRUST_tcodes
    Run Transaction    /nSTRUST
    Sleep    1
    Take Screenshot    
    Scot Tree    wnd[0]/shellcont/shell
    Sleep    1
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLSDFAULT
    Sleep    2
    Scot Tree    wnd[0]/shellcont/shell
    Sleep    1
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCANONYM    
    Sleep    2
    Scot Tree    wnd[0]/shellcont/shell
    Sleep    1
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCWSSE
    Sleep    2
    Scot Tree    wnd[0]/shellcont/shell
    Sleep    1
    Double Click On Tree Item    wnd[0]/shellcont/shell    WSSEDFAULT
    Sleep    1
    Scot Tree    wnd[0]/shellcont/shell
    Sleep    2
    Double Click On Tree Item    wnd[0]/shellcont/shell    WSSEWSSCRT
    Sleep    2
SHMM_tcodes
    Run Transaction    /nshmm
    Sleep    2
    Take Screenshot
    Sleep    1
    Arroww Downn    wnd[0]/usr/tabsTAB_0100/tabpTAB_0100_AREAS/ssubTAB_0100_SCA:SAPMSHM_MONITOR:0101/subVIEW_FUNCTIONS:SAPMSHM_MONITOR:0902/cmbCB_VIEW_SELECTOR    COMPLETE
    Sleep    2
    Take Screenshot    
    Sleep    1
    Scroll    wnd[0]/usr/tabsTAB_0100/tabpTAB_0100_AREAS/ssubTAB_0100_SCA:SAPMSHM_MONITOR:0101/tblSAPMSHM_MONITORTV_AREA_SUMMARY    3
    Sleep    1

Uconcockpit 
    Run Transaction    /nUconcockpit 
    Sleep    1
    Arroww Downn    wnd[0]/usr/cmbP_SCEN    B
    Take Screenshot
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[8]
    Take Screenshot
    Sleep    2
    Take Screenshot  

oAC0
    Run Transaction    /noac0
    Sleep    1
    Scroll    wnd[0]/usr/tblSAPLSCMS_CREPC_SREP    35
    Sleep    1
    Take Screenshot    
    Scroll    wnd[0]/usr/tblSAPLSCMS_CREPC_SREP    70
    Take Screenshot
    Scroll    wnd[0]/usr/tblSAPLSCMS_CREPC_SREP    105
    Sleep    1
    Take Screenshot    
    Scroll    wnd[0]/usr/tblSAPLSCMS_CREPC_SREP    140
    Sleep    1
    Take Screenshot
    Scroll    wnd[0]/usr/tblSAPLSCMS_CREPC_SREP    156
    Sleep    1
    Take Screenshot

SPAD
    # session.findById("wnd[0]").maximize
    Run Transaction    /nspad
    Sleep    1
    Click Element    wnd[0]/mbar/menu[0]/menu[0]
    Take Screenshot
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[71]
    Sleep    1
# session.findById("wnd[1]/usr/txtRSYSF-STRING").text = "LP01"
    Take Screenshot
    Input Text    wnd[1]/usr/txtRSYSF-STRING    LP01
    Sleep    1
    Take Screenshot    
    Set Caret Position    wnd[1]/usr/txtRSYSF-STRING    4
    Sleep    1
    Take Screenshot
# session.findById("wnd[1]/usr/txtRSYSF-STRING").caretPosition = 4
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Scroll Pagedown    wnd[2]/usr/lbl[5,2]
    Take Screenshot    
    Sleep    1
    Set Caret Position    wnd[2]/usr/lbl[5,2]    10
    Sleep    1
    Take Screenshot
    Send Vkey    2
# session.findById("wnd[2]").sendVKey 2
    Set Caret Position    wnd[0]/usr/lbl[1,2]    9
    Send Vkey    2
    Set Caret Position    wnd[0]/usr/txtTSP03D-NAME    4
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    1
    Click Element    wnd[0]/tbar[0]/btn[71]
    Sleep    1
    Input Text    wnd[1]/usr/txtRSYSF-STRING    ZPDF
    Sleep    1
    Set Caret Position    wnd[1]/usr/txtRSYSF-STRING    4
    Sleep    1
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    1
    Click Element    wnd[2]/tbar[0]/btn[0]
    Sleep    1
    
Sldapicust
    Run Transaction    /nSldapicust
    Sleep    2
    Set Current Cell Column    wnd[0]/usr/cntlCONTAINER/shellcont/shell    BUTTON
    Take Screenshot
    Sleep    1
    Press Button Current Cell    wnd[0]/usr/cntlCONTAINER/shellcont/shell
    Take Screenshot
    Sleep    1
    Click Element    wnd[0]/usr/tabsTAB_SM59/tabpSPEC
    Take Screenshot
    Sleep    1
    Click Element    wnd[0]/usr/tabsTAB_SM59/tabpSIGN
    Take Screenshot
    Sleep    1

WE20
    Run Transaction    we20
    Sleep    1

SAP LOGOUT
    Run Transaction    /nex
    Sleep    2