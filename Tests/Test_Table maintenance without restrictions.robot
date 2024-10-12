*** Settings ***
Resource    ../Tests/Resource/Table maintenance without restrictions.robot
Suite Setup    Table maintenance without restrictions.System Logon
Suite Teardown   Table maintenance without restrictions.System Logout
Test Tags    Table_maintenance_without_restrictions

*** Test Cases ***
Table maintenance without restrictions
    Table maintenance without restrictions