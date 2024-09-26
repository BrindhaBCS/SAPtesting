*** Settings ***
Resource    ../Tests/Resource/MRBR_Excel_Export.robot 
Suite Setup    MRBR_Excel_Export.System Logon
Suite Teardown    MRBR_Excel_Export.System Logout
Test Tags    MRBR_Excel_Export
 
*** Test Cases ***
MRBR_Excel_Export
    MRBR_Excel_Export