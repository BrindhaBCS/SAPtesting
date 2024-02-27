*** Settings ***
Resource    Resource/SPAD.robot
Force Tags    SPAD
Suite Setup    SPAD.System Logon
Suite Teardown    SPAD.System Logout
  
*** Test Cases ***

Executing SPAD  
    Transaction SPAD
    ARCH Screenshot    
    LOCL Screenshot    
    LP01 Screenshot   
    ZPDF Screenshot
