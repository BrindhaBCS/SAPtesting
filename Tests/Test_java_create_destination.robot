*** Settings ***
Resource    ../Tests/Resource/java_create_destination.robot
Test Tags    java_version_create_destination
Suite Setup    java_create_destination.Opening Browser
Suite Teardown    java_create_destination.close_browser


*** Test Cases ***
create_destinations
    create_destinations