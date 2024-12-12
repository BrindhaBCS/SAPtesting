*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    DateTime
*** Variables ***
${current_date}    ${symvar('MIRO_Invoice_Date')}
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    1
    Connect To Session
    Open Connection    ${symvar('MIRO_Invoice_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('MIRO_Invoice_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MIRO_Invoice_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MIRO_Invoice_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{MIRO_Invoice_User_Password}
    Send Vkey    0
    Sleep    0.5
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
System Logout
    Run Transaction   /nex
MIRO_INVOICE
    Run Transaction    /nMIRO
    Sleep    0.5 seconds
    ${date}    Get Current Date    result_format=%d.%m.%Y
    Input Text    wnd[1]/usr/ctxtBKPF-BUKRS    text=${symvar('MIRO_Invoice_Company_Code')}
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    time_=1 seconds
    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/ctxtINVFO-BLDAT    ${symvar('MIRO_Invoice_Date')}
    # ${p}    India To European Numeric    value=${symvar('MIRO_Invoice_Total_Amount')}
    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/txtINVFO-WRBTR    ${symvar('MIRO_Invoice_Total_Amount')}
    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/ctxtINVFO-BUPLA    IN01
    Select From List By Label    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/cmbINVFO-MWSKZ    value=Z1 (input 0%)  
    Select Checkbox    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_TOTAL/ssubHEADER_SCREEN:SAPLFDCB:0010/chkINVFO-XMWST
    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/subITEMS:SAPLMR1M:6010/tabsITEMTAB/tabpITEMS_PO/ssubTABS:SAPLMR1M:6020/subREFERENZBELEG:SAPLMR1M:6211/ctxtRM08M-EBELN    ${symvar('MIRO_Invoice_Reference_Number')}
    Send Vkey    vkey_id=0
    Clear Field Text    [0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/subITEMS:SAPLMR1M:6010/tabsITEMTAB/tabpITEMS_PO/ssubTABS:SAPLMR1M:6020/subITEM:SAPLMR1M:6310/tblSAPLMR1MTC_MR1M/txtDRSEG-WRBTR[1,0]
    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/subITEMS:SAPLMR1M:6010/tabsITEMTAB/tabpITEMS_PO/ssubTABS:SAPLMR1M:6020/subITEM:SAPLMR1M:6310/tblSAPLMR1MTC_MR1M/txtDRSEG-WRBTR[1,0]    ${symvar('MIRO_Invoice_Total_Amount')}
    Clear Field Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/subITEMS:SAPLMR1M:6010/tabsITEMTAB/tabpITEMS_PO/ssubTABS:SAPLMR1M:6020/subITEM:SAPLMR1M:6310/tblSAPLMR1MTC_MR1M/txtDRSEG-MENGE[2,0]
    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/subITEMS:SAPLMR1M:6010/tabsITEMTAB/tabpITEMS_PO/ssubTABS:SAPLMR1M:6020/subITEM:SAPLMR1M:6310/tblSAPLMR1MTC_MR1M/txtDRSEG-MENGE[2,0]    ${symvar('MIRO_Invoice_Quantity')}
    Click Element    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_PAY
    Input Text    wnd[0]/usr/subHEADER_AND_ITEMS:SAPLMR1M:6005/tabsHEADER/tabpHEADER_PAY/ssubHEADER_SCREEN:SAPLFDCB:0020/ctxtINVFO-ZFBDT    ${date}
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    time_=0.2 seconds
    ${i}    Get Value    wnd[0]/sbar/pane[0]
    ${y}    Extract Numeric    data=${i}
    IF    '${i}' == 'Net due date on ${date} is in the past'
        Send Vkey    vkey_id=0
        Click Element    wnd[0]/tbar[0]/btn[11]
        Log To Console    **gbStart**MIRO_Invoice_Doc**splitKeyValue**${y}**gbEnd**
    ELSE
        Log To Console    **gbStart**MIRO_Invoice_Doc**splitKeyValue**${y}**gbEnd**  
    END
    Run Keyword And Ignore Error    Click Element    element_id=wnd[0]/tbar[1]/btn[34]
    Sleep    time_=0.2 seconds
    Run Keyword And Ignore Error    Click Element    element_id=wnd[1]/tbar[0]/btn[0]
    Sleep    time_=0.2 seconds
    Run Keyword And Ignore Error    Click Element    element_id=wnd[0]/tbar[1]/btn[8]
    Sleep    time_=0.2 seconds
    Run Keyword And Ignore Error     Select And Double Click Row    element_path=wnd[1]/usr/cntlCONTAINER/shellcont/shell    row_index=0
    Sleep    time_=0.2 seconds
    ${z}    Get Value    element_id=wnd[0]/usr/txtBKPF-BELNR
    Log To Console    **gbStart**MIRO_Invoice_Post_Doc**splitKeyValue**${z}**gbEnd** 
    



