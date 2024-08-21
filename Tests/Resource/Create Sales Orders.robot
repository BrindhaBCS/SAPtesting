
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem  
Library    PDF.py     

*** Variables ***    
${department}    wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV45A:4302/ctxtVBKD-ABTNR
${screenshot_directory}     ${OUTPUT_DIR}
# ${PDF_Dir}    C:\\RobotFramework\\SAPtesting\\Output\\Results\\01_VA01.pdf
${PDF_Dir}    ${OUTPUT_DIR}\\01_VA01.pdf

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    5s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}   
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('User_Password')} 
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{User_Password}
    Send Vkey    0
    Take Screenshot    00a_loginpage_VA01.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Take Screenshot    00_multi_logon_handling_VA01.jpg

Generate and Use Random Number
    ${random_number}    Evaluate    random.randint(10000, 99999)    random
    ${purchase_order}    Set Variable    PO#${random_number}
    Log To Console    Generated PO#: ${purchase_order}
    Set Global Variable    ${purchase_order}

Transaction VA01
    Run Transaction     /nVA01
    Sleep    4    
    Input Text    wnd[0]/usr/ctxtVBAK-AUART    ZORM
    Take Screenshot    01_Ordertype.jpg
    Send Vkey    0
    Sleep    4
    Input Text    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/subPART-SUB:SAPMV45A:4701/ctxtKUAGV-KUNNR    ${symvar('sold_party')}  
    Take Screenshot    02_Sold_To_Party.jpg
    Sleep    4              
    Input Text    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/subPART-SUB:SAPMV45A:4701/ctxtKUWEV-KUNNR    ${symvar('ship_party')}             
    Sleep    4
    Take Screenshot    03_Ship_To_Party.jpg
    Send Vkey    0
    Sleep    4
    Select Org label    wnd[1]/usr    ${symvar('org_label')}   
    Take Screenshot    04_Organisation.jpg
    Sleep    4   
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    4  
    Window Handling    wnd[1]    Partner selection    wnd[1]/tbar[0]/btn[0]
    Take Screenshot    05_Partner_selection.jpg
    Sleep    4
    Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
    Take Screenshot    06_Information.jpg
    Sleep    4               
    Input Text    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/txtVBKD-BSTKD    ${purchase_order} 
    Take Screenshot    07_Purchase_order.jpg
    Sleep    4


Selecting multiple materials
    Sleep    4
    Material Select    ${symvar('material')}    ${symvar('quantity')}    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]    wnd[0]/usr/btnBUT3    wnd[0]/sbar/pane[0]
    Sleep    4  
    Take Screenshot    08_Material_select.jpg              
    Click Element    wnd[0]/mbar/menu[1]/menu[12]
    Sleep    4    
    Incomplete Log Handling    wnd[0]/titl    Create Std.Ord.MSD/MISD/IND: Incompletion Log    wnd[0]/tbar[1]/btn[2]    ${department}    VM08    wnd[0]/tbar[0]/btn[3]      
    Take Screenshot    09_Incomplete_log.jpg
    Sleep    4
    ${status}    Get Value    wnd[0]/sbar
    Log To Console    ${status}
    Sleep    2
    Run Keyword If    '${status}' == 'Document is complete'    Save Document
    Take Screenshot    10_Document_save.jpg
    
Save Document
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    2
    Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
    Sleep    4
    Take Screenshot    11_Information.jpg
    ${result}    Get Value   wnd[0]/sbar/pane[0]
    Set Global Variable    ${result}
    Log To Console    ${result}
    ${order_no}    Sales Order Number     wnd[0]/sbar/pane[0]
    Set Global Variable     ${order_no}
    Log To Console    **gbStart**order_no**splitKeyValue**${order_no}**gbEnd**
    Take Screenshot    12_Order_no.jpg
    Sleep    5s
    Click Element    wnd[0]/tbar[0]/btn[3]
    Sleep    5s

System Logout
    Run Transaction   /nex
    Sleep    5        
    Take Screenshot    13_logoutpage.jpg
    Sleep    5
    # Log    ${screenshot_directory}
    # Log    ${output_pdf} 
    Create Pdf    ${screenshot_directory}   ${PDF_Dir}    
    Sleep   2

