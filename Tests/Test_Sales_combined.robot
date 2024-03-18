
*** Settings ***

Resource    ../Tests/Resource/Sales_combined.robot
Force Tags    Sales1
Suite Setup    Sales_combined.System Logon
# Suite Teardown    Sales_combined.System Logout
  
*** Test Cases ***
Executing VA01
    # Generate and Use Random Number
    # Transaction VA01
    # Selecting multiple materials
    Verify idoc
    # Launch Sales Force
    # Close Sales Force
    