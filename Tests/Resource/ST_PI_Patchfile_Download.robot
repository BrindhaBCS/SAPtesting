*** Settings ***
Library    SeleniumLibrary
Library    ChromeOptions.py
Library    OperatingSystem
Library    Collections

*** Variables ***
${url}    https://support.sap.com
${browser}    chrome
${Package}    
${BASE_LOCATOR}       __identifier1-__xmlview3--idProductDownloadList
${MAX_TRIES}          100  # Maximum number of locators to try
*** Keywords ***
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
    Create Directory    ${symvar('Download_Dir')}
    ${chrome_options}=    Get Chrome Options    ${symvar('supportpackage_path')}
    Open Browser    ${url}    ${browser}    options=${chrome_options}
    Maximize Browser Window
    Sleep    15
    Wait Until Element Is Visible    xpath://span[normalize-space(text())='Software Downloads']    120s
    Click Element    xpath://span[normalize-space(text())='Software Downloads']
    Sleep    10
    Switch Window    NEW
    Sleep    2
    Wait Until Element Is Visible    id:j_username    120s
    Input Text    id:j_username   ${symvar('S_Username')}
    Sleep    2
    Click Element    xpath://div[text()='Continue']
    Sleep    15
    Input Text    id:password    %{S_Password}
    Sleep    10
    Click Element    xpath://button[text()='Sign in']
    Sleep    30

Software Download
    Select Frame    id:shell-component---application420660846--frame
    Sleep    1
    Wait Until Element Is Visible    id:__filter1-text   120s
    Click Element    id:__filter1-text
    Sleep    5
    Input Text    id:__field0-I   ${symvar('ST_PI_version')}
    Sleep    4
    Click Element    id:__field0-search
    Sleep    10
    Click Element    id:__item29-__clone71
    Sleep    2
    Click Element    id:__xmlview3--idProductHierarchyList
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
        
        Run Keyword If    '${file_exists}' == 'True'    Click Element    ${locator}
        Run Keyword If    '${file_exists}' == 'True'    Sleep    10 
        Run Keyword If    '${file_exists}' == 'True'    Log    Downloading the file: ${element_text}
        
        Run Keyword If    '${file_exists}' == 'False'    Log   The file ${element_text} already exists, skipping download.
        
        Run Keyword If    '${element_text}' == '${symvar('supportpackage')}'    Exit For Loop
    END
    Log To Console    **gbStart**copilot_status**splitKeyValue**Support packages downloaded from SAP Portal into local server**gbEnd**