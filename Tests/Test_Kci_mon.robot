*** Settings ***
Resource    ../Tests/Resource/Kci_mon.robot
Test Tags    Mon_kci

*** Test Cases ***
check_Login_page
    response_page