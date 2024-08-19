*** Settings ***    
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
# Library    SeleniumLibrary

*** Variables ***
@{parameters}    ssl/ciphersuites    ssl/client_ciphersuites    icm/HTTPS/client_sni_enabled    ssl/client_sni_enabled    SETENV_26    SETENV_27    SETENV_28
@{values}   135:PFS:HIGH::EC_X25519:EC_P256:EC_HIGH    150:PFS:HIGH::EC_X25519:EC_P256:EC_HIGH    TRUE    TRUE    SECUDIR=$(DIR_INSTANCE)$(DIR_SEP)sec    SAPSSL_CLIENT_CIPHERSUITES=150:PFS:HIGH::EC_X25519:EC_P256:EC_HIGH    SAPSSL_CLIENT_SNI_ENABLED=TRUE 

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

Verify parameter in RZ10
    Run Transaction    /nRZ10
    Send Vkey    4    window=0
    Select Profile Label    wnd[1]/usr    DEFAULT 
    Click Element   wnd[1]/tbar[0]/btn[0]
    Select Radio Button    wnd[0]/usr/radSPFL1010-EXPERT
    Click Element    wnd[0]/usr/btnEDIT_PUSH
    Sleep    4
    ${length}    Get Length    ${parameters}
    FOR    ${i}    IN RANGE    0    ${length}
        # Log To Console    list param is: ${parameters}[${i}]
        # Log To Console    Param value is: ${values}[${i}]
        ${result}    Check Parameter Found    wnd[0]/usr    ${parameters}[${i}]
        Log To Console    ${result}
        IF    '${result}' == '${parameters}[${i}]'
            Get Parameter Value    wnd[0]/usr    ${parameters}[${i}]
            ${param_value}    Get Value    wnd[0]/usr/sub:SAPLSPF2:0030[0]/txtPARAMETER_INT_VALUES-PVALUE[0,0]
            IF    '${param_value}' == '${values}[${i}]'
                Log To Console    ${parameters}[${i}] value is ${values}[${i}]
                Click Element    wnd[0]/tbar[0]/btn[3]
                Sleep    2
            ELSE
                Sleep    2
                Input Text    wnd[0]/usr/sub:SAPLSPF2:0030[0]/txtPARAMETER_INT_VALUES-PVALUE[0,0]    ${EMPTY}
                Sleep    2
                Input Text    wnd[0]/usr/sub:SAPLSPF2:0030[0]/txtPARAMETER_INT_VALUES-PVALUE[0,0]    ${values}[${i}]
                Click Element    wnd[0]/tbar[1]/btn[16]
                Sleep    2
                Click Element    wnd[0]/tbar[1]/btn[5]
                Sleep    2
                Click Element    wnd[0]/tbar[0]/btn[3]
                Click Element    wnd[0]/tbar[1]/btn[16]
            END
        ELSE
            Sleep    2
            Click Element    wnd[0]/tbar[1]/btn[5]
            Sleep    2
            Input Text    wnd[0]/usr/ctxtPARAMETER_INTERNAL-PARNAME    ${parameters}[${i}]
            Sleep    2
            Input Text    wnd[0]/usr/sub:SAPLSPF2:0030[0]/txtPARAMETER_INT_VALUES-PVALUE[0,0]    ${values}[${i}]
            Sleep    2
            Click Element    wnd[0]/tbar[1]/btn[16]
            Sleep    2
            Click Element    wnd[0]/tbar[1]/btn[5]
            Sleep    2
            Click Element    wnd[0]/tbar[0]/btn[3]
            Manage Window    wnd[1]    Maintain Profile 'DEFAULT' Version    wnd[1]/usr/btnKNOPF1
            Click Element    wnd[0]/tbar[1]/btn[16]
        END
        
    END
    Click Element    wnd[0]/tbar[0]/btn[3]
    Click Element    wnd[0]/tbar[0]/btn[11]
    Click Element    wnd[1]/usr/btnSPOP-OPTION1
    Window Handling    wnd[1]    Information    wnd[1]/tbar[0]/btn[0]
    Window Handling    wnd[1]    Note    wnd[1]/tbar[0]/btn[0]
    Log To Console      **gbStart**copilot_status**splitKeyValue**Parameter values are updated successfully**gbEnd**
    