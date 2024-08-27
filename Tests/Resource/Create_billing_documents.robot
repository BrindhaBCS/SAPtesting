
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem  

*** Keywords ***
System Logon
    Start Process     ${symvar('SALES_SERVER')}     
    Connect To Session
    Open Connection    ${symvar('SALES_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('SALES_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('SALES_User_Name')}   
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')} 
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SALES_User_Password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 

System Logout
    Run Transaction   /nex

Transaction VF01
    Run Transaction     /nVF01
    Document Entry    ${symvar('outbound_delivery')}
    Send Vkey    0
    Click Element    wnd[0]/tbar[0]/btn[11]
    ${result}    Get Value   wnd[0]/sbar/pane[0]
    Set Global Variable    ${result}
    Log To Console    ${result}
    ${document_no}    Extract Number     wnd[0]/sbar/pane[0]
    Set Global Variable     ${document_no}
    Log To Console    **gbStart**Document_number**splitKeyValue**${document_no}**gbEnd**
        

