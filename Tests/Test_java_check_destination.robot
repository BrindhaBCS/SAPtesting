*** Settings ***
Resource    ../Tests/Resource/java_check_destination.robot
Test Tags    java_version_check_destination
Suite Setup    java_check_destination.Opening Browser
Suite Teardown    java_check_destination.close_browser


*** Test Cases ***
check_destinations
    check_destinations