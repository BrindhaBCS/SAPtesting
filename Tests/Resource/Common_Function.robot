*** Settings ***
Library     SeleniumLibrary

*** Keywords ***
Start TestCase
    Log    Opening browser
    Open Browser    ${angvar('url')}    ${browser}    #options=${global_browser_options}
    

    Submit Anugal username and password

Finish TestCase
    Close All Browsers

Submit Anugal username and password
    Wait until element is visible    ${angvar('user_text_box')}
    Sleep    10
    Input text    ${angvar('user_text_box')}        malayranjan.s@basiscloudsolutions.com
    Input password    ${angvar('password_text_box')}    QpGxHscc
    Click element    ${angvar('Login_anugal_button')}
