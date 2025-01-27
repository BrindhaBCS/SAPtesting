*** Settings ***
Library    SeleniumLibrary
*** Variables ***
${Copilot_URL}    https://me.sap.com/app/securitynotes
${BROWSER}    CHROME
${System}    TS4
** Keywords ***
Web_Portal_TS4
    Open Browser    ${Copilot_URL}    ${BROWSER}
    Sleep    1
    Maximize Browser Window
    Input Text    name:j_username    S0023459113
    Sleep    1
    Click Element    xpath://div[normalize-space(text())='Continue']
    Wait Until Element Is Visible    name:password    30s
    Input Password    name:password    %(Cop_Web_Password)
    Wait Until Element Is Visible    xpath://button[normalize-space(text())='Sign in']    30s
    Click Element    xpath://button[normalize-space(text())='Sign in']
    Sleep    20
    Select Frame    id:shell-component---application402700331--frame
    Wait Until Element Is Visible    xpath://bdi[@id='__button10-BDI-content' and contains(text(), 'Favorite System')]    30s
    Click Element    xpath://bdi[@id='__button10-BDI-content' and contains(text(), 'Favorite System')]
    Sleep    1
    Click Element    xpath://div[@class='sapMFFLITitle'][contains(text(),'${System}')]
    Sleep    1
    Click Element    id:__button20
    Wait Until Element Is Visible    id:__xmlview1--notesTable-sa    30s
    Click Element    id:__xmlview1--notesTable-sa
    Sleep    2
    Click Element    xpath://bdi[contains(text(), 'Export List as CSV File')]
    Sleep    5