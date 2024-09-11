*** Settings ***
Resource    ../Tests/Resource/GRC_Roles_Export.robot
Force Tags   GRC_ROLE
Suite Setup    GRC_Roles_Export.System Logon
Suite Teardown    GRC_Roles_Export.System Logout

*** Test Cases ***
exporting roles from nSE16
    Display customaized roles