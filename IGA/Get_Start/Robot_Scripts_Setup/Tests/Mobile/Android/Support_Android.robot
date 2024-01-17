*** Settings ***
Documentation     Executes Android test support.

*** Keywords ***
Install Android Application
    [Documentation]    Installs android application. Some of the variable values are
    ...    androidPlatformName=Android
    ...    androidWaitActivity = "*.MainActivity,*.WelcomeActivity,
    ...    *.RegisterUserActivity,*.QuitAssessmentActivity"
    ...    appiumFullReset = False
    ...    appiumNoReset = True
    Set global variable    ${platform}    Android
    Set global variable    ${deviceDetails}    Device : ${deviceName}, Platform Version: ${platform_version}, Application: ${app}
    Log to console    Execution will be performed on '${execute_location}' using app '${app}'
    Log to console    Using the following Desired Capabilities
    Log to console    ...platformName=${mvar('androidPlatformName')}
    Log to console    ...platformVersion=${platform_version}
    Log to console    ...appWaitActivity=${mvar('androidWaitActivity')}
    Log to console    ...fullReset=${mvar('appiumFullReset')}
    Log to console    ...noReset=${mvar('appiumNoReset')}
    Log to Console    ...Screenshots are Off ? ${noScreenshots}
    Run Keyword if    "${execute_location}"=="SauceLabs"    Install Android App on Sauce Labs
    ...    ELSE IF    "${execute_location}"=="Sim"    Install Android App on local simulator
    ...    ELSE IF    "${execute_location}"=="Physical"    Install Android App physical device
    Set Global Variable    ${current_stage}    INSTALLED
    Set global variable    ${is_launched}    ${TRUE}
    Sleep    ${mvar('launchWait')}

Install Android App on Sauce Labs
    [Timeout]    6 minute
    ${sauceLabsServer}=    Set Variable    https://${saucelabs_id}:${saucelabs_key}${mvar('appiumServerSauceLabs')}
    Log to console  ...Server=${sauceLabsServer}
    Log to console  ...name=${execution_name}
    Log to console  ...deviceName=${deviceName}
    Log to console  ...app=${app}

    Open Application  ${sauceLabsServer}
    ...  platformName=${mvar('androidPlatformName')}
    ...  platformVersion=${platform_version}
    ...  deviceName=${deviceName}
    ...  app=${app}
    ...  name=${execution_name}
    ...  appWaitActivity=${mvar('androidWaitActivity')}
    ...  launchTimeout=${mvar('androidLaunchTimeout')}
    ...  newCommandTimeout=${mvar('androidNewCommandTimeout')}
    ...  fullReset=${mvar('appiumFullReset')}
    ...  noReset=${mvar('appiumNoReset')}

Install Android App physical device
    [Documentation]    Installs app on physical device. The local server value can be:
    ...    appiumServerLocal = "http://localhost:4723/wd/hub"
    [Timeout]    3 minute
    Open Application  ${mvar('appiumServerLocal')}
    ...  platformName=${mvar('androidPlatformName')}
    ...  platformVersion=${platform_version}
    ...  deviceName=LocalAndroidDevice
    ...  app=${app}
    ...  appWaitActivity=${mvar('androidWaitActivity')}
    ...  fullReset=${mvar('appiumFullReset')}
    ...  noReset=${mvar('appiumNoReset')}

Install Android App on local simulator
    [Timeout]    2 minute
    Log to console    ...Server : ${mvar('appiumServerLocal')}
    Log to console    ...deviceName=${deviceName}
    Open Application    ${mvar('appiumServerLocal')}
    ...    platformName=${mvar('androidPlatformName')}
    ...    platformVersion=${platform_version}
    ...    deviceName=${deviceName}
    ...    app=${app}
    ...    fullReset=${mvar('appiumFullReset')}
    ...    noReset=${mvar('appiumNoReset')}
    ...    avd=${deviceName}
    ...    appWaitActivity=${mvar('androidWaitActivity')}
    ...    nativeWebScreenshot=${True}
    ...    avdArgs=-no-boot-anim

Connect to Sauce Labs Android Real Device Browser
    [Timeout]    6 minute
    ${sauceLabsServer}=    Set Variable    https://${saucelabs_id}:${saucelabs_key}${mvar('appiumServerSauceLabs')}
    Log to console  ...Server=${sauceLabsServer}
    Log to console  ...deviceName=${deviceName}
    Log to console  ...name=${execution_name}
    Log to console  ...browserName=${mvar('androidBrowser')}

    Open Application  ${sauceLabsServer}
    ...  platformName=${mvar('androidPlatformName')}
    ...  platformVersion=${platform_version}
    ...  deviceName=${deviceName}
    ...  browserName=${mvar('androidBrowser')}
    ...  name=${execution_name}
    ...  newCommandTimeout=${mvar('androidNewCommandTimeout')}
    ...  fullReset=${mvar('appiumFullReset')}
    ...  noReset=${mvar('appiumNoReset')}

Web page is accessed via Chrome App on physical device
    [Arguments]    ${web_page}
    Open Chrome app on device
    Go to url    ${web_page}

Open Chrome app on device
    Open application    ${mvar('appiumServerLocal')}
    ...    platformName=${mvar('androidPlatformName')}
    ...    platformVersion=${platform_version}
    ...    deviceName=LocalAndroidDevice
    ...    browserName=chrome

Close Application
    Quit Application