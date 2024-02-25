
*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
# Library    PDF.py

*** Keywords ***


Transaction SMQR
    Run Transaction     /nsmqr
    Send Vkey    0
    Take Screenshot    024_smqr.jpg
    Sleep    1