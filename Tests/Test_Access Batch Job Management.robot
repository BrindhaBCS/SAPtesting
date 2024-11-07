*** Settings ***
Resource    ../Tests/Resource/Access Batch Job Management.robot
Test Tags    Access
Suite Setup    Access Batch Job Management.System Logon
Suite Teardown    Access Batch Job Management.System Logout

*** Test Cases ***
Access Batch Job Management
    Access Batch Job Management  
    Generate report




    

   

    

