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
    ${is_valid}=  Run Keyword And Return Status  Should Match Regexp  ${mobile}  ${MOBILE_PATTERN}
    IF  ${is_valid}  
        Log  message=Mobile number is valid: ${mobile}  formatter=repr  
        Input Text  xpath=(//label[normalize-space(text())='Mobile']/following::input)[1]  ${mobile}
    ELSE  
        Log  message=Mobile number is invalid: ${mobile}  formatter=repr  
        IF  not "${mobile}".isdigit()  
            Log  message=Mobile number should contain only digits  formatter=repr  
        ELSE IF  len("${mobile}") < 10  
            Log  message=Mobile number is too short (less than 10 digits)  formatter=repr  
        ELSE IF  len("${mobile}") > 10  
            Log  message=Mobile number is too long (more than 10 digits)  formatter=repr  
        ELSE  
            Log  message=Mobile number is invalid for unknown reasons  formatter=repr  
        END  
    END  
    Sleep    2
    ${email}=  Set Variable  ${symvar('email_id')}
    ${is_valid}=  Run Keyword And Return Status  Should Match Regexp  ${email}  ${EMAIL_PATTERN}
    IF  ${is_valid}  
        Log  message=Email is valid: ${email}  formatter=repr  
        Input Text  xpath=(//label[normalize-space(text())='Email']/following::input)[1]  ${email}
    ELSE  
        Log  message=Email is invalid: ${email}  formatter=repr  
        IF  "@" not in "${email}"  
            Log  message=Email is invalid: Missing @ symbol  formatter=repr  
        ELSE IF  "${email}".startswith("@")  
            Log  message=Email is invalid: Missing username  formatter=repr  
        ELSE IF  "${email}".endswith("@")  
            Log  message=Email is invalid: Missing domain  formatter=repr  
        ELSE IF  "." not in "${email.split('@')[-1]}"  
            Log  message=Email is invalid: Missing top-level domain  formatter=repr  
        ELSE  
            Log  message=Email is invalid: Unknown format issue  formatter=repr  
        END  
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
    Click Element    xpath://button[normalize-space(text())='Submit']
    Sleep    2