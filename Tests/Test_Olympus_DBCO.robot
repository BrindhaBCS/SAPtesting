*** Settings ***
Resource  ../Tests/Resource/Olympus_DBCO.robot
Test Tags   DBCO

*** Test Cases ***
system_logon
  System Logon
  DBCO_Tcodes