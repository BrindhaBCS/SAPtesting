*** Settings ***
Resource    ../Tests/Resource/Kci_mon_one.robot
Test Tags    Mon_kci_one

*** Test Cases ***
check_Login_page
    response_page