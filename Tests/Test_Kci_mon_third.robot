*** Settings ***
Resource    ../Tests/Resource/Kci_mon_third.robot
Test Tags    Mon_kci_third

*** Test Cases ***
check_Login_page
    response_page