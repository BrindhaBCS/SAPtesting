*** Settings ***
Library    SeleniumLibrary
Library    String
Library    BuiltIn
Library    Process
Library    OperatingSystem
*** Variables ***
${Login_URL}    https://basiscloudsolutionspvtltd--vishnudev.sandbox.my.salesforce.com/
${BROWSER}    CHROME
${EMAIL_PATTERN}   ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
${MOBILE_PATTERN}   ^\\d{10}$    # This regex ensures exactly 10 digits
${CHROME_OPTIONS}    add_argument("--disable-notifications")
${SEARCH_FIELD}    xpath://input[@aria-label='Search this list...']
*** Keywords ***
Create_Multiple_Lead
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --disable-notifications
    ${driver}=    Create WebDriver    Chrome    options=${options}
    Go To    ${Login_URL}
    Maximize Browser Window
    Input Text    id:username    vijayakumarp@basiscloudsolutions.com.vishnudev
    Sleep    2
    # Input Password    id:password    %{Salesforce_Password}
    Input Password    id:password    ${symvar('Salesforce_Password')}
    Sleep    2
    Click Element    xpath://input[@id='Login']
    Sleep    5
    Click Element    xpath://one-app-nav-bar-item-root[contains(.,'LeadsLeads List')]
    Sleep    2
    Click Element    xpath://div[normalize-space(text())='Import']
    Sleep    2
    Click Element    xpath://span[@part='formatted-rich-text'][normalize-space()='Import from File']
    Sleep    2
    Click Element    xpath://button[normalize-space(text())='Next']
    Sleep    2    
    Choose File    xpath=//input[@type='file']    ${symvar('Upload_Filepath')}
    Sleep    3
    Click Element    xpath://button[normalize-space(text())='Next']
    Sleep    5
    Click Element    xpath://button[normalize-space(text())='Start Import']
    Sleep    10
    Log To Console    **gbStart**copilot_Creating Bulk-Lead_status**splitKeyValue**Bulk Lead Created Successfully..**gbEnd**  
    Click Element    xpath://button[normalize-space(text())='Done']
    Sleep    2