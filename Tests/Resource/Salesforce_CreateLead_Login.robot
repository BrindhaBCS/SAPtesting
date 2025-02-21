*** Settings ***
Library    SeleniumLibrary
Library    String
Library    BuiltIn
*** Variables ***
${Login_URL}    https://basiscloudsolutionspvtltd--vishnudev.sandbox.my.salesforce.com/
${BROWSER}    CHROME
${EMAIL_PATTERN}   ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
${MOBILE_PATTERN}   ^\\d{10}$    # This regex ensures exactly 10 digits
${CHROME_OPTIONS}    add_argument("--disable-notifications")
*** Keywords ***
Create_Lead_login
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --disable-notifications
    ${driver}=    Create WebDriver    Chrome    options=${options}
    Go To    ${Login_URL}
    Maximize Browser Window
    Input Text    id:username    vijayakumarp@basiscloudsolutions.com.vishnudev
    Sleep    2
    Input Password    id:password    %{Salesforce_Password}
    # Input Password    id:password    ${symvar('Salesforce_Password')}
    Sleep    2
    Click Element    xpath://input[@id='Login']
    Sleep    5
    Click Element    xpath://one-app-nav-bar-item-root[contains(.,'LeadsLeads List')]
    Sleep    2
    Click Element    xpath://div[normalize-space(text())='New']
    Sleep    5
    Click Element    xpath://button[@aria-label='Lead Status']
    Sleep    2
    Click Element    xpath://lightning-base-combobox-item//span[contains(text(), '${symvar('Lead_Status')}')]
    Sleep    2
    Input Text    xpath://input[@placeholder='Last Name']    ${symvar('lastname')}
    Sleep    2
    Input Text    xpath://input[@name='Company']    ${symvar('company')} 
    Sleep    2
    # Click Element    xpath://button[@aria-label='Lead Status']
    # Sleep    2
    # Click Element    xpath://lightning-base-combobox-item//span[contains(text(), '${symvar('Lead_Status')}')]
    # Sleep    2
    ${mobile}=  Set Variable  ${symvar('mobile_no')}
    ${is_valid_mobile_no}=  Run Keyword And Return Status  Should Match Regexp  ${mobile}  ${MOBILE_PATTERN}
    IF  ${is_valid_mobile_no}  
        ${log_message}=  Set Variable  Mobile number is valid: ${mobile}
        Log  message=${log_message}  formatter=repr  
        Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd**
        Input Text    xpath:(//label[contains(.,'*Phone')]/following::input)    ${mobile}
    ELSE  
        ${log_message}=  Set Variable  Mobile number is invalid: ${mobile}
        Log  message=${log_message}  formatter=repr       
        Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd**  
        IF  not "${mobile}".isdigit()  
            ${log_message}=  Set Variable  Mobile number should contain only digits
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
        ELSE IF  len("${mobile}") < 10  
            ${log_message}=  Set Variable  Mobile number is too short (less than 10 digits)
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
        ELSE IF  len("${mobile}") > 10  
            ${log_message}=  Set Variable  Mobile number is too long (more than 10 digits)
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
        ELSE  
            ${log_message}=  Set Variable  Mobile number is invalid for unknown reasons
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
        END  
        Log  message=${log_message}  formatter=repr  
        Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
    END  
    Sleep    2
    ${email}=  Set Variable  ${symvar('email_id')}
    ${is_valid_email}=  Run Keyword And Return Status  Should Match Regexp  ${email}  ${EMAIL_PATTERN}
    IF  ${is_valid_email}  
        ${log_message}=  Set Variable  Email is valid: ${email}
        Log  message=${log_message}  formatter=repr  
        Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
        Input Text  xpath:(//label[contains(.,'*Email')]/following::input)  ${email}
    ELSE  
        ${log_message}=  Set Variable  Email is invalid: ${email}
        Log  message=${log_message}  formatter=repr  
        Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
        IF  "@" not in "${email}"  
            ${log_message}=  Set Variable  Email is invalid: Missing @ symbol
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
        ELSE IF  "${email}".startswith("@")  
            ${log_message}=  Set Variable  Email is invalid: Missing username
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
        ELSE IF  "${email}".endswith("@")  
            ${log_message}=  Set Variable  Email is invalid: Missing domain
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
        ELSE IF  "." not in "${email.split('@')[-1]}"  
            ${log_message}=  Set Variable  Email is invalid: Missing top-level domain
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
        ELSE  
            ${log_message}=  Set Variable  Email is invalid: Unknown format issue
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
        END  
        Log  message=${log_message}  formatter=repr  
        Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**${log_message}**gbEnd** 
    END      
    ${product_element}    Get WebElement    xpath=//button[contains(@class, 'slds-combobox__input') and @aria-label='Product']
    Execute JavaScript    arguments[0].scrollIntoView(true);    ARGUMENTS    ${product_element}
    Click Element    ${product_element}
    Sleep    2
    Click Element    xpath://lightning-base-combobox-item//span[contains(text(), '${symvar('Product')}')]
    Sleep    2
    ${quantity_element}    Get WebElement    xpath=//label[text()='Quantity']/following-sibling::div
    Execute JavaScript    arguments[0].scrollIntoView(true);    ARGUMENTS    ${quantity_element}
    Click Element    ${quantity_element}
    Sleep    2
    Click Element    xpath://lightning-base-combobox-item//span[contains(text(), '${symvar('Quantity')}')]
    Sleep    2
    ${state_element}    Get WebElement    xpath=//label[text()='States']/following-sibling::div
    Execute JavaScript    arguments[0].click();    ARGUMENTS    ${state_element}
    Click Element    ${state_element}
    Sleep    2
    Click Element    xpath://lightning-base-combobox-item//span[contains(text(), '${symvar('state')}')]
    Sleep    2
    IF  ${is_valid_mobile_no} and ${is_valid_email}  
        Log  message=All validations passed! Clicking Submit...  formatter=repr  
        Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**All validations passed! Clicking Submit...**gbEnd**
        Click Element    xpath://button[@name='SaveEdit']
        Sleep    2
        Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**Lead for ${symvar('lastname')} created successfully...**gbEnd**
    ELSE  
        Log  message=Cannot create lead. Invalid Mobile or Email.  formatter=repr  
        Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**Cannot create lead. Invalid Mobile or Email.**gbEnd**
    END