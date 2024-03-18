
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    SeleniumLibrary
Library    OperatingSystem        

*** Variables ***    
${sold_party}    2000018360
${ship_party}    2000018360  
${department}    wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV45A:4302/ctxtVBKD-ABTNR
${order_no}        13029138

   
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    SAP_Tcode_Library.Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    SAP_Tcode_Library.Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    SAP_Tcode_Library.Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')}
    Send Vkey    0
    Take Screenshot    00a_loginpage.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Take Screenshot    00_multi_logon_handling.jpg

Generate and Use Random Number
    ${random_number}    Evaluate    random.randint(10000, 99999)    random
    ${purchase_order}    Set Variable    PO#${random_number}
    Log To Console    Generated PO#: ${purchase_order}
    Set Global Variable    ${purchase_order}

Transaction VA01
    Run Transaction     /nVA01
    Sleep    4    
    SAP_Tcode_Library.Input Text    wnd[0]/usr/ctxtVBAK-AUART    ZORM
    Send Vkey    0
    Sleep    4
    SAP_Tcode_Library.Input Text    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/subPART-SUB:SAPMV45A:4701/ctxtKUAGV-KUNNR    ${sold_party}  
    Sleep    4              
    SAP_Tcode_Library.Input Text    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/subPART-SUB:SAPMV45A:4701/ctxtKUWEV-KUNNR    ${ship_party}             
    Sleep    4
    Send Vkey    0
    Sleep    4
    Select Org label    wnd[1]/usr    ${symvar('org_label')}   
    Sleep    4   
    SAP_Tcode_Library.Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    4  
    Window Handling    wnd[1]    Partner selection    wnd[1]/tbar[0]/btn[0]
    Sleep    4
    Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
    Sleep    4               
    SAP_Tcode_Library.Input Text    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/txtVBKD-BSTKD    ${purchase_order} 
    Sleep    4


Selecting multiple materials
    Sleep    4
    Material Select    ${symvar('material')}    ${symvar('quantity')}    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]    wnd[0]/usr/btnBUT3    wnd[0]/sbar/pane[0]
    Sleep    4                
    SAP_Tcode_Library.Click Element    wnd[0]/mbar/menu[1]/menu[12]
    Sleep    4    
    Incomplete Log Handling    wnd[0]/titl    Create Std.Ord.MSD/MISD/IND: Incompletion Log    wnd[0]/tbar[1]/btn[2]    ${department}    VM08    wnd[0]/tbar[0]/btn[3]      
    Sleep    4
    ${status}    SAP_Tcode_Library.Get Value    wnd[0]/sbar
    Log To Console    ${status}
    Sleep    2
    Run Keyword If    '${status}' == 'Document is complete'    Save Document
    
Save Document
    SAP_Tcode_Library.Click Element    wnd[0]/tbar[0]/btn[11]
    Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
    Sleep    4
    ${result}    SAP_Tcode_Library.Get Value   wnd[0]/sbar/pane[0]
    Set Global Variable    ${result}
    Log To Console    ${result}
    ${order_no}    Sales Order Number     wnd[0]/sbar/pane[0]
    Set Global Variable     ${order_no}
    Log To Console    ${order_no}
    Sleep    10s
    SAP_Tcode_Library.Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    5s
Verify idoc
    Run Transaction   /nVA02
    Sleep    10s
    SAP_Tcode_Library.Input Text    wnd[0]/usr/ctxtVBAK-VBELN    ${order_no}
    Sleep    2s
    Send Vkey    0
    SAP_Tcode_Library.Click Element    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/btnBT_OUTPUT
    Sleep    5s
    SAP_Tcode_Library.Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    2s
    Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
    Sleep    5s
    SAP_Tcode_Library.Click Element    wnd[0]/mbar/menu[0]/menu[2]
    Sleep    2s 
    Display sales document

Display sales document 
    Run Transaction   /nVA03
    Sleep    10s
    SAP_Tcode_Library.Input Text    wnd[0]/usr/ctxtVBAK-VBELN    ${order_no}
    Sleep    2s
    Send Vkey    0
    SAP_Tcode_Library.Click Element    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/btnBT_OUTPUT
    Sleep    10s
    ${idoc_status}    Verify The Idoc Jobs    wnd[0]/usr/tblSAPDV70ATC_NAST3    ZBA0    wnd[0]/tbar[1]/btn[26]
    Log To Console   ${idoc_status} 
    
System Logout
    Run Transaction   /nex
    Sleep    10        
    Take Screenshot    logoutpage.jpg
    Sleep    10

Launch Sales Force
    Open Browser    ${symvar('Sales_URL')}    chrome
    Sleep    10s
    Maximize Browser Window
    SeleniumLibrary.Input Text    id:username    ${symvar('login_name')}    
    SeleniumLibrary.Input Password    id:password    ${symvar('login_password')}
    SeleniumLibrary.Click Element     id:Login
    Sleep    10s
    Click Button    //button[@class='slds-button slds-button_neutral search-button slds-truncate']
    Sleep    5s
    SeleniumLibrary.Input Text    //input[@placeholder='Search...']    ${order_no}
    Sleep    5s
    Press Keys   //input[@placeholder='Search...']    ENTER
    Sleep    2s    
    SeleniumLibrary.Click Element    //a[@data-special-link='true']
    Sleep    2s
    Take Screenshot    Document.jpg
    Sleep    2s

Close Sales Force
    Close All Browsers

