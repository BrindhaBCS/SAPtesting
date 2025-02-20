*** Settings ***
Library    SeleniumLibrary
Library    String
Library    BuiltIn
*** Variables ***
${FORM_URL}    https://basiscloudsolutionspvtltd--vishnudev.sandbox.my.site.com/standard/s/
${BROWSER}    CHROME
${EMAIL_PATTERN}   ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
${MOBILE_PATTERN}   ^\d{10}$    # This regex ensures exactly 10 digits
*** Keywords ***
Create_Lead
    Open Browser    ${FORM_URL}    ${BROWSER}
    Sleep    5
    Maximize Browser Window
    Input Text    xpath:(//label[normalize-space(text())='First Name']/following::input)[1]    ${symvar('firstname')}
    Sleep    2
    Input Text    xpath:(//label[normalize-space(text())='Last Name']/following::input)[1]    ${symvar('lastname')}
    Sleep    2
    Input Text    xpath:(//label[normalize-space(text())='Company']/following::input)[1]    ${symvar('company')}
    Sleep    2
    ${mobile}=  Set Variable  ${symvar('mobile_no')}
    ${is_valid_mobile_no}=  Run Keyword And Return Status  Should Match Regexp  ${mobile}  ${MOBILE_PATTERN}
    IF  ${is_valid_mobile_no}  
        ${log_message}=  Set Variable  Mobile number is valid: ${mobile}
        Log  message=${log_message}  formatter=repr  
        Log To Console    **gbStart**Idoc_status**splitKeyValue**INFO**${log_message}**gbEnd**  
        Input Text  xpath=(//label[normalize-space(text())='Mobile']/following::input)[1]  ${mobile}
    ELSE  
        ${log_message}=  Set Variable  Mobile number is invalid: ${mobile}
        Log  message=${log_message}  formatter=repr  
        Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**         
        IF  not "${mobile}".isdigit()  
            ${log_message}=  Set Variable  Mobile number should contain only digits
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**
        ELSE IF  len("${mobile}") < 10  
            ${log_message}=  Set Variable  Mobile number is too short (less than 10 digits)
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**
        ELSE IF  len("${mobile}") > 10  
            ${log_message}=  Set Variable  Mobile number is too long (more than 10 digits)
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**
        ELSE  
            ${log_message}=  Set Variable  Mobile number is invalid for unknown reasons
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**
        END  
        Log  message=${log_message}  formatter=repr  
        Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**  
    END  
    Sleep    2
    ${email}=  Set Variable  ${symvar('email_id')}
    ${is_valid_email}=  Run Keyword And Return Status  Should Match Regexp  ${email}  ${EMAIL_PATTERN}

    IF  ${is_valid_email}  
        ${log_message}=  Set Variable  Email is valid: ${email}
        Log  message=${log_message}  formatter=repr  
        Log To Console    **gbStart**Idoc_status**splitKeyValue**INFO**${log_message}**gbEnd**  
        Input Text  xpath=(//label[normalize-space(text())='Email']/following::input)[1]  ${email}
    ELSE  
        ${log_message}=  Set Variable  Email is invalid: ${email}
        Log  message=${log_message}  formatter=repr  
        Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**  
        IF  "@" not in "${email}"  
            ${log_message}=  Set Variable  Email is invalid: Missing @ symbol
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**
        ELSE IF  "${email}".startswith("@")  
            ${log_message}=  Set Variable  Email is invalid: Missing username
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**
        ELSE IF  "${email}".endswith("@")  
            ${log_message}=  Set Variable  Email is invalid: Missing domain
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**
        ELSE IF  "." not in "${email.split('@')[-1]}"  
            ${log_message}=  Set Variable  Email is invalid: Missing top-level domain
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**
        ELSE  
            ${log_message}=  Set Variable  Email is invalid: Unknown format issue
            Log  message=${log_message}  formatter=repr  
            Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**
        END  
        Log  message=${log_message}  formatter=repr  
        Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**${log_message}**gbEnd**  
    END  
    Sleep    2
    Click Element    xpath://button[@aria-label='State']
    Sleep    2
    Click Element    xpath://lightning-base-combobox-item//span[contains(text(), '${symvar('state')}')]
    Sleep    2
    Click Element    xpath://button[@aria-label='Product']
    Sleep    2
    Click Element    xpath://lightning-base-combobox-item//span[contains(text(), '${symvar('Product')}')]
    Sleep    2
    Click Element    xpath://button[@aria-label='Quantity']
    Sleep    2
    Click Element    xpath://lightning-base-combobox-item//span[contains(text(), '${symvar('Quantity')}')]
    Sleep    2
    Click Element    xpath://button[@aria-label='Lead Source']
    Sleep    2
    Click Element    xpath://lightning-base-combobox-item//span[contains(text(), '${symvar('Lead_Source')}')]
    Sleep    2
    IF  ${is_valid_mobile_no} and ${is_valid_email}  
        Log  message=All validations passed! Clicking Submit...  formatter=repr  
        Log To Console    **gbStart**Idoc_status**splitKeyValue**INFO**All validations passed! Clicking Submit...**gbEnd**  
        Click Element  xpath://button[normalize-space(text())='Submit']
    ELSE  
        Log  message=Cannot create lead. Invalid Mobile or Email.  formatter=repr  
        Log To Console    **gbStart**Idoc_status**splitKeyValue**ERROR**Cannot create lead. Invalid Mobile or Email.**gbEnd**  
    END