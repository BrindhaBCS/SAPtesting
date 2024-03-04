*** Settings ***
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    Resource/ST06.robot
Force Tags    ST06
Suite Setup    ST06.System Logon
Suite Teardown    ST06.System Logout


*** Test Cases ***
Executing ST06
    Transaction ST06