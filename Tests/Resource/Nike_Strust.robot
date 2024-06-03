*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String

*** Keywords ***
System Logon
    Start Process    ${symvar('Nike_SAP')}
    Sleep   5
    Connect To Session
    Open Connection     ${symvar('Nike_connection')}
    Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('CFG_CLIENT')}
    Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('CFG_USER')}    
    Input Password    wnd[0]/usr/pwdRSYST-BCODE    %{CFG_PASS} 
    # Input Password    wnd[0]/usr/pwdRSYST-BCODE    ${symvar('CFG_PASS')}  
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 
    Sleep   1

System Logout
    Run Transaction   /nex
    Sleep    5
    

Transaction STRUST
    Run Transaction     /nstrust
    Send Vkey    0
    Take Screenshot    001_Strust.jpg
    Sleep    2

SSL server standard        
    Double Click On Tree Item    wnd[0]/shellcont/shell    SSLSDFAULT    
    Sleep    2
    Take Screenshot    031_SSLSDFAULT.jpg
    Sleep    2
    ${row_count}    Get row count    wnd[0]/usr/cntlPK_CTRL/shellcont/shell     
    Log to console    ${row_count}
    FOR    ${row_no}    IN RANGE    0    ${row_count}
        Log to console    ${row_no} 
        ${Owner}    get cell value     wnd[0]/usr/cntlPK_CTRL/shellcont/shell    ${row_no}     SUBJECT
        Log to console    ${Owner}
        IF    '${Owner}' == 'CN=www.splunk.com, O=Splunk Inc., L=San Francisco, SP=California, C=US'
            ${Valid_from}    get cell value     wnd[0]/usr/cntlPK_CTRL/shellcont/shell    ${row_no}      DATEFROM
            Log to console    ${Valid_from}

            ${Valid_To}    get cell value     wnd[0]/usr/cntlPK_CTRL/shellcont/shell    ${row_no}     DATETO
            Log to console    ${Valid_To}
            IF    '${Valid_from}' >= '${Valid_To}'
                Log to console    Certificate is Valid till ${Valid_To}
                Set Global Variable     ${Valid_To}
                # Log To Console    **gbStart**certificate_status**splitKeyValue**Certificate is Valid till ${Valid_To}**gbEnd**
                Log To Console    **gbStart**certificate_status**splitKeyValue**Valid**gbEnd**
            ELSE    
                # Log to console    Certificate is invalid from ${Valid_To} 
                Log To Console    **gbStart**certificate_status**splitKeyValue**Expired**gbEnd**
            END 
        ELSE  
            Log to console    Certificate not matches with Splunk.com
        END            
    END

 

