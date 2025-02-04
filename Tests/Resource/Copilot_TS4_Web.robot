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
    Sleep    1
    Maximize Browser Window

    Input Text    name:j_username    S0023459113

    # Explicit Waits before clicking
    Wait Until Element Is Visible    xpath://div[normalize-space(text())='Continue']    timeout=30s
    Wait Until Element Is Enabled    xpath://div[normalize-space(text())='Continue']    timeout=30s
    Click Element    xpath://div[normalize-space(text())='Continue']

    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${ACCEPT_BUTTON}    timeout=30s
    Run Keyword And Ignore Error    Wait Until Element Is Enabled    ${ACCEPT_BUTTON}    timeout=30s
    Run Keyword And Ignore Error    Click Element    ${ACCEPT_BUTTON}

    Input Password    name:password    Whitetiger@2024

    Wait Until Element Is Visible    xpath://button[normalize-space(text())='Sign in']    timeout=30s
    Wait Until Element Is Enabled    xpath://button[normalize-space(text())='Sign in']    timeout=30s
    Click Element    xpath://button[normalize-space(text())='Sign in']

    Wait Until Element Is Visible    id:shell-component---application402700331--frame    timeout=30s
    Select Frame    id:shell-component---application402700331--frame

    Wait Until Element Is Visible    xpath://bdi[@id='__button10-BDI-content' and contains(text(), 'Favorite System')]    timeout=30s
    Wait Until Element Is Enabled    xpath://bdi[@id='__button10-BDI-content' and contains(text(), 'Favorite System')]    timeout=30s
    Click Element    xpath://bdi[@id='__button10-BDI-content' and contains(text(), 'Favorite System')]

    Wait Until Element Is Visible    xpath://div[@class='sapMFFLITitle'][contains(text(),'${System}')]    timeout=30s
    Wait Until Element Is Enabled    xpath://div[@class='sapMFFLITitle'][contains(text(),'${System}')]    timeout=30s
    Click Element    xpath://div[@class='sapMFFLITitle'][contains(text(),'${System}')]

    Wait Until Element Is Visible    id:__button20    timeout=30s
    Wait Until Element Is Enabled    id:__button20    timeout=30s
    Sleep    2
    Click Element    id:__button20

    Wait Until Element Is Visible    id:__xmlview1--notesTable-sa    timeout=30s
    Wait Until Element Is Enabled    id:__xmlview1--notesTable-sa    timeout=30s
    Sleep    2
    Click Element    id:__xmlview1--notesTable-sa

    Wait Until Element Is Visible    xpath://bdi[contains(text(), 'Export List as CSV File')]    timeout=30s
    Wait Until Element Is Enabled    xpath://bdi[contains(text(), 'Export List as CSV File')]    timeout=30s
    Sleep    2
    Click Element    xpath://bdi[contains(text(), 'Export List as CSV File')]

    Sleep    1



    