*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# ${mobile}    ${symvar('mobile_no')}
# ${email}    ${symvar('email_id')}
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
    Input Password    id:password    %{Salesforce_Password}
    Sleep    2
    Click Element    id:Login
    Sleep    5

validation of mobile and email
    ${mobile}    Set Variable    ${symvar('mobile_no')}
    ${email}     Set Variable   ${symvar('email_id')}
    ${check_mobile}=    Run Keyword And Return Status    Should Match Regexp    ${mobile}    ${VALID_MOBILE_REGEX}    ✅ Valid Mobile Number: ${mobile}
    IF    not ${check_mobile}
        Log To Console    **gbStart**copilot_check_mobile**splitKeyValue**Invalid Mobile Number ${mobile}**gbEnd**     
    END
    ${check_email}=    Run Keyword And Return Status    Should Match Regexp    ${email}   ${VALID_EMAIL_REGEX}    ✅ Valid Email Id: ${email}
    IF    not ${check_email}
        Log To Console    **gbStart**copilot_check_email**splitKeyValue**Invalid email id ${email}**gbEnd**     
    END
    [Return]    ${check_mobile}    ${check_email}
Lead creation
    ${check_mobile}    ${check_email}=    Validation of Mobile and Email
    ${message_email_Check}=     Set Variable    ${EMPTY}
    ${message_mobile_Check}=    Set Variable    ${EMPTY}
    ${mobile}    Set Variable    ${symvar('mobile_no')}
    ${email}     Set Variable   ${symvar('email_id')}
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
            Log To Console    **gbStart**copliot_email_validation**splitKeyValue** Emailid ${email}already exists!  please try with other mail**gbEnd**     
        END
        Clear Element Text    xpath://input[@placeholder='Search this list...']
        Input Text    xpath://input[@placeholder='Search this list...']    ${mobile}
        Press Keys    xpath://input[@placeholder='Search this list...']    ENTER
        Sleep    5
        Capture page Screenshot     
        ${message_mobile_Check} =    Run Keyword And Return Status    Page Should Contain    ${mobile}
        Sleep    2
        IF    ${message_mobile_Check}
            Log To Console    **gbStart**mobile_validation**splitKeyValue**` Mobile number ${mobile} already exists!  please try with new mobile number`**gbEnd**     
        END
        IF   not ${message_email_Check} and not ${message_mobile_Check} 
            NEW LEAD
        END
    END
    
        
NEW LEAD
    ${mobile}    Set Variable    ${symvar('mobile_no')}
    ${email}     Set Variable   ${symvar('email_id')}
    click element    xpath://a[@title='New']
    Sleep    5
    Click Button    xpath://button[@aria-label='Salutation']
    Sleep    2
    Click Element  xpath=//lightning-base-combobox-item[@data-value='${symvar('salutation')}']    
    Sleep    1
    Input Text    xpath://input[@placeholder='First Name']    ${symvar('firstname')}
    Sleep    1
    Input Text     xpath://input[@placeholder='Last Name']    ${symvar('lastname')}   
    Sleep    1
    Input Text    xpath:(//label[contains(.,'*Phone')]/following::input)[1]    ${mobile}
    Sleep    1
    Input Text    xpath:(//label[contains(.,'*Company')]/following::input)[1]    ${symvar('company')}
    Sleep    1
    Input Text    xpath://input[@inputmode='email']    ${email}
    Sleep    3
    Run Keyword And Ignore Error    Scroll Element Into View    xpath://label[contains(.,'*States')]
    Click Button    xpath://button[@aria-label='View all dependencies for Product']
    Sleep    5
    Click Button  xpath:(//button[@aria-label='Product'])[2]
    Sleep    2
    Click Element  xpath=//lightning-base-combobox-item[@data-value='${symvar('Product')}']
    Sleep    2
    Click Button    xpath://button[@value='apply']   
    Sleep    3 
    Run Keyword And Ignore Error    Scroll Element Into View    xpath:(//label[normalize-space(text())='No. of Employees']/following::input)[1]
    Sleep    5    
    click button    xpath://button[@data-value='--None--' and @aria-label='States']
    Sleep    2
    Click Element    xpath://lightning-base-combobox-item[@data-value='${symvar('state')}']  
    Sleep    4
    Click Button    xpath:(//li[@role='presentation']//button)[3]
    Sleep    2

    


