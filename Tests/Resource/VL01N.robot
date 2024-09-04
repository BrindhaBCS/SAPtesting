*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
   

*** Keywords ***
System Logon
    Start Process     ${symvar('SALES_SAP_SERVER')}    
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('SALES_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('SALES_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('SALES_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('SALES_User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Sleep    5
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1

VL01N
    Run Transaction    /nvl01n
	Sleep	2
	Set Focus	wnd[0]/usr/ctxtLIKP-VSTEL
	Sleep	2
	
    Input Text    wnd[0]/usr/ctxtLIKP-VSTEL   ${symvar('shipping_point')} 
	Sleep	2
    Input Text	wnd[0]/usr/ctxtLV50C-VBELN	${symvar('order_number')}
	Send Vkey	0
	Sleep	2

    Click Element	wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\02
	Sleep	2
    Picked Qty Loc Select    ${symvar('quantities')}    ${symvar('sloc')}
    Take Screenshot
	
	Click Element	wnd[0]/tbar[1]/btn[20]
	Sleep	2

    ${outbound_delivery}    Get Value    wnd[0]/sbar
    Log To Console    ${outbound_delivery}
    ${outbound_delivery_number}=    Extract Integer Values    ${outbound_delivery}     
    
    Log    outbound_delivery_number: ${outbound_delivery_number["order_number"]}
    Log    Material_number: ${outbound_delivery_number["material_number"]}
    # Set Global Variable    ${outbound_delivery_number}
    # Log To Console    **gbStart**Copilot_Status_outbounddelivery**splitKeyValue**${outbound_delivery_number["order_number"]}**gbEnd**
    
System Logout
    Run Transaction   /nex
    Sleep    5    