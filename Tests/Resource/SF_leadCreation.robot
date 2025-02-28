*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${mobile}    9123456780
${email}    abcte5@gmail.com
@{search_values}   ${mobile}   ${email}
${merged_message}    ${EMPTY}
${VALID_EMAIL_REGEX}    ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
${VALID_MOBILE_REGEX}    ^\\d{10}$
${check_mobile}    ${EMPTY}
${check_email}    ${EMPTY}
*** Keywords ***
Login Page
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_argument    --disable-notifications
    Create WebDriver    Chrome    options=${options}
    Go To    https://basiscloudsolutionspvtltd--vishnudev.sandbox.my.salesforce.com/
    Maximize Browser Window
    Sleep    2
    Input Text    id:username    vijayakumarp@basiscloudsolutions.com.vishnudev
    Input Password    id:password    Vishnudev@21
    Sleep    2
    Click Element    id:Login
    Sleep    5

validation of mobile and email
    ${check_mobile}=    Run Keyword And Return Status    Should Match Regexp    ${mobile}    ${VALID_MOBILE_REGEX}    ✅ Valid Mobile Number: ${mobile}
    IF    not ${check_mobile}
        Log To Console    **gbStart**check_mobile**splitKeyValue**❌ In-Valid Mobile Number: ${mobile}**gbEnd**     
    END
    ${check_email}=    Run Keyword And Return Status    Should Match Regexp    ${email}    ${VALID_EMAIL_REGEX}    ✅ Valid Email Id: ${email}
    IF    not ${check_email}
        Log To Console    **gbStart**check_email**splitKeyValue**❌ In-Valid email id: ${email}**gbEnd**     
    END
    [Return]    ${check_mobile}    ${check_email}
Lead creation
    ${check_mobile}    ${check_email}=    Validation of Mobile and Email
    ${message_email_Check}=     Set Variable    ${EMPTY}
    ${message_mobile_Check}=    Set Variable    ${EMPTY}
    IF    ${check_mobile} and ${check_email}
        click element    xpath=//one-app-nav-bar-item-root[contains(.,'LeadsLeads List')]
        Sleep    4        
        Input Text    xpath://input[@placeholder='Search this list...']    ${email}
        Press Keys    xpath://input[@placeholder='Search this list...']    ENTER
        Sleep    5
        Capture page Screenshot    
        ${message_email_Check} =    Run Keyword And Return Status    Page Should Contain    ${email}
        Sleep    2
        IF    ${message_email_Check}
            Log To Console    **gbStart**email_validation**splitKeyValue** Email_id ${email} already exists!  please try with new mail**gbEnd**     
        END
        Clear Element Text    xpath://input[@placeholder='Search this list...']
        Input Text    xpath://input[@placeholder='Search this list...']    ${mobile}
        Press Keys    xpath://input[@placeholder='Search this list...']    ENTER
        Sleep    5
        Capture page Screenshot     
        ${message_mobile_Check} =    Run Keyword And Return Status    Page Should Contain    ${mobile}
        Sleep    2
        IF    ${message_mobile_Check}
            Log To Console    **gbStart**mobile_validation**splitKeyValue** Mobile number ${mobile} already exists!  please try with new mobile number**gbEnd**     
        END
        IF   not ${message_email_Check} and not ${message_mobile_Check} 
            NEW LEAD
        END
    END
    
        
NEW LEAD
    click element    xpath://a[@title='New']
    Sleep    5
    Click Button    xpath://button[@aria-label='Salutation']
    Sleep    2
    Click Element  xpath=//lightning-base-combobox-item[@data-value='Mr.']    
    Sleep    1
    Input Text    xpath://input[@placeholder='First Name']    sre
    Sleep    1
    Input Text     xpath://input[@placeholder='Last Name']    kumar   
    Sleep    1
    Input Text    xpath:(//label[contains(.,'*Phone')]/following::input)[1]    ${mobile}
    Sleep    1
    Input Text    xpath:(//label[contains(.,'*Company')]/following::input)[1]    BCS
    Sleep    1
    Input Text    xpath://input[@inputmode='email']    ${email}
    Sleep    3
    Run Keyword And Ignore Error    Scroll Element Into View    xpath://label[contains(.,'*States')]
    Click Button    xpath://button[@aria-label='View all dependencies for Product']
    Sleep    5
    Click Button  xpath:(//button[@aria-label='Product'])[2]
    Sleep    2
    Click Element  xpath=//lightning-base-combobox-item[@data-value='Caustic Soda Flakes']
    Sleep    2
    Click Button    xpath://button[@value='apply']   
    Sleep    3 
    Run Keyword And Ignore Error    Scroll Element Into View    xpath:(//label[normalize-space(text())='No. of Employees']/following::input)[1]
    Sleep    5    
    click button    xpath://button[@data-value='--None--' and @aria-label='States']
    Sleep    2
    Click Element    xpath://lightning-base-combobox-item[@data-value='TamilNadu']  
    Sleep    4
    Click Button    xpath:(//li[@role='presentation']//button)[3]
    Sleep    2

    


