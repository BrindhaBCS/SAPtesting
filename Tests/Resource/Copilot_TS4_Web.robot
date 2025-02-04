*** Settings ***
Library    SeleniumLibrary
*** Variables ***
${Copilot_URL}    https://me.sap.com/app/securitynotes
${BROWSER}    CHROME
${System}    TS4
${ACCEPT_BUTTON}   xpath=//button[contains(text(),'I accept all cookies')]
${DOWNLOAD_DIR}   C:\\tmp\\Copilot\\
** Keywords ***
Web_Portal_TS4
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs}    Create Dictionary    download.default_directory    ${DOWNLOAD_DIR}
    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    Open Browser    ${Copilot_URL}    ${BROWSER}    options=${options}
    # Open Browser    ${Copilot_URL}    ${BROWSER}
    Maximize Browser Window
    ${globalwait}    Get Selenium Implicit Wait
    Set Selenium Implicit Wait    30s
    ${currentwait}    Get Selenium Implicit Wait
    Input Text    name:j_username    S0023459113
    Click Element    xpath://div[normalize-space(text())='Continue']
    Run Keyword And Ignore Error    ${ACCEPT_BUTTON}    timeout=20     
    Click Element    ${ACCEPT_BUTTON}
    Input Password    name:password    Whitetiger@2024
    Click Element    xpath://button[normalize-space(text())='Sign in']
    Select Frame    id:shell-component---application402700331--frame
    Click Element    xpath://bdi[@id='__button10-BDI-content' and contains(text(), 'Favorite System')]
    Click Element    xpath://div[@class='sapMFFLITitle'][contains(text(),'${System}')]
    Click Element    id:__button20
    Click Element    id:__xmlview1--notesTable-sa
    Click Element    xpath://bdi[contains(text(), 'Export List as CSV File')]
    Sleep    1