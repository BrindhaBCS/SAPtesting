*** Settings ***    
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

*** Keywords ***
System Logon
    Start Process    ${symvar('ABAP_SAP_SERVER')}
    Connect To Session
    Open Connection     ${symvar('ABAP_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABAP_CLIENT')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABAP_USER')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABAP_PASSWORD')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{ABAP_PASSWORD} 
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 

System Logout
    Run Transaction   /nex

Verify parameter in RZ10
    Run Transaction    /nRZ10
    Send Vkey    4    window=0
    Sleep    2
    Select Profile Label    wnd[1]/usr    DEFAULT    
    Sleep    2
    Click Element   wnd[1]/tbar[0]/btn[0]
    Sleep    2
    Select Radio Button    wnd[0]/usr/radSPFL1010-EXPERT
    Sleep    2
    Click Element    wnd[0]/usr/btnEDIT_PUSH
    Sleep    2



    # Click Element    wnd[0]/tbar[1]/btn[5]
    # Sleep    2
    # Input Text    wnd[0]/usr/ctxtPARAMETER_INTERNAL-PARNAME    ssl/ciphersuites
    # Sleep    2
    # Input Text    wnd[0]/usr/sub:SAPLSPF2:0030[0]/txtPARAMETER_INT_VALUES-PVALUE[0,0]    135:PFS:HIGH::EC_X25519:EC_P256:EC_HIGH
    # Sleep    2
    # Click Element    wnd[0]/tbar[1]/btn[16]
    # Sleep    2
    # Click Element    wnd[0]/tbar[1]/btn[18]
    Sleep    2