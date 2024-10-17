*** Settings ***
Resource    ../Tests/Resource/Table view without restrictions.robot
Test Tags    Table
Suite Setup    Table view without restrictions.System Logon
Suite Teardown    Table view without restrictions.System Logout

*** Test Cases ***
Table view without restrictions
    Table view without restrictions  
Generate report
    Generate report




    

   

    

