*** Settings ***
Library    SeleniumLibrary
*** Variables ***
${BASE_URL}    https://qa.symphony4cloud.com/login
*** Keywords ***
Test space issue
    Open Browser    url=${BASE_URL}    browser=chrome
    Maximize Browser Window
    Input Text    locator=id:user_name    text=%{username}
    Sleep    10
