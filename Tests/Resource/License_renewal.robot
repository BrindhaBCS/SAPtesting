*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
 
*** Keywords ***
System Logon
    Start Process     ${symvar('SAP_SERVER')}    
    # Sleep    5
    Connect To Session
    Open Connection    ${symvar('license_connection')}
    # Sleep    2    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('license_client')}
    # Sleep    2
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('license_user')}
    # Sleep    2
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('sap_pass')}      
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{SAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]
    # Sleep   5
   
System Logout
    Run Transaction   /nex

Get License Data
    Run Transaction    /nslicense
    ${hardware_key}    Get Value    wnd[0]/usr/txtCUSTKEY
    ${installation_no}    Get Value    wnd[0]/usr/txtINSTNR
    ${system_no}    Get Value    wnd[0]/usr/txtSYSTEMID
    ${rows}    Get Row Count    wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL
    # Log To Console    row count is:${rows}
    FOR    ${row}    IN RANGE    0    ${rows}
        ${key}    Get Value    wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-HWKEY[2,${row}]
        Exit For Loop If    '${key}' == '___________'
        IF    '${key}' == '${hardware_key}'
            ${product}    Get License Product    wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-SW_PRODUCT[3,${row}]
            # Log To Console    product is: ${product}
            IF    '${product}' == 'Maintenance'
                ${maintenance_expiry_date}    Get Value    wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-END_DATE[6,${row}]
                ${maintenance_exp}    Calculate Date Difference    ${maintenance_expiry_date}
                Log To Console    maintenance expiry: ${maintenance_exp}
            ELSE IF    '${product}' == 'NetWeaver'
                ${NW_expiry_date}    Get Value    wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/tblSAPMSLICLIKEYLIST_CONTROL/txtLIKEY_TABLE-END_DATE[6,${row}]
                ${NW_exp}    Calculate Date Difference    ${NW_expiry_date}
                Log To Console    NW expiry: ${NW_exp}
            END
        ELSE
            Log    ${key} is not active            
        END
    END
    Log To Console    **gbStart**hardware_key**splitKeyValue**${hardware_key}**gbEnd**
    Log To Console    **gbStart**installation_no**splitKeyValue**${installation_no}**gbEnd**
    Log To Console    **gbStart**system_no**splitKeyValue**${system_no}**gbEnd**
    Log To Console    **gbStart**maintenance_expiry**splitKeyValue**${maintenance_exp}**gbEnd**
    Log To Console    **gbStart**netweaver_expiry**splitKeyValue**${NW_exp}**gbEnd**

License Renewal
    Run Transaction    /nslicense
    Click Element    wnd[0]/usr/tabsTABSTRIP_1000/tabpLOCAL_LIKEYS/ssubACTIVE_TAB:SAPMSLIC:3020/btnINSTALL
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${EMPTY}
    Input Text    wnd[1]/usr/ctxtDY_PATH    ${symvar('uploading_path')}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${EMPTY}
    Input Text    wnd[1]/usr/ctxtDY_FILENAME    ${symvar('License_file')}
    Click Element    wnd[1]/tbar[0]/btn[0]
    Click Element    wnd[1]/tbar[0]/btn[0]
    Log To Console      **gbStart**copilot_status**splitKeyValue**License Renewed Successfully**gbEnd**