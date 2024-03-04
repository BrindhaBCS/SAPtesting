*** Settings ***
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    Resource/ST02.robot
Force Tags    ST02
Suite Setup    ST02.System Logon
Suite Teardown    ST02.System Logout


*** Test Cases ***
Executing ST02
    Transaction ST02
    