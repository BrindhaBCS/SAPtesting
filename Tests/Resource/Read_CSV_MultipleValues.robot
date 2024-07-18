*** Settings ***
Library    PandasLibrary.py
Library    OperatingSystem

*** Variables ***
${INPUT_FILE}    ${CURDIR}/input.csv
${OUTPUT_FILE}    ${CURDIR}/output.csv

*** Test Cases ***
Read and Write CSV with Pandas
    ${dataframe}    Read CSV File To DataFrame    ${INPUT_FILE}
    Log DataFrame Info    ${dataframe}
    
    # Example: Adding a column with multiple values
    ${salaries}    Create List    50000    60000    55000    
    ${dataframe}    Add Column To DataFrame    ${dataframe}    Salary    ${salaries}
    
    # Example: Writing the updated DataFrame to a new CSV file
    Write DataFrame To CSV    ${dataframe}    ${OUTPUT_FILE}
    Log    "CSV file written to ${OUTPUT_FILE}"

*** Keywords ***
Log DataFrame Info
    [Arguments]    ${dataframe}
    Log    DataFrame Info:
    Log    ${dataframe}

