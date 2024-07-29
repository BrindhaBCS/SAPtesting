*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Start TestCase
    Log    Opening browser
    Open Browser    ${wvar('sap_url')}    ${browser}    options=${global_browser_options}

    Submit username and password
    Maximize Browser Window
    Sleep  10s

Finish TestCase
    Close Browser

Submit username and password
    Click Element    xpath://span[text()='Request Keys']
    Sleep    2
    Input Text    id:j_username    S0023459113
    Click Element    id:logOnFormSubmit
    Sleep    2
    Input Password    id:password    Whitetiger@2024
    Click Element    xpath://button[text()='Sign in']

Download License
    