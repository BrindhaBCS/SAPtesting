*** Settings ***
Resource    ../Tests/Resource/Fiori_Step1.robot
Suite Setup    Fiori_Step1.System Logon
Suite Teardown    Fiori_Step1.System Logout 
Test Tags    Fiori_Create_date

*** Test Cases ***
Fiori_Create_date
    Fiori_Create_date
    # Deletefile
