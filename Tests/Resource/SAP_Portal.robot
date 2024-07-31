*** Settings ***
Library    SeleniumLibrary


*** Keywords ***
login page
    Open Browser    ${symvar('SAP_portal_url')}    chrome
    Maximize Browser Window
    Sleep    5
    Input Text    id:j_username   ${symvar('SAP_portal_username')}
    Sleep    2
    Click Element    xpath://div[text()='Continue']
    Sleep    20
    # Input Text    id:password    ${symvar('password')}
    Input Text    id:password    %{S_PASSWORD}
    Sleep    5
    Click Element    xpath://button[text()='Sign in']
    Sleep    50

Installation
    Wait Until Element Is Visible    xpath://*[@id="shell-component---application266795052--frame"]   20s
    Select Frame    xpath://*[@id="shell-component---application266795052--frame"]
    Sleep    2
    Wait Until Element Is Visible    xpath://bdi[text()='Search']    10s
    Click Element    xpath://bdi[text()='Search']
    Sleep    5
    Wait Until Element Is Visible    xpath://bdi[text()='Filters']    10s
    Click Element    xpath://bdi[text()='Filters']
    Sleep    2
    Wait Until Element Is Visible    xpath://bdi[text()='Installation']     10s
    Click Element    xpath://bdi[text()='Installation'] 
    Sleep    2
    Input Text    name:Key    ${symvar('Installation_Value')}
    Sleep    2
    Press Keys    xpath://bdi[text()='Installation']   ARROW_DOWN    ENTER   
    Sleep    2
    Click Element    xpath://bdi[text()='OK'] 
    Sleep    2
    Click Element    xpath://bdi[text()='Go'] 
    Sleep    2
    Wait Until Element Is Visible    xpath://span[text()='SAP NetWeaver']    10s
    Click Element    xpath://span[text()='SAP NetWeaver']
    Sleep    5
System_id
    Click Element    xpath://bdi[text()='Filters']
    Sleep    5
    Click Element    name:sysid
    Sleep    2
    Input Text    name:sysid    ${symvar('connection')}
    Sleep    2
    Click Element    xpath://bdi[text()='OK'] 
    Sleep    3
    Click Element    xpath://bdi[text()='Go'] 
    Sleep    3
    Wait Until Element Is Visible    xpath://span[text()='BIS']    10s
    Double Click Element    xpath://span[text()='BIS']
    Sleep    5
Filtering 
    Wait Until Element Is Visible    xpath://bdi[text()='Filters']    10s 
    Click Element    xpath://bdi[text()='Filters'] 
    Sleep    5
    Click Element    name:HWKEY
    Sleep    2
    Input Text    name:HWKEY    ${symvar('HardwareKey')} 
    Sleep    1
    Press Keys       name:HWKEY    ARROW_DOWN    ENTER
    Sleep    2
    Click Element    name:LICENSETYPETEXT
    Sleep    2
    Input Text    name:LICENSETYPETEXT    ${symvar('LicenseType_1')} 
    Sleep    1
    Press Keys       name:LICENSETYPETEXT    ARROW_DOWN    ENTER
    Sleep    2
    Input Text    name:LICENSETYPETEXT    ${symvar('LicenseType_2')} 
    Sleep    1
    Press Keys       name:LICENSETYPETEXT    ARROW_DOWN    ENTER
    Sleep    2
    Click Element    xpath://bdi[text()='OK'] 
    Sleep    2
    Click Element    xpath://bdi[text()='Go'] 
    Sleep    5
Edit
    Click Element    xpath://bdi[text()='Edit'] 
    Sleep    10
    Click Element    xpath://bdi[text()='Continue'] 
    Sleep    10
Generate
    Click Element    xpath://bdi[text()='Generate']
    Sleep    10
Show Filter Bar
    Click Element    xpath://bdi[text()='Show Filter Bar']
    Sleep    3
    Click Element    name:HWKEY
    Sleep    2
    Input Text    name:HWKEY    S0396073254 
    Sleep    1
    Press Keys       name:HWKEY    ARROW_DOWN    ENTER
    Sleep    2
    Click Element    name:LICENSETYPETEXT
    Sleep    2
    Input Text    name:LICENSETYPETEXT    ${symvar('LicenseType_1')} 
    Sleep    1
    Press Keys       name:LICENSETYPETEXT    ARROW_DOWN    ENTER
    Sleep    2
    Input Text    name:LICENSETYPETEXT    ${symvar('LicenseType_2')}
    Sleep    1
    Press Keys       name:LICENSETYPETEXT    ARROW_DOWN    ENTER
    Sleep    2
    Click Element    xpath://bdi[text()='Go'] 
    Sleep    7
    Unselect Frame
    Sleep    2
    Select Frame    xpath://iframe[@id='shell-component---application266795052--frame']
    Sleep    2
    Click Element    xpath://div[@aria-label='Select all rows']
    Sleep    3
Download License Key
    Click Element    xpath://*[@aria-label='Download License Key']
    Sleep    4
close 
    Close All Browsers

