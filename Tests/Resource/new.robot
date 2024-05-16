*** Settings ***
Library    SeleniumLibrary
Library    collections
Library    OperatingSystem
Test Tags    Ph_001
*** Variables ***
${url}    https://www.google.com/
*** Keywords ***
chrome_incognitoz
    ${options}=    Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    Call Method    ${options}    add_argument    incognito
    Create WebDriver    Chrome    chrome_options=${options}
    Sleep    4
***Test Case***
chrome_incognitoz
    chrome_incognitoz
