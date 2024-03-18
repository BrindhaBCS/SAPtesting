
*** Settings ***
Library    SeleniumLibrary

*** Variables ***    
${order_no}        13029138
   
*** Keywords ***
Launch Sales Force
    Open Browser    ${symvar('Sales_URL')}    chrome
    Sleep    10s
    Maximize Browser Window
    Input Text    id:username    ${symvar('login_name')}    
    Input Password    id:password    ${symvar('login_password')}
    Click Element     id:Login
    Sleep    10s

Document Search
    Click Button    //button[@class='slds-button slds-button_neutral search-button slds-truncate']
    Sleep    5s
    Input Text    //input[@placeholder='Search...']    ${symvar('order_no')}
    Sleep    5s
    Press Keys   //input[@placeholder='Search...']    ENTER
    Sleep    2s    
    Click Element    //a[@data-special-link='true']
    Sleep    2s
    Capture Page Screenshot    Document.png
    Sleep    2s

Close Sales Force
    Close All Browsers

