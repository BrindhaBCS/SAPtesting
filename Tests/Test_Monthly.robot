*** Settings ***
Resource    ../Tests/Resource/Monthly.robot
Test Tags    Monthly_controls

*** Test Cases ***
System Logon
    System Logon
Autorisaties SAP Query
    Autorisaties SAP Query
Check to start Programs immediately
    Check to start Programs immediately
Authorization profiles maintenance
    Authorization profiles maintenance
Access to Maintained Workflow
    Access to Maintained Workflow
Access Password Manager
    Access Password Manager
Usercontrol gebruikers met User Maintenance
    Usercontrol gebruikers met User Maintenance
Control access to customizing
    Control access to customizing
# Control prohibited passwords-----need to work-------
#     Control prohibited passwords
Release Debug Privilege on Production
    Release Debug Privilege on Production
Control Booking Period 
    Control Booking Period 
Mandantonderhoud
    Mandantonderhoud
Control SAP standard users
    Control SAP standard users
Control table logging
    Control table logging
Control mandant changes
    Control mandant changes
Control blocking transactions
    Control blocking transactions
Audit log configuration
    Audit log configuration
Control RFC connections users
    Control RFC connections users
Delete audit audit files
    Delete audit audit files
Table maintenance without restrictions
    Table maintenance without restrictions
Emergency User Edition
    Emergency User Edition
USMM
    USMM
Generate report
    Generate report
System Logout
    System Logout