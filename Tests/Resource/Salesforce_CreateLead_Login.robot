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
${SEARCH_FIELD}    xpath://input[@aria-label='Search this list...']
${LEAD_STATUS_XPATH}    xpath=//lightning-formatted-text[@data-output-element-id='output-field']
${LOG_A_CALL_XPATH}    xpath=//lightning-icon[contains(@class, 'slds-icon-standard-log-a-call')]
${TEXTAREA_XPATH}    xpath=//textarea[contains(@class, 'textarea textarea')]
${SAVE_BUTTON_XPATH}    xpath=//button[span[contains(text(), 'Save')]]
${EDIT_BUTTON_XPATH}    xpath=//button[contains(@class, 'test-id__inline-edit-trigger')]
${STATUS_DROPDOWN_XPATH}    xpath=//button[@aria-label='Lead Status']
${CONTACTED_OPTION_XPATH}    xpath://lightning-base-combobox-item//span[contains(text(), 'Contacted')]
*** Keywords ***
Check If Entry Exists
    [Arguments]    ${value}  # This accepts the mobile number or email ID
    Clear Element Text    ${SEARCH_FIELD}
    Input Text    ${SEARCH_FIELD}    ${value}
    Sleep    2s   # Wait for search results to load
    ${result}    Run Keyword And Return Status    Page Should Contain    ${value}
    RETURN    ${result}

Create_Lead_login
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
    
    ${mobile_exists}    Check If Entry Exists    ${symvar('mobile_no')}
    ${email_exists}    Check If Entry Exists    ${symvar('email_id')}   
    IF    ${mobile_exists} and ${email_exists}
        ${duplicate_entry}    Log    Both Mobile Number ${symvar('mobile_no')} and Email ID ${symvar('email_id')} already exist.
        Log To Console    **gbStart**copilot_Error_status_1**splitKeyValue**${duplicate_entry}**gbEnd**
        Fail    Duplicate entries detected!
    ELSE IF    ${mobile_exists}
        ${duplicate_entry}    Log    Mobile number ${symvar('mobile_no')} already exists.
        Log To Console    **gbStart**copilot_Error_status_2**splitKeyValue**${duplicate_entry}**gbEnd**
        Fail    Duplicate mobile number detected!
    ELSE IF    ${email_exists}
        ${duplicate_entry}    Log    Email ID ${symvar('email_id')} already exists.
        Log To Console    **gbStart**copilot_Error_status_3**splitKeyValue**${duplicate_entry}**gbEnd**
        Fail    Duplicate email detected!
    ELSE
        ${duplicate_entry}    Log    No duplicate entry found. Proceeding with the new entry...
        Log To Console    **gbStart**copilot_Error_status_4**splitKeyValue**${duplicate_entry}**gbEnd**
    END

    Click Element    xpath://div[normalize-space(text())='New']
    Sleep    5
    Click Element    xpath://button[@aria-label='Lead Status']
    Sleep    3
    Click Element    xpath://lightning-base-combobox-item//span[contains(text(), '${symvar('Lead_Status')}')]
    Sleep    5
    Input Text    xpath://input[@placeholder='Last Name']    ${symvar('lastname')}
    Sleep    2
    Input Text    xpath://input[@name='Company']    ${symvar('company')} 
    Sleep    2
    
    ${mobile}=  Set Variable  ${symvar('mobile_no')}
    ${is_valid_mobile_no}=  Run Keyword And Return Status  Should Match Regexp  ${mobile}  ${MOBILE_PATTERN}
    IF  ${is_valid_mobile_no}  
        ${log_message}=  Set Variable  Mobile number is valid: ${mobile}
        Log  message=${log_message}  formatter=repr  
        Log To Console    **gbStart**copilot_CreateLead_status_5**splitKeyValue**${log_message}**gbEnd**
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
        Sleep    10
        ${lead_status}    Get Text    ${LEAD_STATUS_XPATH}
        Log    Lead Status: ${lead_status}
        Run Keyword If    '${lead_status}' == 'Contacted'    Perform Contacted Actions
        ...    ELSE IF    '${lead_status}' == 'Open'    Handle Open Lead
        ...    ELSE IF    '${lead_status}' == 'Qualified'    Handle Qualified Lead
        ...    ELSE IF    '${lead_status}' == 'Unqualified'    Handle Unqualified Lead
        ...    ELSE    Log    Unknown Lead Status: ${lead_status}
    ELSE  
        Log  message=Cannot create lead. Invalid Mobile or Email.  formatter=repr  
        Log To Console    **gbStart**copilot_CreateLead_status**splitKeyValue**Cannot create lead. Invalid Mobile or Email.**gbEnd**
    END
Perform Contacted Actions
    Click Element    ${LOG_A_CALL_XPATH}
    Sleep    5
    Input Text    ${TEXTAREA_XPATH}    ${symvar('Call_Status_Message')}
    Sleep    2
    Click Element    xpath://button[@name='SaveEdit']
    Log To Console    **gbStart**copilot_CallLog_status**splitKeyValue**${symvar('Call_Status_Message')} added successfully to ${symvar('lastname')}**gbEnd**
    Sleep    2
Handle Open Lead
    Click Element    ${EDIT_BUTTON_XPATH}
    Sleep    2
    Click Element    ${STATUS_DROPDOWN_XPATH}
    Sleep    2
    Click Element    ${CONTACTED_OPTION_XPATH}
    Sleep    2
    Perform Contacted Actions
Handle Qualified Lead
    Log    Performing actions for Qualified Lead
    # Add steps for Qualified Lead here

Handle Unqualified Lead
    Log    Performing actions for Unqualified Lead
    # Add steps for Unqualified Lead here