*** Settings ***
Documentation    Imports libraries and gets the setup ready for execution.
...  Keywords created are based on http://serhatbolsu.github.io/
...      robotframework-appiumlibrary/AppiumLibrary.html

*** Keywords ***
Uninstall App    ApplicationName
    [Documentation]    Uninstalls the application by application name.
    ...    e.g. of the name could be com.jnj.endeavour.dev
    Run Keyword and Ignore Error  Remove Application  ApplicationName
    
# Scrolling support
Select ${element} After Scrolling
    Wait Until Keyword Succeeds  4x  1 sec  Scroll down until element is found  ${element}
    Click Element  ${element}

Select ${element} After Scrolling Up
    Wait Until Keyword Succeeds  4x  1 sec  Scroll down until element is found  ${element}
    Click Element  ${element}
    
Scroll down until element is found
    [Arguments]  ${element}
    ${status}=  Run Keyword And Return Status  Element Should Be Visible  ${element}
    Run Keyword If  '${status}' == 'False'
    ...  Swipe By Percent  50  50  50  20
    # Fail the keyword if the ${element} was not visible
    Should Be Equal  '${status}'  'True'
    Run Keyword If  '${status}' == 'True'  Swipe By Percent  50  50  50  20

Scroll up until element is found
    [Arguments]  ${element}
    ${status}=  Run Keyword And Return Status  Element Should Be Visible  ${element}
    Run Keyword If  '${status}' == 'False'
    ...  Swipe By Percent  50  20  50  60
    # Fail the keyword if the ${element} was not visible
    Should Be Equal  '${status}'  'True'
    Run Keyword If  '${status}' == 'True'  Swipe By Percent  50  20  50  60
    
# Wait functionality
Wait Then Click Element
    [Documentation]    Wait until page contains supplied element and then Click the element.
    [Arguments]  ${element}
    Wait Until Page Contains Element  ${element}
    Click Element  ${element}

Wait Until Visible Then Click Element
    [Documentation]    Wait until element is visible and then Click the element.
    [Arguments]  ${element}
    Wait Until Element is Visible  ${element}
    Click Element  ${element}

Wait Until Visible Then Click Element With Retry
    [Documentation]    Wait until element is visible and then Click the element. Retry if fails.
    [Arguments]  ${element}
    Wait Until Keyword Succeeds  3x  1 sec  Wait Until Element is Visible  ${element}
    Click Element  ${element}

Wait Until Visible With Retry
    [Documentation]    Wait until element is visible. Retry if fails.
    [Arguments]  ${element}
    Wait Until Keyword Succeeds  3x  1 sec  Wait Until Element is Visible  ${element}

Wait Until Visible Then Get Element Text
    [Documentation]    Wait until element is visible and then get the text of the element.
    [Arguments]  ${element}
    Wait Until Element is Visible  ${element}
    ${ret}=  Get Text  ${element}
    [Return]  ${ret}
    
Wait Then Get Element Text
    [Documentation]    Wait until page contains the supplied element and then get the text of
    ...    the element.
    [Arguments]  ${element}
    Wait Until Page Contains Element  ${element}
    ${ret}=  Get Text  ${element}
    [Return]  ${ret}

Wait Then Assert Element Text
    [Documentation]    Wait until page contains the supplied element and make sure the text is the
    ...    same as that supplied.
    [Arguments]  ${element}  ${text}
    Wait Until Page Contains Element  ${element}
    Element Text Should Be  ${element}  ${text}

Wait Then Assert Element Contains Text
    [Documentation]    Wait until page contains the supplied element and make sure the text of the element
    ...    contains supplied text.
    [Arguments]  ${element}  ${text}
    Wait Until Page Contains Element  ${element}
    Element Should Contain Text  ${element}  ${text}

Wait Until Visible Then Assert Element Contains Text
    [Documentation]    Wait until page contains the supplied element and make sure the text of the element
    ...    contains supplied text.
    [Arguments]  ${element}  ${text}
    Wait Until Element is Visible  ${element}
    Element Should Contain Text  ${element}  ${text}
    
Wait Then Assert Stripped Text
    [Documentation]    Wait until page contains the supplied element and make sure the text is the
    ...    same as that supplied after both texts are stripped of special characters 
    ...    (incl. spaces, html, new lines, carriage returns). 
    [Arguments]  ${element}  ${text}
    Wait Until Page Contains Element  ${element}
    ${element_text}=  Get Text  ${element}
    Compare Stripped Strings  ${element_text}  ${text}

Wait Then Assert Stripped Text With Retry
    [Documentation]    Wait until page contains the supplied element (retry if it doesn't) and make sure the text is the
    ...    same as that supplied after both texts are stripped of special characters 
    ...    (incl. spaces, html, new lines, carriage returns).
    [Arguments]  ${element}  ${text}
    # Wait Until Page Contains Element  ${element}
    Wait Until Keyword Succeeds  3x  1 sec  Wait Until Page Contains Element  ${element}
    ${element_text}=  Get Text  ${element}
    Compare Stripped Strings  ${element_text}  ${text}
    
Wait Until Enabled
    [Documentation]    Wait until page contains the supplied element and make sure it is enabled.
    [Arguments]  ${element}
    Wait Until Page Contains Element   ${element}
    Element Should Be Enabled  ${element}

Wait Until Enabled Then Assert Element Text
    [Documentation]    Wait until element is enabled and make sure the text is the
    ...    same as that supplied.
    [Arguments]  ${element}  ${text}
    Wait Until Page Contains Element   ${element}
    Element Should Be Enabled  ${element}
    Element Text Should Be  ${element}  ${text}

Run Keyword And Warn On Failure
    [Documentation]  Logs a warning when the given keyword fails. Does not fail the keyword.
    [Arguments]  ${keyword}  @{arguments}
    ${result}  ${output}=  Run Keyword And Ignore Error  ${keyword}  @{arguments}
    # ${result}  ${output}=  Run Keyword And Continue On Failure  ${keyword}  @{arguments}
    Run Keyword If  '${result}'!='PASS'
    ...  Run Keywords  Log  ${\n}Warning: Keyword '${keyword} @{arguments}' failed.  WARN
    ...    AND  Capture Page Screenshot
    [Return]  ${output}
    
Element Should Be Visible and Enabled
    [Documentation]  Checks element is enabled and visible.
    [Arguments]  ${element}
    # Element Should Be Visible  ${element}
    Wait Until Element is Visible  ${element}
    Element Should Be Enabled  ${element}
