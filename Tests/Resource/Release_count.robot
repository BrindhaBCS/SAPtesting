*** Settings ***
Library    Process
Library    OperatingSystem
Library    String
Library    SAP_Tcode_Library.py
Library     DateTime
Library    ExcelLibrary

*** Variables ***
${target_file_name}    C:\\Output\\Rental_Invoice.xlsx
${target_sheet_name}    Sheet1
${SUCCESS}    0
${FAILURE}    0

*** Keywords *** 

Rental Release Count
    ${row_count}    Count Excel Rows    ${target_file_name}    ${target_sheet_name}
    ${contracts}    Evaluate    ${row_count} - 1
    ${excel_rows}    Evaluate    ${row_count} + 1
    FOR  ${j}  IN RANGE  2    ${excel_rows}
        ${status}    Read Excel Cell Value    ${target_file_name}    ${target_sheet_name}    ${j}    9  
        Run Keyword If    '${status}' == 'Passed'    Increment Success Variable
        Run Keyword If    '${status}' == 'Failed'    Store Failure Value
    END
    
Increment Success Variable
    ${SUCCESS}=    Set Variable    ${SUCCESS}+1
    Log To Console    **gbStart**count_status**splitKeyValue**Out of ${contracts} documents ${SUCCESS} documents block has been released**gbEnd**

Store Failure Value
    ${FAILURE}=    Set Variable    ${FAILURE}+1

