*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}    https://saphana.bcs.com:44302/ui2/nwbc/?sap-nwbc-node=0000000037&sap-nwbc-context=03HM333035D633D33336000128D3C800C23576737406310D0D40D8C42CA3A4A4A0D84A5FBF38B12023312F512F29B9582F393FD7CAC404A847BF34D3483FAF3C2959DF1E28AF9B9C93999A57620BD4A806E2E624E6A59726A6A7DABAFA0100&sap-client=001&sap-language=EN&sap-nwbc-history_item=&sap-theme=sap_corbu
${Browser}    Chrome 
${TEXT3}    A
${CHECKBOX_KEYS}    1
${TEXT_TO_CHECK_Role_Level}    Access Risk Analysis
${TEXT_TO_CHECK_ROLE}    Risk Analysis: Role Level
${TEXT_TO CHECK_RESULTS}    Analysis Results


*** Keywords ***
Click Element If Exists
    [Arguments]    ${locator}
    Run Keyword And Ignore Error    Click Element    ${locator}

Check If Page Contains Text
    [Arguments]    ${text}
    Run Keyword And Continue On Failure    Page Should Contain    ${text}
    ${text_found}=    Run Keyword And Return Status    Page Should Contain    ${text}
    Run Keyword If    ${text_found}    Proceed Further
    ...    ELSE    Exit Test

Proceed Further
    Log    Text is available. Proceeding further...

Exit Test
    Log    Text is not available. Exiting...
    Close Browser
    Fail    Text not found, exiting test.



Export Risk
    Open Browser    ${URL}    ${Browser}    options=add_argument("--ignore-certificate-errors")
    Sleep    5
    Maximize Browser Window
    Sleep    6
    Input Text    id:sap-user    ${symvar('G_Username')}
    Sleep    2
    Input Text    id:sap-password    %{G_Password}
    Sleep    2
    Click Element    xpath://a[normalize-space(text())='Log On']
    Sleep    5
    Click Element If Exists    xpath://*[@id="sapSL_DEFAULT_BUTTON"]
    Sleep    10
    Check If Page Contains Text    ${TEXT_TO_CHECK_Role_Level}
    Repeat Keyword    19 times    Press Keys    NONE    TAB
    # Press Enter
    Press Keys    NONE    ENTER
    Sleep    10
    Switch Window    NEW
    Sleep    2
    Check If Page Contains Text    ${TEXT_TO_CHECK_ROLE}
    Repeat Keyword    5 times    Press Keys    NONE    TAB
    Sleep    3
    Press Keys    NONE    ${symvar('System')}
    Sleep    3
    Repeat Keyword    10 times    Press Keys    NONE    TAB
    Sleep    3
    Press Keys    NONE    ${symvar('role')}
    Sleep    3
    Repeat Keyword    10 times    Press Keys    NONE    TAB
    Sleep    3
    Press Keys    NONE    ${TEXT3}
    Sleep    3
    Repeat Keyword    14 times    Press Keys    NONE    TAB
    Sleep    3
    Press Keys    NONE    ${CHECKBOX_KEYS}
    Sleep    1s  # Adjust sleep time as needed
    Press Keys    NONE    SPACE  
    Sleep    2
    Repeat Keyword    5 times    Press Keys    NONE    TAB
    Sleep    3
    Press Keys    NONE    ${CHECKBOX_KEYS}
    Sleep    1s  # Adjust sleep time as needed
    Press Keys    NONE    SPACE  
    Sleep    2
    Repeat Keyword    3 times    Press Keys    NONE    TAB
    # Press Enter
    Press Keys    NONE    ENTER
    Sleep    5
    Check If Page Contains Text    ${TEXT_TO CHECK_RESULTS}
    Repeat Keyword    13 times    Press Keys    NONE    TAB
    Sleep    5
    # Press Enter
    Repeat Keyword    2 times    Press Keys    NONE    ENTER
    Sleep    5
    Close All Browsers