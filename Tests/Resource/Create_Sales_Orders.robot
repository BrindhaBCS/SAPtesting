
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

Generate and Use Random Number
    ${random_number}    Evaluate    random.randint(10000, 99999)    random
    ${purchase_order}    Set Variable    PO#${random_number}
    Log To Console    Generated PO#: ${purchase_order}
    Set Global Variable    ${purchase_order}

Transaction VA01
    Run Transaction     /nVA01
    Input Text    wnd[0]/usr/ctxtVBAK-AUART    ZOR
    Send Vkey    0
    Input Text    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/subPART-SUB:SAPMV45A:4701/ctxtKUAGV-KUNNR    ${symvar('sold_party')}  
    Input Text    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/subPART-SUB:SAPMV45A:4701/ctxtKUWEV-KUNNR    ${symvar('ship_party')}             
    Input Text    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/txtVBKD-BSTKD    ${purchase_order} 

Selecting multiple materials    
    Quantity Select    ${symvar('material')}    ${symvar('quantity')}   ${symvar('amount')}     
      
Save Document
    Click Element    wnd[0]/tbar[0]/btn[11]
    Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
    ${result}    Get Value   wnd[0]/sbar/pane[0]
    Set Global Variable    ${result}
    Log To Console    ${result}
    ${order_no}    Extract Number     wnd[0]/sbar/pane[0]
    Set Global Variable     ${order_no}
    Log    ${order_no}
    Log To Console    **gbStart**order_no**splitKeyValue**${order_no}**gbEnd**
    Click Element    wnd[0]/tbar[0]/btn[3]

System Logout
    Run Transaction   /nex
  

