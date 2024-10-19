*** Settings ***
Library    Process
Library    String
Library    SAP_Tcode_Library.py
Library    ExcelLibrary
Library    openpyxl
*** Variables ***
@{URLS}    https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt    https://cacerts.digicert.com/DigiCertGlobalRootG2.crt    https://cacerts.digicert.com/DigiCertRSA4096RootG5.crt
${DESTINATION_BASE}    C:\\tmp\\
${certificate_Pass}    SSL Certificates are available in the System
${certificate_Fail}    SSL Certificate need to be added to the System
${filepath}    C:\\RobotFramework\\sap_testing\\Tests\\Resource\\Prerequisite_Status.xlsx
${sheetname}    Sheet1

*** Keywords ***
Write Excel
    [Arguments]    ${filepath}    ${sheetname}    ${rownum}    ${colnum}    ${cell_value}
    Open Excel Document    ${filepath}    1
    Get Sheet    ${sheetname}  
    Write Excel Cell      ${rownum}       ${colnum}     ${cell_value}       ${sheetname}
    Save Excel Document     ${filepath}
    Close Current Excel Document
Download Certificates
    FOR    ${url}    IN    @{URLS}
        ${file_name}=    Get File Name From URL    ${url}
        ${destination}=    Set Variable    ${DESTINATION_BASE}${file_name}
        Start Process    curl    ${url}    -o    ${destination}
        Log    Downloaded ${file_name} to ${destination}
    END
Get File Name From URL
    [Arguments]    ${url}
    ${path}=    Get Substring    ${url}    ${url.find('/') + 1}
    ${file_name}=    Get Substring    ${path}    ${path.rfind('/') + 1}
    [Return]    ${file_name}
System Logon
    Start Process    ${symvar('ABAP_SAP_SERVER')}
    Connect To Session
    Open Connection     ${symvar('ABAP_SID')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABAP_CLIENT')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABAP_USER')}
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('ABAP_PASSWORD')}
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{ABAP_PASSWORD} 
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0]

System Logout
    Run Transaction   /nex
STRUST
    Run Transaction    /nSTRUST
    Sleep    2
    Enable Edit Mode for Anonymous
    Enable Edit Mode for Standard
    Write Excel    ${filepath}    ${sheetname}    6    2    ${certificate_Pass}
    Write Excel    ${filepath}    ${sheetname}    6    3    Passed

Enable Edit Mode for Anonymous
    ${window}    Get Window Title    wnd[0]
    IF    '${window}' == 'Trust Manager: Change'
        STRUS_SSL_Client_Anonymous
    ELSE
        Click Element    wnd[0]/tbar[1]/btn[25]
        STRUS_SSL_Client_Anonymous
    END

Enable Edit Mode for Standard
    ${window}    Get Window Title    wnd[0]
    IF    '${window}' == 'Trust Manager: Change'
        STRUSTS_SSL_Client_Standard
    ELSE
        Click Element    wnd[0]/tbar[1]/btn[25]
        STRUSTS_SSL_Client_Standard
    END
STRUS_SSL_Client_Anonymous
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCANONYM    
    Sleep    2
    # Take Screenshot    SSL_client_Anonymous_1.jpg
    # Sleep    2
    ${space}    Get Value    wnd[0]/usr/tblS_TRUSTMANAGERPK_CTRL/txtPSECERTLIST-SUBJECT[0,0]
    # Sleep    1
    IF    '${space}' != ''
        FOR    ${index}    IN RANGE    0    3
        ${value}    Get Value    wnd[0]/usr/tblS_TRUSTMANAGERPK_CTRL/txtPSECERTLIST-SUBJECT[0,${index}]
        Sleep    4
            IF    '${value}' == 'CN=DigiCert Global Root G2, OU=www.digicert.com, O=DigiCert Inc, C=US'
                Log To Console    Certificate already exists: DigiCert Global Root G2
            ELSE IF    '${value}' == 'CN=DigiCert Global Root CA, OU=www.digicert.com, O=DigiCert Inc, C=US'
                Log To Console    Certificate already exists: DigiCert Global Root CA
            ELSE IF    '${value}' == 'CN=DigiCert RSA4096 Root G5, O="DigiCert, Inc.", C=US'
                Log To Console    Certificate already exists: DigiCert RSA4096 Root G5
            ELSE
            upload_certificate_SSL_Client_Anonymous
            Log To Console    System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} -- STRUS_SSL_Client_Anonymous SAP Cloud ALM Connection Certificate Added Successfully
            END
            ${result_one}    Set Variable    System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} -- STRUS_SSL_Client_Anonymous SAP Cloud ALM Connection Certificate Added Successfully...
            Log To Console    **gbStart**copilot_status_Client_Anonymous**splitKeyValue**${result_one}**gbEnd**
        END
    ELSE
        upload_certificate_SSL_Client_Anonymous
        ${result_two}    Set Variable    System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} -- STRUS_SSL_Client_Anonymous SAP Cloud ALM Connection Certificate Added Successfully
        Log To Console    **gbStart**copilot_status_Client_Anonymous**splitKeyValue**${result_two}**gbEnd**
    END

upload_certificate_SSL_Client_Anonymous
    Set Caret Position    wnd[0]/usr/txtPSE-OWNCERT-SUBJECT    32
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    
    Click Element    wnd[0]/usr/btnIMPORT        #IMPORT_ICON
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${DESTINATION_BASE}DigiCertGlobalRootCA.crt
    Click Element    wnd[1]/tbar[0]/btn[0]
    Click Element    wnd[0]/usr/btnINCLUDE
    
    Click Element    wnd[0]/usr/btnIMPORT        #IMPORT_ICON
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${DESTINATION_BASE}DigiCertGlobalRootG2.crt
    Click Element    wnd[1]/tbar[0]/btn[0]
    Click Element    wnd[0]/usr/btnINCLUDE
    
    Click Element    wnd[0]/usr/btnIMPORT        #IMPORT_ICON
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${DESTINATION_BASE}DigiCertRSA4096RootG5.crt
    Click Element    wnd[1]/tbar[0]/btn[0]
    Click Element    wnd[0]/usr/btnINCLUDE
    Click Element    wnd[0]/tbar[0]/btn[11]
STRUSTS_SSL_Client_Standard
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCDFAULT 
    ${space}    Get Value    wnd[0]/usr/tblS_TRUSTMANAGERPK_CTRL/txtPSECERTLIST-SUBJECT[0,0]
    Sleep    1
    IF    '${space}' != ''
        FOR    ${index}    IN RANGE    0    3
        ${value}    Get Value    wnd[0]/usr/tblS_TRUSTMANAGERPK_CTRL/txtPSECERTLIST-SUBJECT[0,${index}]
        Sleep    1
            IF    '${value}' == 'CN=DigiCert Global Root G2, OU=www.digicert.com, O=DigiCert Inc, C=US'
                Log To Console    Certificate already exists: DigiCert Global Root G2
            ELSE IF    '${value}' == 'CN=DigiCert Global Root CA, OU=www.digicert.com, O=DigiCert Inc, C=US'
                Log To Console    Certificate already exists: DigiCert Global Root CA
            ELSE IF    '${value}' == 'CN=DigiCert RSA4096 Root G5, O="DigiCert, Inc.", C=US'
                Log To Console    Certificate already exists: DigiCert RSA4096 Root G5
            ELSE
                upload_certificate_SSL_Client_Standard
                Log To Console    System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} -- STRUSTS_SSL_Client_Standard SAP Cloud ALM Connection Certificate Uploaded successfully
            END
            ${result_one_.}    Set Variable    System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} -- STRUSTS_SSL_Client_Standard SAP Cloud ALM Connection Certificate Uploaded successfully...
            Log To Console    **gbStart**copilot_status_Client_Standard**splitKeyValue**${result_one_.}**gbEnd**
        END
    ELSE
        upload_certificate_SSL_Client_Standard
        ${result_two_.}    Set Variable    System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} -- STRUSTS_SSL_Client_Standard SAP Cloud ALM Connection Certificate Uploaded successfully.....
        Log To Console    System ${symvar('ABAP_Connection')} client ${symvar('ABAP_CLIENT')} -- STRUSTS_SSL_Client_Standard SAP Cloud ALM Connection Certificate Uploaded successfully
        Log To Console    **gbStart**copilot_status_Client_Standard**splitKeyValue**${result_two_.}**gbEnd**
    END
upload_certificate_SSL_Client_Standard
    Set Caret Position    wnd[0]/usr/txtPSE-OWNCERT-SUBJECT    21
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    
    Click Element    wnd[0]/usr/btnIMPORT        #IMPORT_ICON
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${DESTINATION_BASE}DigiCertGlobalRootCA.crt
    Click Element    wnd[1]/tbar[0]/btn[0]
    Click Element    wnd[0]/usr/btnINCLUDE
    
    Click Element    wnd[0]/usr/btnIMPORT        #IMPORT_ICON
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${DESTINATION_BASE}DigiCertGlobalRootG2.crt
    Click Element    wnd[1]/tbar[0]/btn[0]
    Click Element    wnd[0]/usr/btnINCLUDE
    
    Click Element    wnd[0]/usr/btnIMPORT        #IMPORT_ICON
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${DESTINATION_BASE}DigiCertRSA4096RootG5.crt
    Click Element    wnd[1]/tbar[0]/btn[0]
    Click Element    wnd[0]/usr/btnINCLUDE
    Click Element    wnd[0]/tbar[0]/btn[11]
