*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    ExcelLibrary
Library    String
*** Variables ***
${filename}    ${symvar('Customer_filename')}
${sheetname}    ${symvar('Customer_sheetname')}
${START_ROW}    6
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('Customer_Connection')}
    Sleep   1
    Input Text    wnd[0]/usr/txtRSYST-MANDT     ${symvar('Customer_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('Customer_User_Name')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('Customer_User_Password')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{Customer_User_Password}
    Send Vkey    0
    Sleep    2
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1
System Logout
    Run Transaction   /nex
    Sleep    2
Read Excel Sheet
    [Arguments]    ${filepath}    ${sheetname}    ${rownum}    ${colnum}    
    Open Excel Document    ${filepath}    1
    Get Sheet    ${sheetname}    
    ${data}    Read Excel Cell    ${rownum}    ${colnum}        
    [Return]    ${data}
    Close Current Excel Document
Write Excel Sheet
    [Arguments]    ${filepath}    ${sheetname}    ${rownum}    ${colnum}    ${cell_value}
    Open Excel Document    ${filepath}    1
    Get Sheet    ${sheetname}  
    Write Excel Cell      ${rownum}       ${colnum}     ${cell_value}       ${sheetname}
    Save Excel Document     ${filepath}
    Close Current Excel Document

Kellogs_
    ${ROWS_COUN}=    get total row    ${filename}    ${sheetname}
    Log    Total rows count: ${ROWS_COUN}
    Sleep    1
    ${ROWS_COUNT} =    Evaluate    ${ROWS_COUN} + 1
    FOR    ${row_index}    IN RANGE    6    ${ROWS_COUNT}
        Run Transaction    /nXD01
        Sleep    0.5
        Run Keyword And Ignore Error    Click Element    wnd[1]/usr/btnKONTENGRUPPE_INFO
        Run Keyword And Ignore Error    Set Focus    wnd[2]/usr/tblSAPMF02DTCTRL_KONTENGRUPPEN/txtT077D-KTOKD[0,0]
        Run Keyword And Ignore Error    Click Element    wnd[2]/tbar[0]/btn[0]
        ${Company_Code}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    3
        Run Keyword And Ignore Error    Input Text    wnd[1]/usr/ctxtRF02D-BUKRS    ${Company_Code}
        ${Sales_Organization}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    4
        Run Keyword And Ignore Error    Input Text    wnd[1]/usr/ctxtRF02D-VKORG    ${Sales_Organization}
        ${Distribution Channel}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    5
        Run Keyword And Ignore Error    Input Text    wnd[1]/usr/ctxtRF02D-VTWEG    ${Distribution Channel}
        ${Division}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    6
        Run Keyword And Ignore Error    Input Text    wnd[1]/usr/ctxtRF02D-SPART   ${Division}
        Run Keyword And Ignore Error    Send Vkey    vkey_id=0
        Sleep    1
        ${Title}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    7
        Run Keyword And Ignore Error    Select From List By Label    element_id=wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0201/subAREA1:SAPMF02D:7111/subADDRESS:SAPLSZA1:0300/subCOUNTRY_SCREEN:SAPLSZA1:0301/cmbSZA1_D0100-TITLE_MEDI    value=${Title}
        ${Name}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    8
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0201/subAREA1:SAPMF02D:7111/subADDRESS:SAPLSZA1:0300/subCOUNTRY_SCREEN:SAPLSZA1:0301/txtADDR1_DATA-NAME1    ${name}
        ${search_term}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    9
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0201/subAREA1:SAPMF02D:7111/subADDRESS:SAPLSZA1:0300/subCOUNTRY_SCREEN:SAPLSZA1:0301/txtADDR1_DATA-SORT1    ${search_term}
        ${Street/House_number}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    10
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0201/subAREA1:SAPMF02D:7111/subADDRESS:SAPLSZA1:0300/subCOUNTRY_SCREEN:SAPLSZA1:0301/txtADDR1_DATA-STREET    ${Street/House_number}
        ${Street/House_number_State}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    11
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0201/subAREA1:SAPMF02D:7111/subADDRESS:SAPLSZA1:0300/subCOUNTRY_SCREEN:SAPLSZA1:0301/txtADDR1_DATA-HOUSE_NUM1    ${Street/House_number_State}
        ${Post_Code}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    12
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0201/subAREA1:SAPMF02D:7111/subADDRESS:SAPLSZA1:0300/subCOUNTRY_SCREEN:SAPLSZA1:0301/txtADDR1_DATA-POST_CODE1    ${Post_Code}
        ${Post_Code_State}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    13
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0201/subAREA1:SAPMF02D:7111/subADDRESS:SAPLSZA1:0300/subCOUNTRY_SCREEN:SAPLSZA1:0301/txtADDR1_DATA-CITY1    ${Post_Code_State}
        ${Country}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    14
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0201/subAREA1:SAPMF02D:7111/subADDRESS:SAPLSZA1:0300/subCOUNTRY_SCREEN:SAPLSZA1:0301/ctxtADDR1_DATA-COUNTRY    ${Country}
        ${Region}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    15
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0201/subAREA1:SAPMF02D:7111/subADDRESS:SAPLSZA1:0300/subCOUNTRY_SCREEN:SAPLSZA1:0301/ctxtADDR1_DATA-REGION    ${Region}
        ${Transportation_Zone}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    17
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0201/subAREA1:SAPMF02D:7111/subADDRESS:SAPLSZA1:0300/subCOUNTRY_SCREEN:SAPLSZA1:0301/ctxtADDR1_DATA-TRANSPZONE    ${Transportation_Zone}
        Sleep    1
        Run Keyword And Ignore Error    Send Vkey    vkey_id=0
        Run Keyword And Ignore Error    Send Vkey    vkey_id=0
        Run Keyword And Ignore Error    Click Element    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB02
        Sleep    1
        Run Keyword And Ignore Error    Click Element    wnd[0]/tbar[1]/btn[26]
        Sleep    1
        ${Recon. account}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    18
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7211/ctxtKNB1-AKONT    ${Recon. account}
        Run Keyword And Ignore Error    Click Element    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB02
        ${Terms of payment}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    19
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB02/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7215/ctxtKNB1-ZTERM    ${Terms of payment}
        Run Keyword And Ignore Error    Click Element    wnd[0]/tbar[1]/btn[27]
        ${Sales district}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    20
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7310/ctxtKNVV-BZIRK    ${Sales district}
        ${Sales Office}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    21
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7310/ctxtKNVV-VKBUR    ${Sales Office}
        ${Sales Group}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    22
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7310/ctxtKNVV-VKGRP    ${Sales Group}
        ${Customer group}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    23
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7310/ctxtKNVV-KDGRP    ${Customer group}
        ${Currency}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    24
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7310/ctxtKNVV-WAERS    ${Currency}
        ${PP cust. proc.}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    25
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7310/ctxtKNVV-PVKSM    ${PP cust. proc.}
        ${Price group}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    26
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0200/subAREA2:SAPMF02D:7311/ctxtKNVV-KONDA    ${Price group}
        ${Cust.pric.proc.}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    27
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0200/subAREA2:SAPMF02D:7311/ctxtKNVV-KALKS    ${Cust.pric.proc.}
        ${Price List}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    28
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB01/ssubSUBSC:SAPLATAB:0200/subAREA2:SAPMF02D:7311/ctxtKNVV-PLTYP    ${Price List}
        Run Keyword And Ignore Error    Click Element    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB02
        Sleep    1
        ${Delivery Priority}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    29
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB02/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7315/ctxtKNVV-LPRIO    ${Delivery Priority}
        ${Shipping Conditions}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    30
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB02/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7315/ctxtKNVV-VSBED    ${Shipping Conditions}
        ${Delivering Plant}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    31
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB02/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7315/ctxtKNVV-VWERK    ${Delivering Plant}
        Run Keyword And Ignore Error    Click Element    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB03
        Sleep    1
        ${Invoicing dates}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    32
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB03/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7320/ctxtKNVV-PERFK    ${Invoicing dates}
        ${InvoicingListDates}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    33
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB03/ssubSUBSC:SAPLATAB:0200/subAREA1:SAPMF02D:7320/ctxtKNVV-PERRL    ${InvoicingListDates}
        ${Incoterms1}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    34
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB03/ssubSUBSC:SAPLATAB:0200/subAREA2:SAPMF02D:7321/ctxtKNVV-INCO1    ${Incoterms1}
        ${Incoterms2}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    35
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB03/ssubSUBSC:SAPLATAB:0200/subAREA2:SAPMF02D:7321/txtKNVV-INCO2   ${Incoterms2}
        ${Credit ctrl area}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    36
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB03/ssubSUBSC:SAPLATAB:0200/subAREA2:SAPMF02D:7321/ctxtKNVV-KKBER   ${Credit ctrl area}
        ${Acct assgmt group}    Read Excel Sheet    ${filename}    ${sheetname}    6    37
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB03/ssubSUBSC:SAPLATAB:0200/subAREA3:SAPMF02D:7322/ctxtKNVV-KTGRD   ${Acct assgmt group}
        ${Tax_1}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    38
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB03/ssubSUBSC:SAPLATAB:0200/subAREA4:SAPMF02D:7323/subSUB_STEUER:SAPMF02D:7350/tblSAPMF02DTCTRL_STEUERN/ctxtKNVI-TAXKD[4,0]   ${Tax_1}
        ${Tax_2}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    39
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB03/ssubSUBSC:SAPLATAB:0200/subAREA4:SAPMF02D:7323/subSUB_STEUER:SAPMF02D:7350/tblSAPMF02DTCTRL_STEUERN/ctxtKNVI-TAXKD[4,1]   ${Tax_2}
        ${Tax_3}    Read Excel Sheet    ${filename}    ${sheetname}    ${row_index}    40
        Run Keyword And Ignore Error    Input Text    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB03/ssubSUBSC:SAPLATAB:0200/subAREA4:SAPMF02D:7323/subSUB_STEUER:SAPMF02D:7350/tblSAPMF02DTCTRL_STEUERN/ctxtKNVI-TAXKD[4,2]   ${Tax_3}
        Sleep    1
        Run Keyword And Ignore Error    Click Element    wnd[0]/usr/subSUBTAB:SAPLATAB:0100/tabsTABSTRIP100/tabpTAB05
        Sleep    1
        Run Keyword And Ignore Error    Click Element    wnd[0]/tbar[0]/btn[11]
        Sleep    3
        ${Text}=    Get Value    wnd[0]/sbar/pane[0]
        Sleep    1
        ${customer_number}=    Extract Numeric    ${Text}
        Log To Console    ${customer_number}
        Write Excel Sheet    ${FILENAME}    ${SHEETNAME}    ${ROW_INDEX}    41    ${customer_number}
        Sleep    1

    END
    

    