*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py


*** Keywords *** 
System Logout
    Connect To Session
    Connect To Existing Connection    ${symvar('Rental_Connection')}
    Run Transaction   /nex