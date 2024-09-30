*** Settings ***
Resource    ../Tests/Resource/VL01N.robot
Suite Setup    VL01N.System Logon
Suite Teardown    VL01N.System Logout
Test Tags    salesorder2


*** Test Cases ***
VL01N
    VL01N
   