*** Settings ***
Library    SeleniumLibrary
*** Variables ***
${Copilot_URL}    https://me.sap.com/app/securitynotes
${BROWSER}    CHROME
${System}    TS4
${ACCEPT_BUTTON}   xpath=//button[contains(text(),'I accept all cookies')]
** Keywords ***
Web_Portal_TS4
    Open Browser    ${Copilot_URL}    ${BROWSER}        
    Sleep    1
    Maximize Browser Window
    Wait Until Element Is Visible    name:j_username    30s
    Input Text    name:j_username    S0023459113
    Sleep    3
    Click Element    xpath://div[normalize-space(text())='Continue']
    Run Keyword And Ignore Error    ${ACCEPT_BUTTON}    timeout=20     
    Click Element    ${ACCEPT_BUTTON}
    Wait Until Element Is Visible    name:password    30s
    Input Password    name:password    Whitetiger@2024
    Wait Until Element Is Visible    xpath://button[normalize-space(text())='Sign in']    30s
    Click Element    xpath://button[normalize-space(text())='Sign in']
    Sleep    25
    Select Frame    id:shell-component---application402700331--frame
    Wait Until Element Is Visible    xpath://bdi[@id='__button10-BDI-content' and contains(text(), 'Favorite System')]    30s
    Click Element    xpath://bdi[@id='__button10-BDI-content' and contains(text(), 'Favorite System')]
    Sleep    1
    Click Element    xpath://div[@class='sapMFFLITitle'][contains(text(),'${System}')]
    Sleep    1
    Click Element    id:__button20
    Sleep    20
    Click Element    id:__xmlview1--notesTable-sa
    Sleep    2
    Click Element    xpath://bdi[contains(text(), 'Export List as CSV File')]
    Sleep    5