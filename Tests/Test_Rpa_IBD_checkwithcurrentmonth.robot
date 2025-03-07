*** Settings ***
Resource    ../Tests/Resource/Rpa_IBD_checkwithcurrentmonth.robot
Suite Setup    Rpa_IBD_checkwithcurrentmonth.System Logon
Suite Teardown    Rpa_IBD_checkwithcurrentmonth.System Logout
Test Tags    Rpa_IBD_checkwithcurrentmonth_sym

*** Test Cases ***
IBD_checkwithcurrentmonth_res
    IBD_checkwithcurrentmonth