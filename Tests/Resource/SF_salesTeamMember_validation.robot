*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# ${mobile}    9123456780
# ${email}    abcte5@gmail.com
${VALID_EMAIL_REGEX}    ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
${VALID_MOBILE_REGEX}    ^\\d{10}$
${check_mobile}    ${EMPTY}
${check_email}    ${EMPTY}


# ${symvar('City')}    Mumbai
# @{products}    Caustic Soda Flakes    Linear Alkyl Benzene Sulphonic Acid
@{valid_sales_team}   
*** Keywords ***
Login Page
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_argument    --disable-notifications
    Create WebDriver    Chrome    options=${options}
    Go To    https://basiscloudsolutionspvtltd--dineshdev.sandbox.my.salesforce.com/
    Maximize Browser Window
    Sleep    2
    Input Text    id:username    vijayakumarp@basiscloudsolutions.com.dineshdev
    Input Password    id:password    %{Dinesh_SF_Password}
    Sleep    2
    Click Element    id:Login
    Sleep    10

validation of mobile and email
    ${check_mobile}=    Run Keyword And Return Status    Should Match Regexp    ${symvar('mobile_no')}    ${VALID_MOBILE_REGEX}    ✅ Valid Mobile Number: ${symvar('mobile_no')}
    IF    not ${check_mobile}
        ${value}    Set Variable   In-Valid Mobile Number: ${symvar('mobile_no')}
        Log To Console    **gbStart**check_mobile**splitKeyValue**${value}**gbEnd**     
    END
    ${check_email}=    Run Keyword And Return Status    Should Match Regexp    ${symvar('email_id')}    ${VALID_EMAIL_REGEX}    ✅ Valid Email Id: ${symvar('email_id')}
    IF    not ${check_email}
        ${value_log_email}    Set Variable    In-Valid email id: ${symvar('email_id')}
        Log To Console    **gbStart**check_email**splitKeyValue**${value_log_email}**gbEnd**     
    END
    [Return]    ${check_mobile}    ${check_email}
sales_team
    Click Element    xpath://one-app-nav-bar-item-root[@data-id='0QkC10000001AyJKAU']
    Sleep    5
    Click Element   xpath://button[@title='Select a List View: Sales Team']
    Sleep    2
    Click Element    xpath://span[normalize-space(text())='All']
    Sleep    2
    Click Element    xpath://input[@placeholder='Search this list...']
    Input Text    xpath://input[@placeholder='Search this list...']    ${symvar('City')}
    Press Keys    xpath://input[@placeholder='Search this list...']    ENTER
    Sleep    3
    ${rows}=     Get Element Count    xpath=//table[@aria-label='All']//tbody//tr
    Log To Console    ${rows}
    
    FOR    ${row}    IN RANGE    1    ${rows}+1
        @{cells}=    Get WebElements    xpath=(//th[@scope='row'])[${row}]
        FOR    ${cell}    IN    @{cells}
           ${cell_text}=    Get Text    ${cell}
           Log to console    Cell: ${cell_text}
           ${sales_team} =    Evaluate    ${valid_sales_team} + ["${cell_text}"]
        END
        
    END  
    Set Global Variable    ${valid_sales_team}    ${sales_team}
NEW LEAD
    click element    xpath=//one-app-nav-bar-item-root[contains(.,'LeadsLeads List')]
    Sleep    4   
    click element    xpath://button[normalize-space(text())='New']
    Sleep    5
    Click Button    xpath://button[@aria-label='Salutation']
    Sleep    2
    Click Element  xpath=//lightning-base-combobox-item[@data-value='${symvar('Salutation')}']    
    Sleep    5
    Input Text    xpath://input[@placeholder='First Name']    ${symvar('firstname')}
    Sleep    1
    Input Text     xpath://input[@placeholder='Last Name']    ${symvar('lastname')}   
    Sleep    1
    Input Text    xpath://input[@name='Phone']    ${symvar('mobile_no')}
    Sleep    2
    Run Keyword And Ignore Error    Scroll Element Into View    xpath://div[normalize-space(text())='Product']
    Input Text    xpath://input[@name='Company']    BCS
    Sleep    2
    Input Text    xpath://input[@inputmode='email']    ${symvar('email_id')}
    Sleep    3
    Run Keyword And Ignore Error    Scroll Element Into View    xpath://label[normalize-space(text())='Title']
    Sleep    5  
    @{products}=    %{products}
    Log To Console     @{products}
    Sleep    3
    FOR    ${PRODUCT}    IN    @{PRODUCTS}
        Sleep    5
        Wait Until Element Is Visible    xpath://div[@data-value='${PRODUCT}']    timeout=10s
        Wait Until Element Is Enabled    xpath://div[@data-value='${PRODUCT}']    timeout=10s
        Sleep    2
        Click Element    xpath://div[@data-value='${PRODUCT}']
        Sleep    4
        Click Button    xpath://button[@title='Move to Chosen']
        Sleep    3        
    END
    Run Keyword And Ignore Error    Scroll Element Into View    xpath://span[normalize-space(text())='Web Quote']
    Sleep    5
    Click Button    xpath://button[@aria-label='Quantity']
    Sleep    2
    Click Element  xpath=//lightning-base-combobox-item[@data-value='${symvar('Quantity')}']    
    Sleep    1
    Run Keyword And Ignore Error    Scroll Element Into View    xpath://span[normalize-space(text())='Additional Information']
    Sleep    5
    Click Element    xpath=//textarea[@name='street']
    Input Text    xpath=//textarea[@name='street']    ${symvar('street')}
    Sleep    4
    Input Text    xpath://input[@name='city']    ${symvar('City')}
    Sleep    2
    Input Text    xpath://input[@name='postalCode']    ${symvar('postalCode')}
    Sleep    2
    Input Text   xpath://input[@name='province']    ${symvar('province')}
    Sleep    2
    Input Text    xpath://input[@name='country']    ${symvar('country')}
    Sleep    2
    Click Button    xpath://button[@name='SaveEdit']
    Sleep    5

sales team validation 
    # ${sales_team} =    sales_team
    Click Element    xpath://li[@data-label='Details']
    Sleep    2
    Run Keyword And Ignore Error   Scroll Element Into View    xpath://button[contains(.,'Address Information')]
    Sleep    5
    Wait Until Element Is Visible    xpath://force-lookup[@data-output-element-id='output-field']//a//slot//slot//span[normalize-space()]    10s
    ${assigned_Sales_person}=    Get Text    xpath://div[contains(@class, 'slds-form-element__control')]//a[contains(@href, '/lightning/r/Sales_Team__c')]//span
    ${assigned_Sales_person}=    Get Text    xpath://force-lookup[@data-output-element-id='output-field']//a//slot//slot//span[normalize-space()]
    ${is_member}=    Evaluate    '${assigned_Sales_person}' in ${valid_sales_team}
    IF    ${is_member}
        ${validation} =    set variable    ${assigned_Sales_person} is one of the sales team member from ${symvar('City')}
        Log to console    **gbStart**copilot_validation_team member**splitKeyValue**${validation}**gbEnd**
    ELSE
        ${validation} =    set variable    ${assigned_Sales_person} is not sales team from  ${symvar('City')}
        Log to console    **gbStart**copilot_validation_team member**splitKeyValue**${validation}**gbEnd**
    END
    

