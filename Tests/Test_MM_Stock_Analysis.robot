*** Settings ***
#Resource    Resource/Common_SAP_Tcodefn.robot
Resource    ../Tests/Resource/Material_Availability_Plant.robot
Test Tags    stock_analysis
Suite Setup    Material_Availability_Plant.System Logon
Suite Teardown    Material_Availability_Plant.System Logout
  
*** Test Cases ***
#Monthly Compliance Reports
# System Logon
#     Material_Availability_Plant.System Logon
Executing Material Availability
    Executing Material Availability
Result
    Result
# System Logout
#     Material_Availability_Plant.System Logout    




    

   

    

