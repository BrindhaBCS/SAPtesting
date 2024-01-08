Project: <ProjectName> Robot Framework Version: <Version_Number>
==========================================================================================

#  How to execute testcases in Saucelab:

Refer below-mentioned support file web application testing on desktop browser on Saucelab platform 
   1. https://sourcecode.jnj.com/projects/ASX-NCOH/repos/robot_framework/browse/tests/Web/Tests/SupportSteps/Support_Saucelab_Desktop_ChromeBrowser.robot
   2. https://sourcecode.jnj.com/projects/ASX-NCOH/repos/robot_framework/browse/tests/Web/Tests/SupportSteps/Support_Saucelab_Desktop_SafariBrowser.robot

Refer below-mentioned support file for web testing on mobile browser (Android real device)
   https://sourcecode.jnj.com/projects/ASX-NCOH/repos/robot_framework/browse/tests/Mobile/Tests/Mobile/Android/Support_AGKL-259.robot  

Refer below-mentioned support file for Android app testing on sauce lab (Android real device)
    https://sourcecode.jnj.com/projects/ASX-NCOH/repos/robot_framework/browse/tests/Mobile/Tests/Mobile/Android/Support_AGKL-263.robot

Refer below-mentioned support file for ios app testing on sauce lab (iOS real device)
    https://sourcecode.jnj.com/projects/ASX-NCOH/repos/robot_framework/browse/tests/Mobile/Tests/Mobile/Ios/Support_AGKL-257.robot

Refer below-mentioned support file for web testing on mobile browser (iOS)   
    https://sourcecode.jnj.com/projects/ASX-NCOH/repos/robot_framework/browse/tests/Mobile/Tests/Mobile/Ios/Support_AGKL-261.robot

Add Below details in support file (above mentioned )
    ${saucelabs_id}         <your saucelab id>
    ${saucelabs_key}         <your saucelab key>
    ${saucelabs_auth}        <your saucelab authorization>


For Saucelabs mobile scripts add dependencies
    tests\Mobile\dependencies\requirements.txt


##  Steps to connect to saucelab Mobile Real device to test an android/iOS app (Manual Process)
    Open url https://accounts.saucelabs.com/am/XUI/?region=us-west-1&next=/live/web-testing/desktop#login/.
    Login with the valid Saucelabs login credentials (User id and access key).
    CLick on App Management -> Serach for an App -> Select App -> Click on Start test (Arrow sign at right)
    Select a avaialble mobile device from list  
    Click on Start Test to Start Testing with selected mobile real device
    Click on Live->Test Results option and the select Real Device from environment dropdown to watch out the execution of the testcase.


##  Steps to connect to saucelab Mobile Real device to test website on Mobile browser (Manual Process)
    Open url https://accounts.saucelabs.com/am/XUI/?region=us-west-1&next=/live/web-testing/desktop#login/.
    Login with the valid Saucelabs login credentials (User id and access key).
    Click on Live-> Cross Browser
    Select "Mobile Real" Tab 
    Enter Website link in URL Box 
    Select a avaialble mobile Browser and browser version from list  
    Select Avaialble Resolution from RESOLUTION list
    Select OS version from dropdown
    Click on Start Test to Start Testing with selected mobile real device
    Click on Live->Test Results option 
    Select Real DeVice from environment dropdown and My test from Owner dropdown to watch out the execution of the testcase.

## Steps to connect to saucelab Desktop (Manual Process)
    Open url https://accounts.saucelabs.com/am/XUI/?region=us-west-1&next=/live/web-testing/desktop#login/.
    Login with the valid Saucelabs login credentials (User id and access key).
    Click on Live-> Cross Browser
    Select Desktop Tab 
    Enter Website link in URL Box 
    Select a avaialble mobile Browser and browser version from list  
    Select Avaialble Resolution from RESOLUTION list
    Select OS version from dropdown
    Click on Start Test to Start Testing on desktop broswer
    Click on Live->Test Results option 
    Select Real DeVice from environment dropdown and My test from Owner dropdown to watch out the execution of the testcase.
