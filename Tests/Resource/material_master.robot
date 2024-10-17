*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    ExcelLibrary



*** Keywords ***

Read Excel Sheet
    [Arguments]    ${Excel_file}    ${sheetname}    ${rownum}    ${colnum}    
    Open Excel Document    ${Excel_file}    1
    Get Sheet    ${sheetname}    
    ${data}    Read Excel Cell    ${rownum}    ${colnum}        
    [Return]    ${data}
    Log To Console    ${data}
    Close Current Excel Document



Write Excel
    [Arguments]    ${filepath}    ${sheetname}    ${rownum}    ${colnum}    ${cell_value}
    Open Excel Document    ${filepath}    1
    Get Sheet    ${sheetname}  
    Write Excel Cell      ${rownum}       ${colnum}     ${cell_value}       ${sheetname}
    Save Excel Document     ${filepath}
    Close Current Excel Document    

System Logon
    Start Process     ${symvar('MASTER_SAP_SERVER')}    
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('MASTER_SAP_connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('MASTER_Client_Id')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('MASTER_User_Name')}    
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('MASTER_User_Password')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Sleep    5
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    Sleep   1
Material_master   
    ${total_row}    Get Material Count    ${symvar('Excel_file')}
    ${rows}=    Evaluate    ${total_row} + 1
    Log To Console    ${rows}
    FOR    ${initial_row}    IN RANGE    2    ${rows}
        Run Transaction    /nmm01
        Sleep    2
        ${industry_sector}    Read Excel Sheet    ${symvar('Excel_file')}    ${symvar('Sheet_name')}   ${initial_row}    1 
        Run Keyword And Ignore Error    Log To Console    ${industry_sector}
        Run Keyword And Ignore Error    Select From List By Key    wnd[0]/usr/cmbRMMG1-MBRSH    ${industry_sector}
        ${Material_type}    Read Excel Sheet    ${symvar('Excel_file')}    ${symvar('Sheet_name')}   ${initial_row}    2 
        Run Keyword And Ignore Error    Select From List By Key    wnd[0]/usr/cmbRMMG1-MTART	    ${Material_type}
        Run Keyword And Ignore Error    Click Element	wnd[0]/tbar[1]/btn[5]
        ${rowcoun} =    Run Keyword And Ignore Error    Get Row Count    wnd[1]/usr/tblSAPLMGMMTC_VIEW
        ${rowcount}    Set Variable    ${rowcoun[1]}
        Run Keyword And Ignore Error    log to console    ${rowcount}
        ${row_index}    Set Variable    0
        ${visible_rows}    Set Variable    17  
        FOR  ${value}  IN RANGE     0    ${rowcount}
            ${cell_id}=  Set Variable    wnd[1]/usr/tblSAPLMGMMTC_VIEW/txtMSICHTAUSW-DYTXT[0,${row_index}]
            Run Keyword And Ignore Error  Set Focus    ${cell_id}
            ${is_row_visible}    Run Keyword And Return Status    Get Table Cell Text    wnd[1]/usr/tblSAPLMGMMTC_VIEW    ${row_index}    0
            Run Keyword If    "${is_row_visible}" == "False"    Exit For Loop
            ${Data}=    Get Table Cell Text    wnd[1]/usr/tblSAPLMGMMTC_VIEW    ${row_index}    0
            Run Keyword If    "${Data}" in "@{symvar('search_comp')}"    Select Table Row    wnd[1]/usr/tblSAPLMGMMTC_VIEW    ${value}
            ${row_index}=  Evaluate  ${row_index} + 1
            IF  ${row_index} >= ${visible_rows}
                ${row_index}    Set variable     1  
                ${scroll_position}    Evaluate    ${row_index}*16
                Scroll     wnd[1]/usr/tblSAPLMGMMTC_VIEW    ${scroll_position}
                Sleep  2  
            END
        END
        Run Keyword And Ignore Error    sendVKey	0
        ${plant}    Read Excel Sheet    ${symvar('Excel_file')}    ${symvar('Sheet_name')}    ${initial_row}    10
        Run Keyword And Ignore Error    Input Text	wnd[1]/usr/ctxtRMMG1-WERKS	${plant}
        ${storage_loc}    Read Excel Sheet    ${symvar('Excel_file')}    ${symvar('Sheet_name')}    ${initial_row}    11
        Run Keyword And Ignore Error    Input Text	wnd[1]/usr/ctxtRMMG1-LGORT	${storage_loc}
        Run Keyword And Ignore Error    sendVKey	0
        ${window_exis}    Run Keyword And Ignore Error    Run Keyword And Return Status    Element Should Be Present    wnd[2]
        ${window_exist}    Set Variable    ${window_exis[1]}
        IF    '${window_exist}' == 'True'
            ${popup_valu}    Run Keyword And Ignore Error    Get Value   wnd[2]/usr/txtMESSTXT1  
            ${popup_value}    Set Variable    ${popup_valu[1]}
            Write Excel    ${symvar('Excel_file')}    ${symvar('Sheet_name')}    ${initial_row}    21    ${popup_value}
            Run Keyword And Ignore Error    Close Window    wnd[2]
            Run Keyword And Ignore Error    Close Window    wnd[1]
            Run Keyword And Ignore Error    Continue For Loop
        ELSE 
            ${material_description}    Read Excel Sheet    ${symvar('Excel_file')}    ${symvar('Sheet_name')}    ${initial_row}    12    
            Run Keyword And Ignore Error    Input Text	wnd[0]/usr/tabsTABSPR1/tabpSP01/ssubTABFRA1:SAPLMGMM:2004/subSUB1:SAPLMGD1:1002/txtMAKT-MAKTX	${material_description} 
            ${Base_unit_of_Measure}    Read Excel Sheet    ${symvar('Excel_file')}    ${symvar('Sheet_name')}    ${initial_row}    13
            Run Keyword And Ignore Error    Input Text	wnd[0]/usr/tabsTABSPR1/tabpSP01/ssubTABFRA1:SAPLMGMM:2004/subSUB2:SAPLMGD1:2001/ctxtMARA-MEINS	${Base_unit_of_Measure}
            ${Material_group}    Read Excel Sheet    ${symvar('Excel_file')}    ${symvar('Sheet_name')}    ${initial_row}    14
            Run Keyword And Ignore Error    Input Text	wnd[0]/usr/tabsTABSPR1/tabpSP01/ssubTABFRA1:SAPLMGMM:2004/subSUB2:SAPLMGD1:2001/ctxtMARA-MATKL	${Material_group}
        END   
            FOR    ${index}    IN RANGE    0    10
                Run Keyword And Ignore Error    Send VKey               0
                Run Keyword And Ignore Error    Sleep    1
                ${is_present}    Run Keyword And Return Status    Element Should Be Present    wnd[0]/usr/tabsTABSPR1/tabpSP09/ssubTABFRA1:SAPLMGMM:2000/subSUB2:SAPLMGD1:2301/ctxtMARC-EKGRP
                Run Keyword And Ignore Error    Exit For Loop If    ${is_present}
            END
            ${purchasing_group}    Read Excel Sheet    ${symvar('Excel_file')}    ${symvar('Sheet_name')}   ${initial_row}    15 
            Run Keyword And Ignore Error    Input Text   wnd[0]/usr/tabsTABSPR1/tabpSP09/ssubTABFRA1:SAPLMGMM:2000/subSUB2:SAPLMGD1:2301/ctxtMARC-EKGRP    ${purchasing_group}
            Run Keyword And Ignore Error    Sleep    1
            FOR    ${index}    IN RANGE    0    10
                Run Keyword And Ignore Error    Send VKey    0
                Sleep    1
                ${is_present}    Run Keyword And Ignore Error    Run Keyword And Return Status    Element Should Be Present    wnd[0]/usr/tabsTABSPR1/tabpSP24/ssubTABFRA1:SAPLMGMM:2000/subSUB2:SAPLMGD1:2800/subSUB2:SAPLMGD1:2802/ctxtMBEW-BKLAS
                Run Keyword And Ignore Error    Exit For Loop If    ${is_present}
            END
            ${valuation_class}    Read Excel Sheet    ${symvar('Excel_file')}    ${symvar('Sheet_name')}   ${initial_row}    17
            Run Keyword And Ignore Error    Input Text    wnd[0]/usr/tabsTABSPR1/tabpSP24/ssubTABFRA1:SAPLMGMM:2000/subSUB2:SAPLMGD1:2800/subSUB2:SAPLMGD1:2802/ctxtMBEW-BKLAS    ${valuation_class}
            Sleep    1
            ${price_control}    Read Excel Sheet    ${symvar('Excel_file')}    ${symvar('Sheet_name')}   ${initial_row}    18
            Run Keyword And Ignore Error    Input Text    wnd[0]/usr/tabsTABSPR1/tabpSP24/ssubTABFRA1:SAPLMGMM:2000/subSUB2:SAPLMGD1:2800/subSUB2:SAPLMGD1:2802/ctxtMBEW-VPRSV    ${price_control}
            Sleep    1
            ${price_unit}    Read Excel Sheet    ${symvar('Excel_file')}    ${symvar('Sheet_name')}   ${initial_row}    19
            Run Keyword And Ignore Error    Input Text    wnd[0]/usr/tabsTABSPR1/tabpSP24/ssubTABFRA1:SAPLMGMM:2000/subSUB2:SAPLMGD1:2800/subSUB2:SAPLMGD1:2802/txtMBEW-PEINH    ${price_unit}
            Sleep    1
            ${moving_price}    Read Excel Sheet    ${symvar('Excel_file')}    ${symvar('Sheet_name')}   ${initial_row}    20
            Run Keyword And Ignore Error    Input Text    wnd[0]/usr/tabsTABSPR1/tabpSP24/ssubTABFRA1:SAPLMGMM:2000/subSUB2:SAPLMGD1:2800/subSUB2:SAPLMGD1:2802/txtMBEW-VERPR    ${moving_price}
            Sleep    1
            FOR    ${index}    IN RANGE    0    10
                Run Keyword And Ignore Error    Send VKey    0
                Run Keyword And Ignore Error    Sleep    1
                ${is_present}    Run Keyword And Ignore Error        Run Keyword And Return Status    Element Should Be Present    wnd[0]/usr/tabsTABSPR1/tabpSP25
                Run Keyword And Ignore Error    Send Vkey    11
                Run Keyword And Ignore Error    Exit For Loop If    ${is_present}
            END
        ${material_status}    Get Value    wnd[0]/sbar
        IF  '${material_status}' == 'Choose a valid function'
            Write Excel    ${symvar('Excel_file')}    ${symvar('Sheet_name')}    ${initial_row}    21    ${material_status}
            Sleep    1
        ELSE
            ${material_number}=    Extract Order Number    ${material_status}
            Log    ${material_number}
            Set Global Variable    ${material_number}
            Log To Console    **gbStart**Copilot_Status**splitKeyValue**${material_number}**gbEnd**
            Write Excel    ${symvar('Excel_file')}    ${symvar('Sheet_name')}    ${initial_row}    21    ${material_number}
        END
    END
    

System Logout
    Run Transaction     /nex
    Sleep   5
