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

SMLG
    Run Transaction     /nSMLG
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
    Sleep    6

SMLG Load Distributions
    Click Element   wnd[0]/tbar[1]/btn[5]
    Sleep   10s
    Take Screenshot     SMLG_5.jpg
    Sleep    6