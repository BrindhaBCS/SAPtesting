*** Settings ***
Library     SeleniumLibrary

*** Keywords ***
Start TestCase
    Log    Opening browser
    Open Browser    ${symvar('url')}    ${symvar('browser')}    
    
Submit Anugal username and password
    Wait until element is visible    ${symvar('user_text_box')}
    Sleep    10
   
    Click Element    xpath:(//div[@class='MuiStack-root css-1ed5314']//button)[2]
    Sleep    5
    Input Text   xpath://*[@id="i0116"]    malayranjan.s@basiscloudsolutions.com
    Sleep    3
    Click Element    xpath://*[@id="idSIButton9"]

    Wait Until Element Is Visible    xpath://*[@id="i0118"]    60s
    Input Text    xpath://*[@id="i0118"]    Malay@Ranjan!@#
    Click Element    xpath://*[@id="idSIButton9"]
    Sleep    2
    Click Element    xpath://*[@id="idBtn_Back"]
    Sleep    5

    Maximize Browser Window
    Sleep    20

Create User_id
    Click Element    xpath://span[text()='Admin']
    Sleep    5
    Click Element    xpath://div[text()='User Administration']
    Sleep    2
    Click Element    xpath://button[text()='Add User']
    Sleep    4
    Click Element    id:mui-component-select-userType
    Sleep    1
    Click Element    xpath://li[@data-value='User']
    Sleep    1
    Click Element    id:mui-component-select-roleName
    Sleep    1
    Click Element    xpath://li[@data-value='User']
    Sleep    1
    Input Text    name:firstName    Malay
    Sleep    1
    Input Text    name:lastName    Sahu
    Sleep    1
    Input Text    name:userId    Malays
    Sleep    1
    Input Text    name:email    malayranjan.s@basiscloudsolutions.com
    Sleep    1
    Input Text    name:validFrom    11-06-2024
    Sleep    1
    Input Text    name:validTo    11-06-2025
    Sleep    1
    Click Element    id:demo-multiple-checkbox
    Sleep    1
    Click Element    xpath:(//input[@type='checkbox'])[3]
    Sleep    1
    Click Element    xpath://div[contains(@class,'MuiBackdrop-root MuiBackdrop-invisible')]
    Sleep    2    
    Click Element    xpath://button[text()='Add']
    Sleep    7
View the User id
    Click Element    xpath:(//span[@aria-label='view'])[1]
    Sleep    2
    Click Element    xpath:(//div[@role='button'])[1]
    Sleep    2
    Click Element    xpath:(//div[@role='button'])[2]
    Sleep    2
    Click Element    xpath://div[contains(@class,'jss161 MuiBox-root')]
    Sleep    1   
    
Edit the User id
    Click Element    xpath:(//span[@aria-label='edit'])[1]
    Sleep    1
    Input Text    name:firstName    Ranjan  
    Sleep    2
    Click Element    xpath://button[text()='Save']
    Sleep    5

Delete user id
    Click Element    xpath:(//span[@aria-label='delete'])[1]
    Sleep    2
    Input Text    name:deleteRole    malayranjan.s@basiscloudsolutions.com   
    Sleep    2
    Click Element    xpath://button[text()='Delete']
    Sleep    2

Finish TestCase
    Close All Browsers    

