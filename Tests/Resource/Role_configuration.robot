*** Settings ***
Library     SeleniumLibrary

*** Keywords ***
Start TestCase
    Log    Opening browser
    Open Browser    ${angvar('url')}    ${angvar('browser')}    #options=${global_browser_options}
    
Submit Anugal username and password
    Wait until element is visible    ${angvar('user_text_box')}
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

Role_configuartion
    Click Element    xpath://span[text()='Admin']
    Sleep    5        
    Click Element    xpath://div[text()='Role Configuration']
    Sleep    5
    Click Element    xpath://button[text()='Create New Role']
    Sleep    2

    Input Text    id:roleConfigName    Anugal@123
    Sleep    1
    Input Text    id:roleConfigDescription    Anugal@test
    Sleep    1

    Click Element    name:User Administration
    Sleep    2
    Execute Javascript    window.scrollTo(0,400)
    Sleep    2

    Click Element    name:My Access
    Sleep    2

    Click Element    name:Status
    Sleep    2

    Click Element    xpath://button[text()='Next']
    Sleep    5
    Click Element    xpath://button[text()='Create']
    Sleep    9

Provisioning the role
    Click Element    xpath:(//input[@type='checkbox'])[1]
    Sleep    2
    Click Element    xpath://button[text()='Confirm']
    Sleep    5


View the role
    Click Element    xpath:(//span[@aria-label='view'])[1]
    Sleep    2
    Click Element    xpath:(//div[@role='button'])[1]
    Sleep    2
    Click Element    xpath:(//div[@role='button'])[2]
    Sleep    2
    Click Element    xpath://body/div[2]/div[3]/div[1]/div[1]
    Sleep    2

Edit the role
    Click Element    xpath:(//span[@aria-label='edit'])[1]
    Sleep    5
    Click Element    xpath:(//input[@name='approver'])[2]
    Sleep    2
    Click Element    xpath://button[text()='Next']
    Sleep    2
    Click Element    xpath://span[@sx='[object Object]']//button[1]
    Sleep    8

Delete the role
    Click Element    xpath:(//span[@aria-label='delete'])[1]
    Sleep    2
    Input Text    name:deleteRole    Anugal@123
    Sleep    2
    Click Element    xpath://button[text()='Delete']
    Sleep    5

Finish TestCase
    Close All Browsers     




