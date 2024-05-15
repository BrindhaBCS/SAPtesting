*** Settings ***
# Resource    Resource/Common_SAP_Tcodefn.robot
Resource    ../Tests/Resource/Monthly_Compliance_Report_SAP_V7.robot
#Resource    ../Tests/Resource/Report_Word.py
Test Tags    compliance_report
#Suite Setup    Common_SAP_Tcodefn.System Logon
#Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***
#Monthly Compliance Reports
System Logon
    System Logon
#
Executing Monthly compliance report
   Executing Monthly compliance report

Report
    Report
#Reports creation
    #Create Reports
#Executing Req5
 #   Executing Req5

#Executing Req6
 #   Executing Req6

#Executing Req7
  #  Executing Req7

#Executing Req10
 #   Executing Req10

#Executing Req8
 #   Executing Req8

System Logout
    System Logout    




    

   

    

