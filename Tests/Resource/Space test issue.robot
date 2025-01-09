*** Settings ***
Library    SeleniumLibrary
*** Variables ***
${BASE_URL}    https://predev.symphony4cloud.com/login
*** Keywords ***
Test space issue
    Open Browser    url=${BASE_URL}    browser=chrome
    Maximize Browser Window
    Sleep    10
    Open Browser    url=${BASE_URL}    browser=chrome
    Maximize Browser Window
    Sleep    5