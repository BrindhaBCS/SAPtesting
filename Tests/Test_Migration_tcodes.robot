*** Settings ***
Resource    Resource/Common_SAP_Tcodefn.robot
Resource    ../Tests/Resource/Migration_tcodes.robot
Force Tags    migration
Suite Setup    Common_SAP_Tcodefn.System Logon
Suite Teardown    Common_SAP_Tcodefn.System Logout
  
*** Test Cases ***
Executing SM69
    Transaction SM69
    External Operating System Commands 
    SM69 Scroll 
    
# Executing SMQS
#     Transaction SMQS
#     QRFC Administration     
#     QRFC Administration INBOUND
#     QRFC Administration OUTBOUND
#     QRFC Administration OUTBOUND SCHEDULER
#     QRFC Administration INBOUND SCHEDULER
#     Display Possible Resources
    
# Executing SCOT    
#     Transaction SCOT
#     SMTP Nodes    
#     Settings Nodes
   
# Executing SMQR
#     Transaction SMQR

# Executing AL11
#     Transaction AL11

# Executing SHMM
#     Transaction SHMM
    
# Executing STRUST
#     Transaction STRUST
#     SSL server standard        
#     SSL client SSL Client (Anonymous)
#     SSL client SSL Client (Standard)  
#     WS Security Other System Encryption   
#     SSF Logon Ticket

# Executing SMLG
#     Transaction SMLG
#     SMLG Attributes
#     SMLG Load Distributions
    
# Executing Uconcockpit
#     Transaction Uconcockpit
#     RFC Basic Scenario
#     Role Building Scenario

# Executing OACO    
#     Transaction OACO
    
# Executing SPAD  
#     Transaction SPAD
#     ARCH Screenshot    
#     LOCL Screenshot    
#     LP01 Screenshot   
#     ZPDF Screenshot

# Executing SLDAPICUST
#     Transaction SLDAPICUST
#     Sldapicust display  

     
# Executing STMS
#     Transaction STMS   
#     Import Overview    
#     Transport Routes     
#     Transport Layers

# Executing WE20
#     Transaction WE20
#     Partner type LS
#     Partner type LI

# Executing WE21    
#     Transaction WE21
#     Transactional RFC
#     File Port
#     ABAP-PI
#     XML File
#     XML HTTP



    

   

    

