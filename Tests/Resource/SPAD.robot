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
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}  
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}  
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

SPAD
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
    Sleep   6s
    
LOCL Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    Ctrl+A
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    LOCL
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   5s
    Take Screenshot     SPAD_3.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   6s

LP01 Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    Ctrl+A
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    LP01
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   5s
    Take Screenshot     SPAD_4.jpg
    Click Element   wnd[0]/tbar[0]/btn[3]
    Sleep   6s
    
ZPDF Screenshot
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    Ctrl+A
    Input Text      wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/ctxtRSPOSEL-DEVICE    ZPDF
    Click Element   wnd[0]/usr/tabsSELECTIONS/tabpSEL1/ssubPAGE:SAPMSPAD:1041/btn%#AUTOTEXT001
    Sleep   5s
    Take Screenshot     SPAD_5.jpg
    Sleep    6