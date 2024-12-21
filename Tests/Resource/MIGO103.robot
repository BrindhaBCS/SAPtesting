***settings***
Library    Process
library    SAP_Tcode_Library.py

*** Variables ***
${back}    /app/con[0]/ses[0]/wnd[0]/tbar[0]/btn[15]

${purchase_order}     ${symvar('Purchase_order')}
${truck_no}     ${symvar('Truck_No')}
*** Keywords ***
SAP_LOGIN
    Start Process     ${symvar('MIGO_SAP_SERVER')}    
    Sleep    10s
    Connect To Session
    Open Connection    ${symvar('MIGO_SID')}  
    Sleep    5  
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MIGO_clientno')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MIGO_TS4Username')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MIGO_TS4password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{MIGO_TS4password}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
MMIGO103
    Run Transaction    MIGO
    Sleep    5
    ${validate_detail_data}=    Run Keyword And Return Status    Element Should Be Present    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_ITEMDETAIL:SAPLMIGO:0302/btnBUTTON_DETAIL
    Run Keyword If    ${validate_detail_data} == True    Click Element    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_ITEMDETAIL:SAPLMIGO:0302/btnBUTTON_DETAIL
    Set Focus	wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_FIRSTLINE:SAPLMIGO:0011/cmbGODYNPRO-ACTION
    Sleep    2
	Select From List By key    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_FIRSTLINE:SAPLMIGO:0011/cmbGODYNPRO-ACTION    A01
    Sleep    2
    Set Focus	wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_FIRSTLINE:SAPLMIGO:0011/cmbGODYNPRO-REFDOC
    Sleep    2
	Select From List By key	wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_FIRSTLINE:SAPLMIGO:0011/cmbGODYNPRO-REFDOC	R01
    Sleep    2
    Input Text	wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_FIRSTLINE:SAPLMIGO:0011/subSUB_FIRSTLINE_REFDOC:SAPLMIGO:2000/ctxtGODYNPRO-PO_NUMBER	${purchase_order}
	Send Vkey	0
    Clear Field Text    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_FIRSTLINE:SAPLMIGO:0011/ctxtGODEFAULT_TV-BWART
    Sleep    2
    Input Text    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_FIRSTLINE:SAPLMIGO:0011/ctxtGODEFAULT_TV-BWART	103    
    Sleep    2
    Input Text    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_HEADER:SAPLMIGO:0101/subSUB_HEADER:SAPLMIGO:0100/tabsTS_GOHEAD/tabpOK_GOHEAD_GENERAL/ssubSUB_TS_GOHEAD_GENERAL:SAPLMIGO:0110/txtGOHEAD-LFSNR    ${truck_no}
    Sleep    2
    Click Element	wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0003/subSUB_ITEMDETAIL:SAPLMIGO:0301/btnBUTTON_ITEMDETAIL
    Sleep    2
    Select Checkbox    wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_ITEMLIST:SAPLMIGO:0200/tblSAPLMIGOTV_GOITEM/chkGOITEM-TAKE_IT[3,0] 
    Sleep    2
    Click Element    wnd[0]/tbar[1]/btn[23]
    Sleep    2
    ${status}=    Get Status Pane    wnd[0]/sbar/pane[0] 
    Set Global Variable    ${status}   
    Click Element	wnd[0]/usr/ssubSUB_MAIN_CARRIER:SAPLMIGO:0002/subSUB_ITEMDETAIL:SAPLMIGO:0302/btnBUTTON_DETAIL
    Sleep    2
    Take Screenshot    MMIGO103.jpg

close
    Click Element    ${back}
    Click Element    ${back}
    Sleep    2
    Click Element    /app/con[0]/ses[0]/wnd[1]/usr/btnSPOP-OPTION1
    Sleep    2


