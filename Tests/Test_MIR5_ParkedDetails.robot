*** Settings ***
Resource    ../Tests/Resource/MIR5_ParkedDetails.robot
Suite Setup    MIR5_ParkedDetails.System Logon
Suite Teardown    MIR5_ParkedDetails.System Logout
Task Tags    MIR5_ParkedDetails
 
 
*** Test Cases ***
MIR5 Parked details
    MIR5 Parked details