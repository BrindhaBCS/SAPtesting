*** Settings ***
#Resource    Resource/Common_SAP_Tcodefn.robot
Resource    ../Tests/Resource/P2P_Cycle.robot
Force Tags    p2p
#Suite Setup    Common_SAP_Tcodefn.System Logon
#Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***
#Monthly Compliance Reports
System Logon
    P2P_Cycle.System Logon
Executing P2P Cycle
    Executing P2P Cycle
System Logout
    P2P_Cycle.System Logout    




    

   

    

