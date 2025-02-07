*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py


*** Keywords *** 
System Logout
    Start Process    ${symvar('SAP_SERVER')}
    Connect To Session
    Sleep    2
    Run Transaction   /nex