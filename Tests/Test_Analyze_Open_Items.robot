*** Settings ***
Resource    ../Tests/Resource/Analyze_Open_Items.robot
Suite Setup    Analyze_Open_Items.System Logon
Suite Teardown    Analyze_Open_Items.System Logout
Task Tags    open_items
 
 
*** Test Cases ***
Analysis of customer open items
    Open items