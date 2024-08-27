*** Settings ***
Library    SeleniumLibrary
 
*** Variables ***
${url}    https://support.sap.com
${browser}    chrome
 
*** Keywords ***
login page
    Open Browser    ${url}    ${browser}    
    Maximize Browser Window
    Sleep    15
    Click Element    xpath://span[normalize-space(text())='Software Downloads']
    Sleep    5
    Switch Window    NEW
    Sleep    2
    Input Text    id:j_username   ${symvar('S_Username')}
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
    Input Text    id:__field0-I   ST-PI 740
    Sleep    4
    Click Element    id:__field0-search
    Sleep    10
    Click Element    id:__item29-__clone71
    Sleep    2
    Click Element    id:__xmlview3--idProductHierarchyList
    Sleep    5
    ${Current_Version}    Get Text    id:__identifier1-__xmlview3--idProductDownloadList-0-link
    Log To Console    **gbStart**Current_Version**splitKeyValue**${Current_Version}**gbEnd**