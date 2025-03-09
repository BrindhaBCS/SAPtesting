*** Settings ***
Resource    ../Tests/Resource/Rpa_IBD_Makeittoday.robot
Suite Setup    Rpa_IBD_Makeittoday.System Logon
Suite Teardown    Rpa_IBD_Makeittoday.System Logout
Test Tags    Rpa_IBD_Makeittoday_sym

*** Test Cases ***
Reschedule_date_sym
    Reschedule_date