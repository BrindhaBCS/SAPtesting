*** Settings ***
Resource    ../Tests/Resource/Delete audit audit files.robot
Suite Setup    Delete audit audit files.System Logon
Suite Teardown    Delete audit audit files.System Logout
Test Tags    Delete_audit_files

*** Test Cases ***
Delete audit files
    Delete audit files
Generate report
    Generate report