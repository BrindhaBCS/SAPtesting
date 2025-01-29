*** Settings ***
Resource    ../Tests/Resource/java_Modifying_Configuration_Settings.robot
Test Tags    java_version_modifying
Suite Setup    java_Modifying_Configuration_Settings.Opening Browser
Suite Teardown    java_Modifying_Configuration_Settings.close_browser


*** Test Cases ***
Modifying_Configuration_Settings
    Modifying_Configuration_Settings