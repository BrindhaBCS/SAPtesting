*** Settings ***
Resource    ../Tests/Resource/FB60.robot
Force Tags   FB60
Suite Setup    FB60.SAP logon
Suite Teardown    FB60.SAP Logout
 
*** Test Cases ***
Interlinked transactions for Vendor Invoice
    FB60 Invoice entry