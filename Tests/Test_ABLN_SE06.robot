*** Settings ***
Resource    ../Tests/Resource/ABLN_SE06.robot
Test Tags    ABB_SE06
Suite Setup    ABLN_SE06.System Logon
Suite Teardown   ABLN_SE06.System Logout

*** Test Cases ***
ABB_SE06
    ABB_SE06
    Non_Modifiable
