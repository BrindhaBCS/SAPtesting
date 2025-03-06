*** Settings ***
Resource    ../Tests/Resource/ME2N.robot
Suite Setup    ME2N.System Logon
Suite Teardown    ME2N.System Logout
Test Tags    ME2N


*** Test Cases ***
Execution
    ME2N
    Delete extra Columns