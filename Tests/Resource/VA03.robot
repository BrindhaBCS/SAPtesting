
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem    
Library    PDF.py    

*** Variables ***      
${department}    wnd[0]/usr/tabsTAXI_TABSTRIP_HEAD/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV45A:4302/ctxtVBKD-ABTNR
${order_no}        13029138
${screenshot_directory}     ${OUTPUT_DIR}
${PDF_Dir}    C:\\SAP_Testing\\SAPtesting\\Output\\Results\\02_VA03.pdf
# ${output_pdf}   ${OUTPUT_DIR}\\VA03.pdf

*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}     
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('User_Name')}    
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{User_Password}
    Send Vkey    0
    Take Screenshot    13a_loginpage_VA03.jpg
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
    Take Screenshot    13b_multi_logon_handling_VA01.jpg

Verify idoc
    Run Transaction   /nVA02
    Sleep    10s
    Input Text    wnd[0]/usr/ctxtVBAK-VBELN    ${symvar('order_no')}
    # Input Text    wnd[0]/usr/ctxtVBAK-VBELN    ${order_no}
    Take Screenshot    13_Order_input.jpg
    Sleep    2s
    Send Vkey    0
    Click Element    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/btnBT_OUTPUT
    Take Screenshot    14_Verify1.jpg
    Sleep    5s
    Click Element    wnd[0]/tbar[0]/btn[11]
    Take Screenshot    15_Verify1.jpg
    Sleep    2s
    Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
    Take Screenshot    16_Information1.jpg
    Sleep    5s
    Click Element    wnd[0]/mbar/menu[0]/menu[2]
    Take Screenshot    17_Information2.jpg
    Sleep    2s 
    Display sales document

Display sales document 
    Run Transaction   /nVA03
    Sleep    10s
    Input Text    wnd[0]/usr/ctxtVBAK-VBELN    ${symvar('order_no')}
    # Input Text    wnd[0]/usr/ctxtVBAK-VBELN    ${order_no}
    Take Screenshot    18_Sales_doc.jpg
    Sleep    2s
    Send Vkey    0
    Click Element    wnd[0]/usr/subSUBSCREEN_HEADER:SAPMV45A:4021/btnBT_OUTPUT
    Take Screenshot    19_Sales_doc_1.jpg
    Sleep    10s
    ${idoc_status}    Verify The Idoc Jobs    wnd[0]/usr/tblSAPDV70ATC_NAST3    ZBA0    wnd[0]/tbar[1]/btn[26]
    Log To Console   ${idoc_status} 
    Take Screenshot    19_Verify_idoc.jpg
    
System Logout
    Run Transaction   /nex
    Sleep    10        
    Take Screenshot    20_logoutpage_VA03.jpg
    Sleep    10
    Create Pdf    ${screenshot_directory}   ${PDF_Dir}    
    Sleep   2

