*** Settings ***    
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
Library    ExcelLibrary
Library    openpyxl

*** Variables ***
@{parameters}    ssl/ciphersuites    ssl/client_ciphersuites    icm/HTTPS/client_sni_enabled    ssl/client_sni_enabled    SETENV_26    SETENV_27    SETENV_28
@{values}   135:PFS:HIGH::EC_X25519:EC_P256:EC_HIGH    150:PFS:HIGH::EC_X25519:EC_P256:EC_HIGH    TRUE    TRUE    SECUDIR=$(DIR_INSTANCE)$(DIR_SEP)sec    SAPSSL_CLIENT_CIPHERSUITES=150:PFS:HIGH::EC_X25519:EC_P256:EC_HIGH    SAPSSL_CLIENT_SNI_ENABLED=TRUE 
@{SAP_Note}    3421256    3374186    3312428    3281776
${filepath}
${sheetname}    Sheet1
${Basis_success}    SAP BASIS version patch level met the criteria
${Basis_fail}    SAP BASIS version patch level too low. Need to Patch SAP BASIS Either 7.40 SP16 or higher
${SAP_UI_success}    SAP UI version patch level met the criteria
${SAP_UI_fail}    SAP BASIS and SAP UI version patch level too low. Need to Patch SAP_UI Either 740 SP15 or higher
${ST_PI_Success}    ST-PI patch version met the criteria
${ST_PI_Fail}    Latest patch of ST-PI needs to be applied
${parameter_Pass}    Profile Parameters are set
${parameter_Fail}    Profile parameter are not in place. Need to add them
${certificate_Pass}    SSL Certificates are available in the System
${certificate_Fail}    SSL Certificate need to be added to the System
${Snote_Pass}
${Snote_Fail}

*** Keywords ***
System Logon
    Start Process    ${symvar('ABAP_SAP_SERVER')}
    Connect To Session
    Open Connection     ${symvar('ABAP_Connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABAP_CLIENT')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABAP_USER')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABAP_PASSWORD')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{ABAP_PASSWORD} 
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 

System Logout
    Run Transaction   /nex
Write Excel
    [Arguments]    ${filepath}    ${sheetname}    ${rownum}    ${colnum}    ${cell_value}
    Open Excel Document    ${filepath}    1
    Get Sheet    ${sheetname}  
    Write Excel Cell      ${rownum}       ${colnum}     ${cell_value}       ${sheetname}
    Save Excel Document     ${filepath}
    Close Current Excel Document
SAP BASIS Release
    Click Element    wnd[0]/mbar/menu[4]/menu[11]
    Click Element    wnd[1]/usr/btnPRELINFO
    ${version}    Software Component Version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    SAP_BASIS
    IF    '${version}' >= '750'
        Write Excel    ${filepath}    ${sheetname}    2    2    ${Basis_success}
        Write Excel    ${filepath}    ${sheetname}    2    3    Passed
    ELSE
        Write Excel    ${filepath}    ${sheetname}    2    2    ${Basis_fail}
        Write Excel    ${filepath}    ${sheetname}    2    3    Failed
    END

SAP UI Release
    ${version}    Software Component Version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    SAP_UI
    ${support_package}    software support package version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    SAP_UI
    IF    '${version}' == '740'
        IF    '${support_package}' >= 'SAPK-74014INSAPUI'
            Write Excel    ${filepath}    ${sheetname}    3    2    ${SAP_UI_success}
            Write Excel    ${filepath}    ${sheetname}    3    3    Passed
        ELSE
            Write Excel    ${filepath}    ${sheetname}    3    2    ${SAP_UI_fail}
            Write Excel    ${filepath}    ${sheetname}    3    3    Failed           
        END
    ELSE IF    '${version}' >= '740'
        Write Excel    ${filepath}    ${sheetname}    3    2    ${SAP_UI_success}
        Write Excel    ${filepath}    ${sheetname}    3    3    Passed
    ELSE
        Write Excel    ${filepath}    ${sheetname}    3    2    ${SAP_UI_fail}
        Write Excel    ${filepath}    ${sheetname}    3    3    Failed
    END
Component ST-PI Version
    ${version}    Software Component Version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    ST-PI
    ${support_package}    software support package version    wnd[2]/usr/tabsVERSDETAILS/tabpCOMP_VERS/ssubDETAIL_SUBSCREEN:SAPLOCS_UI_CONTROLS:0301/cntlSCV_CU_CONTROL/shellcont/shell    ST-PI
    IF    '${version}' == '740'
        IF    '${support_package}' == '${symvar('Current_Version')}'
            Write Excel    ${filepath}    ${sheetname}    4    2    ${ST_PI_Success}
            Write Excel    ${filepath}    ${sheetname}    4    3    Passed
        ELSE
            Write Excel    ${filepath}    ${sheetname}    4    2    ${ST_PI_Fail}
            Write Excel    ${filepath}    ${sheetname}    4    3    Failed            
        END
    ELSE
        Write Excel    ${filepath}    ${sheetname}    4    2    ${ST_PI_Fail}
        Write Excel    ${filepath}    ${sheetname}    4    3    Failed
    END
    Close Window    wnd[2]
    Close Window    wnd[1]

Verify parameter in RZ10
    Run Transaction    /nRZ10
    Send Vkey    4    window=0
    Select Profile Label    wnd[1]/usr    DEFAULT 
    Click Element   wnd[1]/tbar[0]/btn[0]
    Select Radio Button    wnd[0]/usr/radSPFL1010-EXPERT
    Click Element    wnd[0]/usr/btnEDIT_PUSH
    ${length}    Get Length    ${parameters}
    FOR    ${i}    IN RANGE    0    ${length}
        ${result}    Check Parameter Found    wnd[0]/usr    ${parameters}[${i}]
        IF    '${result}' == '${parameters}[${i}]'
            Get Parameter Value    wnd[0]/usr    ${parameters}[${i}]
            ${param_value}    Get Value    wnd[0]/usr/sub:SAPLSPF2:0030[0]/txtPARAMETER_INT_VALUES-PVALUE[0,0]
            IF    '${param_value}' == '${values}[${i}]'
                Write Excel    ${filepath}    ${sheetname}    5    2    ${parameter_Pass}
                Write Excel    ${filepath}    ${sheetname}    5    3    Passed
                Click Element    wnd[0]/tbar[0]/btn[3]
            ELSE
                Write Excel    ${filepath}    ${sheetname}    5    2    ${parameter_Fail}
                Write Excel    ${filepath}    ${sheetname}    5    3    Failed
            END
        ELSE
            Write Excel    ${filepath}    ${sheetname}    5    2    ${parameter_Fail}
            Write Excel    ${filepath}    ${sheetname}    5    3    Failed
        END        
    END
    
STRUST
    Run Transaction    /nSTRUST
    Sleep    2
    Take Screenshot    ssl.jpg
    Click Element    wnd[0]/tbar[1]/btn[25]
    # Sleep    2
    ${cert_count}    Set Variable    0
    Set Global Variable    ${cert_count}
    STRUS_SSL_Client_Anonymous
    
STRUS_SSL_Client_Anonymous
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCANONYM    
    Sleep    2
    # Take Screenshot    SSL_client_Anonymous_1.jpg
    # Sleep    2
    ${space}    Get Value    wnd[0]/usr/tblS_TRUSTMANAGERPK_CTRL/txtPSECERTLIST-SUBJECT[0,0]
    Sleep    1
    IF    '${space}' != ''
        FOR    ${index}    IN RANGE    0    3
            ${value}    Get Value    wnd[0]/usr/tblS_TRUSTMANAGERPK_CTRL/txtPSECERTLIST-SUBJECT[0,${index}]
            Sleep    1
            IF    '${value}' == 'CN=DigiCert Global Root G2, OU=www.digicert.com, O=DigiCert Inc, C=US'
                ${cert_count}    Evaluate    ${cert_count} + 1
            ELSE IF    '${value}' == 'CN=DigiCert Global Root CA, OU=www.digicert.com, O=DigiCert Inc, C=US'
                ${cert_count}    Evaluate    ${cert_count} + 1
            ELSE IF    '${value}' == 'CN=DigiCert RSA4096 Root G5, O="DigiCert, Inc.", C=US'
                ${cert_count}    Evaluate    ${cert_count} + 1
            ELSE
                Log To Console    Certificate need to be uploaded
            END
        END
    END
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCDFAULT    
    Sleep    2
    # Take Screenshot    SSL_client_Standard_1.jpg
    # Sleep    2
    ${space}    Get Value    wnd[0]/usr/tblS_TRUSTMANAGERPK_CTRL/txtPSECERTLIST-SUBJECT[0,0]
    Sleep    1
    IF    '${space}' != ''
        FOR    ${index}    IN RANGE    0    3
            ${value}    Get Value    wnd[0]/usr/tblS_TRUSTMANAGERPK_CTRL/txtPSECERTLIST-SUBJECT[0,${index}]
            Sleep    1
            IF    '${value}' == 'CN=DigiCert Global Root G2, OU=www.digicert.com, O=DigiCert Inc, C=US'
                ${cert_count}    Evaluate    ${cert_count} + 1
            ELSE IF    '${value}' == 'CN=DigiCert Global Root CA, OU=www.digicert.com, O=DigiCert Inc, C=US'
                ${cert_count}    Evaluate    ${cert_count} + 1
            ELSE IF    '${value}' == 'CN=DigiCert RSA4096 Root G5, O="DigiCert, Inc.", C=US'
                ${cert_count}    Evaluate    ${cert_count} + 1
            ELSE
                Log To Console    Certificate need to be uploaded
            END
        END
    END
    IF    '${cert_count}' == '6'
        Write Excel    ${filepath}    ${sheetname}    6    2    ${certificate_Pass}
        Write Excel    ${filepath}    ${sheetname}    6    3    Failed
    ELSE
        Write Excel    ${filepath}    ${sheetname}    6    2    ${certificate_Fail}
        Write Excel    ${filepath}    ${sheetname}    6    3    Failed
    END 
  

SNOTE
    Run Transaction    /nsnote
    Sleep    2
    Set Focus    wnd[0]/usr/lbl[5,3]
    Sleep    2
    Send Vkey    2
    Sleep    2
    Take Screenshot    snote_1.jpg
    Sleep    1
    Click Element    wnd[0]/tbar[1]/btn[33]
    Sleep    1   
    FOR    ${number}    IN    @{SAP_Note}
        Input Text    wnd[0]/usr/txtNUMM-LOW    ${number}
        Sleep    1
        Click Element    wnd[0]/tbar[1]/btn[8]
        Sleep    3
        ${SAP_note_error}=    Get Value    wnd[0]/sbar/pane[0]
        IF    '${SAP_note_error}' == 'Unable to find SAP Note that meets specified criteria'
            Log To Console    ${SAP_note_error} ${number}
        ELSE
            Double Click Current Cell Value    wnd[0]/usr/cntlGRID1/shellcont/shell    PRSTATUS
            Sleep    2
            ${value}=    Get Value    wnd[0]/usr/subSUB_101:SAPLSCW_NA_SCREEN:0101/txtSCWB_S_SCREEN_NOTE-PRSTATUS_TEXT
            # Log    ${number}=${value}
            IF    '${value}' == 'Cannot be implemented'
                # Log    ${number}=${value}
                Log To Console    Snote ${number} is uploaded already
                Click Element    wnd[0]/tbar[0]/btn[3]
                Sleep    1
                Click Element    wnd[0]/tbar[0]/btn[3]
                Sleep    1
            ELSE IF    '${value}' == 'Can be implemented'
                # Click Element    wnd[0]/tbar[0]/btn[3]
                # Sleep    2
                # Click Element    wnd[0]/tbar[1]/btn[25]
                # Sleep    10
                Log To Console    Snote ${number} should be uploaded
            END
        END
    END
