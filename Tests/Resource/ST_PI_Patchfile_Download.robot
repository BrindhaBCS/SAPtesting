*** Settings ***
Library    SeleniumLibrary
Library    ChromeOptions.py
Library    OperatingSystem
Library    Collections
Library    SAP_Tcode_Library
Library    Process
*** Variables ***
${url}    https://support.sap.com
${browser}    chrome
${Package}    
${BASE_LOCATOR}       __identifier1-__xmlview3--idProductDownloadList
${MAX_TRIES}          100  # Maximum number of locators to try
*** Keywords ***
System Logon
    Start Process     ${symvar('ABAP_SAP_SERVER')}     
    Sleep    2
    Connect To Session
    Open Connection    ${symvar('ABAP_Connection')}    
    SeleniumLibrary.Input Text    wnd[0]/usr/txtRSYST-MANDT    ${symvar('ABAP_CLIENT')}
    SeleniumLibrary.Input Text    wnd[0]/usr/txtRSYST-BNAME    ${symvar('ABAP_USER')}
    # Input Password   wnd[0]/usr/pwdRSYST-BCODE    ${symvar('RBT_USER_PASSWORD')}
    SeleniumLibrary.Input Password   wnd[0]/usr/pwdRSYST-BCODE    %{ABAP_PASSWORD}
    Send Vkey    0
    Multiple logon Handling     wnd[1]  wnd[1]/usr/radMULTI_LOGON_OPT2  wnd[1]/tbar[0]/btn[0] 

System Logout
    Run Transaction   /nex
Verify Package
    ${Package}    Verify The Support Packages    ${symvar('supportpackage')}    ${symvar('Current_Version')}    ${symvar('supportpackage_path')}
    Log    ${Package}  
    Log To Console    ${Package}
    Set Global Variable    ${Package}
    IF    ${Package} != []
        login page
        Software Download
    ELSE
        Log To Console    All the Packages are already exist
    END
login page
    # # Open Browser    ${url}    ${browser}
    Create Directory    ${symvar('supportpackage_path')}
    ${chrome_options}=    Get Chrome Options    ${symvar('supportpackage_path')}
    Open Browser    ${url}    ${browser}    options=${chrome_options}
    Maximize Browser Window
    Sleep    15
    ${element_present}=    Run Keyword And Return Status    element should be visible    xpath://span[normalize-space(text())='Software Downloads']
    Sleep    5
    Run Keyword If    '${element_present}' == 'False'    Reload Page
    Sleep    5
    # Wait Until Element Is Visible    xpath://span[normalize-space(text())='Software Downloads']    120s
    SeleniumLibrary.Click Element    xpath://span[normalize-space(text())='Software Downloads']
    Sleep    10
    Switch Window    NEW
    Sleep    2
    Wait Until Element Is Visible    id:j_username    120s
    SeleniumLibrary.Input Text    id:j_username   ${symvar('S_Username')}
    Sleep    2
    SeleniumLibrary.Click Element    xpath://div[text()='Continue']
    Sleep    15
    SeleniumLibrary.Input Text    id:password    %{S_Password}
    Sleep    10
    SeleniumLibrary.Click Element    xpath://button[text()='Sign in']
    Sleep    30

Software Download
    Select Frame    id:shell-component---application420660846--frame
    Sleep    1
    Wait Until Element Is Visible    id:__filter1-text   120s
    SeleniumLibrary.Click Element    id:__filter1-text
    Sleep    5
    SeleniumLibrary.Input Text    id:__field0-I   ${symvar('ST_PI_version')}
    Sleep    4
    SeleniumLibrary.Click Element    id:__field0-search
    Sleep    10
    SeleniumLibrary.Input Text    id:__field1-I    Maintenance
    Sleep    2
    SeleniumLibrary.Click Element    xpath://div[@class='sapMSLIDescriptionText']
    Sleep    2
    SeleniumLibrary.Click Element    id:__xmlview3--idProductHierarchyList
    Sleep    5
    ${index}=    Set Variable    0
    
    FOR    ${counter}    IN RANGE    ${MAX_TRIES}
        ${locator}=    Set Variable    ${BASE_LOCATOR}-${index}-link
        ${index}=    Evaluate    ${index}+1
        ${element_text}=    Get Text    id=${locator}
        
        ${file}=    Evaluate    '${element_text}'[3:]
        ${current_file}    Set Variable    '${file}.SAR'
        
        ${file_exists}=    Set Variable    False
        
        ${file_exists}=    Evaluate    ${current_file} in ${Package}
        
        Run Keyword If    '${file_exists}' == 'True'    SeleniumLibrary.Click Element    ${locator}
        Run Keyword If    '${file_exists}' == 'True'    Sleep    10 
        Run Keyword If    '${file_exists}' == 'True'    Log    Downloading the file: ${element_text}
        
        Run Keyword If    '${file_exists}' == 'False'    Log   The file ${element_text} already exists, skipping download.
        
        Run Keyword If    '${element_text}' == '${symvar('supportpackage')}'    Exit For Loop
        Log To Console    **gbStart**copilot_status**splitKeyValue**Support packages downloaded from SAP Portal into local server**gbEnd**
    END

Verify Maintenance Certificate
    Run Transaction    /nSLICENSE
    ${value1}    Get Cell Value    wnd[0]/usr/tabsTABSTRIP_1000/tabpLIKEY_ALV/ssubACTIVE_TAB:SAPMSLIC:3030/cntlCC_ALV_LICENSES/shellcont/shell     0    SW_PRODUCT
    Log To Console    ${value1}
    ${value2}    Get Cell Value    wnd[0]/usr/tabsTABSTRIP_1000/tabpLIKEY_ALV/ssubACTIVE_TAB:SAPMSLIC:3030/cntlCC_ALV_LICENSES/shellcont/shell     0    VALIDITY_TEXT
    Log To Console    ${value2}
    IF     '${value1}' == 'Maintenance_HDB' and '${value2}' == 'Valid'
        Verify Package
    ELSE
        Log To Console    **gbStart**copilot_status**splitKeyValue**No valid maintainence certificate **gbEnd**
    END