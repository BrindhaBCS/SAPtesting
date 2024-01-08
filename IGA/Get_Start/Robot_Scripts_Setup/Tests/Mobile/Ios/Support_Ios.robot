*** Settings ***
Documentation     Executes IOS test support.

*** Keywords ***
Install iOS Application
    [Documentation]    An example of installing application. Please specify the required params.
    Log to console    ${\n}
    Create New Email    ${mvar('validEmail')}    ${mvar('emailDomain')}
    Set global variable    ${platform}    iOS
    Set Global Variable    ${location}    ${execute_location}
    Set global variable    ${deviceDetails}    Device : ${deviceName}, Platform Version: ${platform_version}, Application: ${app}
    Log to console    Execution will be performed on '${execute_location}' using app '${app}'
    Log to console    Using the following Desired Capabilities
    Log to console    ...platformName=${mvar('iosPlatformName')}
    Log to console    ...platformVersion=${platform_version}
    Log to console    ...deviceName=${deviceName}
    Log to console    ...fullReset=${mvar('appiumFullReset')}
    Log to console    ...noReset=${mvar('appiumNoReset')}
    Log to console    ...launchTimeout=${mvar('iosLaunchTimeout')}
    Log to console    ...wdaLaunchTimeout=${mvar('mobWdaConnectionTimeout')}
    Log to console    ...waitForAppScript=${mvar('iosWaitScript')}
    Log to console    ...waitForQuiescence=${mvar('iosWaitForQuiescence')}
    Run Keyword if    "${execute_location}"=="SauceLabs"    Install iOS App on Sauce Labs
    ...    ELSE IF    "${execute_location}"=="Sim"    Install iOS App on local simulator
    ...    ELSE IF    "${execute_location}"=="Physical"    Install iOS App physical device
    Set Global Variable    ${current_stage}    INSTALLED
    Set Global variable    ${is_launched}    ${TRUE}
    Sleep    ${mvar('launchWait')}
    Run Keyword if    "${execute_location}"=="Physical"    Store UI Size
    Log to console    ${\n}

Create New Email
    [Arguments]    ${baseEmail}    ${domain}
    Increment email count
    ${currentValidEmail}=    Catenate    SEPARATOR=    ${baseEmail}    ${emailCount}    ${domain}
    Set global variable    ${currentValidEmail}

Store UI Size
    ${uiSize}=    Get Element Size    ${mvar('appLocator')}
    Set Global variable    ${uiSize}

Install iOS App on Sauce Labs
    [Timeout]    10 minute
    ${sauceLabsServer}=    Set Variable    https://${saucelabs_id}:${saucelabs_key}${mvar('appiumServerSauceLabs')}
    Log to console  ...Server=${sauceLabsServer}
    Log to console  ...name=${execution_name}
    Log to console  ...deviceName=${deviceName}
    Log to console  ...platformName=${mvar('iosPlatformName')}
    Log to console  ...platformVersion=${platform_version}
    Log to console  ...app=${app}

    Open Application    ${sauceLabsServer}
    ...     platformName=${mvar('iosPlatformName')}
    ...     platformVersion=${platform_version}
    ...     deviceName=${deviceName}
    ...     app=${app}
    ...     name=${execution_name}
    ...     launchTimeout=${mvar('iosLaunchTimeout')}
    ...     newCommandTimeout=${mvar('iosNewCommandTimeout')}
    ...     waitForAppScript=${mvar('iosWaitScript')}
    ...     idleTimeout=300
    ...     fullReset=${mvar('appiumFullReset')}
    ...     noReset=${mvar('appiumNoReset')}
    ...     useJSONSource=True


## install salesforce APP on iOS physical device
Install iOS App physical device
    [Arguments]    ${bundleId}    ${app}
    [Timeout]    2 minute
    Log to console    Server : ${mvar('appiumServerLocal')}
    Log to console    DeviceName : ${deviceName}
    Log to console    Platform Version=${platform_version}
    Log to console    appName : ${app}
    Log to console    bundleId : ${bundleId}

    Open Application    ${mvar('appiumServerLocal')}
    ...     automationName=${mvar('iosAutomationName')}
    ...     useNewWDA=${mvar('iosUseNewWDA')}
    ...     bundleId=${bundleId}
    ...     appName=${app}
    ...     platformName=${mvar('iosPlatformName')}
    ...     platformVersion=${platform_version}
    ...     deviceName=${deviceName}
    ...     udid=${udid}


Install iOS App on local simulator
    [Timeout]    2 minute
    Log to console    Server : ${mvar('appiumServerLocal')}
    Log to console    language : ${mvar('language')}
    Log to console    locale : ${mvar('locale')}

    Open Application    ${mvar('appiumServerLocal')}
    ...     platformName=${mvar('iosPlatformName')}
    ...     platformVersion=${platform_version}
    ...     deviceName=${deviceName}
    ...     app=${app}
    ...     fullReset=${mvar('appiumFullReset')}
    ...     noReset=${mvar('appiumNoReset')}
    ...     waitForAppScript=${mvar('iosWaitScript')}
    ...     waitForQuiescence=${mvar('iosWaitForQuiescence')}
    ...     useJSONSource=${TRUE}

Connect to SauceLab iOS Real Device Browser
    [Arguments]    ${test_browser}
    [Timeout]    6 minute
    ${sauceLabsServer}=    Set Variable    https://${saucelabs_id}:${saucelabs_key}${mvar('appiumServerSauceLabs')}
    Log to console  ...Server=${sauceLabsServer}
    Log to console  ...deviceName=${deviceName}
    Log to console  ...name=${execution_name}
    Log to console  ...browserName=${test_browser}

    Open Application  ${sauceLabsServer}
    ...     platformName=${mvar('iosPlatformName')}
    ...     platformVersion=${platform_version}
    ...     deviceName=${deviceName}
    ...     browserName=${test_browser}
    ...     name=${execution_name}
    ...     newCommandTimeout=${mvar('iosNewCommandTimeout')}
    ...     fullReset=${mvar('appiumFullReset')}
    ...     noReset=${mvar('appiumNoReset')}

Open Browser app on iOS physical device
    [Arguments]    ${test_browser}
    Open application    ${mvar('appiumServerLocal')}
    ...    platformName=${mvar('iosPlatformName')}
    ...    platformVersion=${platform_version}
    ...    deviceName=${deviceName}
    ...    browserName=${test_browser}
    ...    udid=${udid}
    ...    fullReset=${mvar('appiumFullReset')}
    ...    noReset=${mvar('appiumNoReset')}
    ...    nativeWebTap=${mvar('nativeWebTap')}

Enter Pairing Code on iOS
    [Arguments]    ${code}
    @{numbers} =    Split String To Characters    ${code}
    FOR    ${num}    IN    @{numbers}
        Click Element    ${num}
    END

Launch iOS Quick Menu
    ${width}=    Get From Dictionary    ${uiSize}    width
    ${height}=    Get From Dictionary    ${uiSize}    height
    ${halfHeight}=    Evaluate    ${height}/2
    ${halfWidth}=    Evaluate    ${width}/2
    # Swipe Up from Bottom of screen to half way to bring up OS menu
    Swipe    ${halfWidth}    ${height}    ${halfHeight}    ${halfWidth}
    Sleep    2

Collapse iOS Quick Menu
    ${width}=    Get From Dictionary    ${uiSize}    width
    ${height}=    Get From Dictionary    ${uiSize}    height
    ${halfHeight}=    Evaluate    ${height}/2
    ${halfWidth}=    Evaluate    ${width}/2
    # Swipe Down from Top of screen to half way to bring down OS menu
    Swipe    ${halfWidth}    1    ${halfHeight}    ${halfWidth}
    Sleep    2

Disable Bluetooth on iOS
    Launch iOS Quick Menu
    ${label}=    Get Element Attribute    bluetooth-button    label
    Run Keyword If    '${label}'=='Bluetooth'    Click Element    bluetooth-button
    Collapse iOS Quick Menu

Enable Bluetooth on iOS
    Launch iOS Quick Menu
    ${label}=    Get Element Attribute    bluetooth-button    label
    Run Keyword If    '${label}'=='Bluetooth, Not Connected'    Click Element    bluetooth-button
    Collapse iOS Quick Menu

Pair with Device Using Correct Code
    Wait Until Page Contains Element    ${mvar('blePairBtn')}
    Enter Pairing Code on iOS    ${mvar('bleValidPairCode')}
    Click Element    ${mvar('blePairBtn')}

Pair with Device Using Incorrect Code
    Wait Until Page Contains Element    ${mvar('blePairBtn')}
    Enter Pairing Code on iOS    ${mvar('bleInvalidPairCode')}
    Click Element    ${mvar('blePairBtn')}
    # Keyboard support keywords

Enter ${string} on iOS Keyboard
    @{characters} =    Split String To Characters    ${string}
    FOR    ${char}    IN    @{characters}
        ${is_upper}=    Run Keyword And Return Status    Should Be Uppercase    ${char}
        Run Keyword if    ${is_upper}==${True}    Enter Uppercase Character    ${char}
        ...    ELSE    Click Element    ${char}
    END

Enter Uppercase Character
    [Arguments]    ${char}
    Click Element    shift
    Click Element    ${char}

Type ${number} random letters on iOS keyboard
    ${rand_string}=    Generate Random String    ${number}    [LETTERS]
    Enter ${rand_string} on iOS Keyboard
    [Return]    ${rand_string}

Numeric Keyboard is displayed - iOS
    Page Should Not Contain Element    space
    Page Should Not Contain Element    more
    Element Should Be Visible and Enabled    0
    Element Should Be Visible and Enabled    ${mvar('idNumberidDeleteButton')}

Done button on keyboard should be disabled
    Element Should Be Visible    ${mvar('idDoneButton')}
    Element Should Be Disabled    ${mvar('idDoneButton')}

Done button on keyboard should be enabled
    Element Should Be Visible    ${mvar('idDoneButton')}
    Element Should Be Enabled    ${mvar('idDoneButton')}

Click Done button on keyboard
    Run Keyword if    '${platform}'=='Android'    Press Keycode    66
    Run Keyword if    '${platform}'=='iOS'    Click element    ${mvar('idDoneButton')}

User Clicks Done button on keyboard - Android
    Press Keycode    66

Click Delete button on keyboard - Android
    Press Keycode    67

User deletes one character
    Run Keyword if    '${platform}'=='Android'    Click Delete button on keyboard - Android
    Run Keyword if    '${platform}'=='iOS'    Click Element    ${mvar('idDeleteButton')}

Keyboard is not displayed
    Page should not contain element    ${mvar('idDeleteButton')}
    Page should not contain element    ${mvar('idDoneButton')}

