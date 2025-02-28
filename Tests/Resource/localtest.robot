*** Settings ***
Library    SeleniumLibrary
*** Keywords ***
Testing
    Open Browser    url=https://qa.symphony4cloud.com/login    browser=Chrome
    Sleep    5
    Maximize Browser Window
    Sleep    30