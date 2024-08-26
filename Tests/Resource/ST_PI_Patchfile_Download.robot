*** Settings ***
Library    SeleniumLibrary
# Library    ChromeOptions.py
Library    OperatingSystem

*** Variables ***
${url}    https://support.sap.com
${browser}    chrome
${TEXT_TO_FIND}       SAPK-74003INSTPI
${BASE_LOCATOR}       __identifier1-__xmlview3--idProductDownloadList
${MAX_TRIES}          100  # Maximum number of locators to try

*** Keywords ***
login page
    # # Open Browser    ${url}    ${browser}
    # Create Directory    ${DOWNLOAD_DIR}
    # ${chrome_options}=    Get Chrome Options    ${DOWNLOAD_DIR}
    Open Browser    ${url}    ${browser}    #options=${chrome_options}
    Maximize Browser Window
    Sleep    5
    Click Element    xpath://span[normalize-space(text())='Software Downloads']
    Sleep    5
    Switch Window    NEW
    Sleep    2
    Input Text    id:j_username   %{S_Username}
    Sleep    2
    Click Element    xpath://div[text()='Continue']
    Sleep    10
    Input Text    id:password    %{S_Password}
    Sleep    5
    Click Element    xpath://button[text()='Sign in']
    Sleep    30
    
Software Download
    # Click Element    xpath://span[normalize-space(text())='Software Downloads']
    # Sleep    5
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
    ${Current_Version}    Get Text    id:__identifier1-__xmlview3--idProductDownloadList-0-link
    # Log To Console    Current Version:${Current Version}
    ${index}=    Set Variable    0
    FOR    ${counter}    IN RANGE    ${MAX_TRIES}
        ${locator}=    Set Variable    ${BASE_LOCATOR}-${index}-link
        ${index}=    Evaluate    ${index}+1
        # Log To Console    ${index}
        ${element_text} =    Get Text    id=${locator}
        Run Keyword And Ignore Error    Click Element    ${locator}
        Sleep    3 
        # Log To Console    The text of element ${locator} is: ${element_text}
        Run Keyword If    '${element_text}' == '${symvar('supportpackage')}'    Exit For Loop
    END
    Set Global Variable     ${Current_Version}
    Log To Console    **gbStart**Copilot_Status**splitKeyValue**Current Version: ${Current_Version}**gbEnd**