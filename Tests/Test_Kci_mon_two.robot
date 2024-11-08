*** Settings ***
Resource    ../Tests/Resource/Kci_mon_two.robot
Test Tags    Mon_kci_two

*** Test Cases ***
check_Login_page
    response_page