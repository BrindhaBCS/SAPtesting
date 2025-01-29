*** Settings ***
Resource    ../Tests/Resource/java_viewing_and_filtering.robot
Test Tags    java_version_viewing
Suite Setup    java_viewing_and_filtering.Opening Browser
Suite Teardown    java_viewing_and_filtering.close_browser


*** Test Cases ***
viewing and filtering
    viewing and filtering
    