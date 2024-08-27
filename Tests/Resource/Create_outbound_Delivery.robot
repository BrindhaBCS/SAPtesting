
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem  
Library    PDF.py     

*** Keywords ***
System Logon
    Start Process     ${symvar('SALES_SERVER')}     
    Connect To Session
    Open Connection    ${symvar('SALES_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('SALES_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('SALES_User_Name')}   
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('SALES_User_Password')} 
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SALES_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 

System Logout
    Run Transaction   /nex
    
Transaction VL01N
    Run Transaction     /nVL01N
    Input Text    wnd[0]/usr/ctxtLIKP-VSTEL    CH01
    Input Text    wnd[0]/usr/ctxtLV50C-VBELN    ${symvar('order_no')}
    Send Vkey    0    window=0
    Click Element    wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\02
    Picked Qty Loc Select    ${symvar('quantity')}    ${symvar('location')}
    Click Element    wnd[0]/tbar[1]/btn[20]
    ${result}    Get Value   wnd[0]/sbar/pane[0]
    Set Global Variable    ${result}
    Log To Console    ${result}
    ${outbound_delivery}    Extract Number    wnd[0]/sbar/pane[0]
    Set Global Variable     ${outbound_delivery}
    Log To Console    **gbStart**outbound_delivery**splitKeyValue**${outbound_delivery}**gbEnd**
