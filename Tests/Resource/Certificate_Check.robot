*** Settings ***
Library    Process
Library    String
Library    SAP_Tcode_Library.py
*** Variables ***
@{URLS}    https://dl.cacerts.digicert.com/DigiCertGlobalRootCA.crt    https://cacerts.digicert.com/DigiCertGlobalRootG2.crt    https://cacerts.digicert.com/DigiCertRSA4096RootG5.crt
${DESTINATION_BASE}    C:\\tmp\\
*** Keywords ***
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
    Start Process     ${symvar('ABAP_SAP_SERVER')}     
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('ABAP_Connection')}    
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABAP_CLIENT')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABAP_USER')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('RBT_USER_PASSWORD')}
    Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 

System Logout
    Run Transaction   /nex
STRUST
    Run Transaction    /nSTRUST
    Sleep    2
    Take Screenshot    ssl.jpg
    Click Element    wnd[0]/tbar[1]/btn[25]
    Sleep    2
STRUS_SSL_Client_Anonymous
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCANONYM    
    Sleep    2
    Take Screenshot    SSL_client_Anonymous_1.jpg
    Sleep    2
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
            upload_certificate_SSL_Client_Anonymous
            Log To Console    Certificate Uploaded
            END
        END
    ELSE
        upload_certificate_SSL_Client_Anonymous
        Log To Console    Certificate Uploaded
    END

upload_certificate_SSL_Client_Anonymous
    Set Caret Position    wnd[0]/usr/txtPSE-OWNCERT-SUBJECT    32
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    1
    Take Screenshot    SSL_client_Anonymous_2.jpg
    Sleep    1
    Click Element    wnd[0]/usr/btnIMPORT        #IMPORT_ICON
    Sleep    1
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${DESTINATION_BASE}DigiCertGlobalRootCA.crt
    Sleep    1
    CRT_exceution
    Sleep    1
    Click Element    wnd[0]/usr/btnIMPORT        #IMPORT_ICON
    Sleep    1
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${DESTINATION_BASE}DigiCertGlobalRootG2.crt
    Sleep    1
    CRT_exceution
    Sleep    1
    Click Element    wnd[0]/usr/btnIMPORT        #IMPORT_ICON
    Sleep    1
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${DESTINATION_BASE}DigiCertRSA4096RootG5.crt
    Sleep    1
    CRT_exceution
    Sleep    1
STRUSTS_SSL_Client_Standard
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLCDFAULT    
    Sleep    2
    Take Screenshot    SSL_client_Standard_1.jpg
    Sleep    2
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
                upload_certificate_SSL_Client_Anonymous
                Log To Console    Certificate Uploaded
            END
        END
    ELSE
        upload_certificate_SSL_Client_Standard
        Log To Console    Certificate Uploaded
    END
upload_certificate_SSL_Client_Standard
    Set Caret Position    wnd[0]/usr/txtPSE-OWNCERT-SUBJECT    21
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Take Screenshot    SSL_client_Standard_2.jpg
    Sleep    2
    Click Element    wnd[0]/usr/btnIMPORT        #IMPORT_ICON
    Sleep    1
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${DESTINATION_BASE}DigiCertGlobalRootCA.crt
    Sleep    1
    CRT_exceution
    Sleep    1
    Click Element    wnd[0]/usr/btnIMPORT        #IMPORT_ICON
    Sleep    1
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${DESTINATION_BASE}DigiCertGlobalRootG2.crt
    Sleep    1
    CRT_exceution
    Sleep    1
    Click Element    wnd[0]/usr/btnIMPORT        #IMPORT_ICON
    Sleep    1
    Input Text    wnd[1]/usr/tabsTS_CTRL/tabpSFIL/ssubSUB1:S_TRUSTMANAGER:0202/ctxtFILEPATH    ${DESTINATION_BASE}DigiCertRSA4096RootG5.crt
    Sleep    1
    CRT_exceution
    Sleep    1
CRT_exceution 
    Sleep    2
    Click Element    wnd[1]/tbar[0]/btn[0]
    Sleep    2
    Scroll Pagedown    wnd[0]/usr/btnCERTDETAIL
    Sleep    2
    Click Element    wnd[0]/usr/btnINCLUDE
    Sleep    2
    Click Element    wnd[0]/tbar[0]/btn[11]
    Sleep    2