*** Settings ***
Library     SeleniumLibrary

*** Keywords ***
Start TestCase
    Log    Opening browser
    Open Browser    ${symvar('url')}    ${browser}    #options=${global_browser_options}
    

    Submit Anugal username and password

Finish TestCase
    Close All Browsers

Submit Anugal username and password
    Wait until element is visible    ${symvar('user_text_box')}
    Sleep    10
    Input text    ${symvar('user_text_box')}        malayranjan.s@basiscloudsolutions.com
    Input password    ${symvar('password_text_box')}    QpGxHscc
    Click element    ${symvar('Login_anugal_button')}
