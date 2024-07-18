*** Settings ***
Library    Collections
Library    OperatingSystem
Library    PandasLibrary.py

*** Variables ***
${INPUT_FILE}    ${CURDIR}\\input.csv
${OUTPUT_FILE}    ${CURDIR}\\output.csv

*** Keywords ***
Read CSV File
    [Documentation]    Read the content from the CSV file using Pandas.
    ${dataframe}    Read CSV File To DataFrame    ${INPUT_FILE}
    Log DataFrame Info    ${dataframe}
    ${data}    DataFrame To List    ${dataframe}
    Log    ${data}

Write CSV File
    [Documentation]    Write content to a new CSV file using Pandas.
    ${dataframe}    Read CSV File To DataFrame    ${INPUT_FILE}
    ${dataframe}    Add Column To DataFrame    ${dataframe}    Salary    50000
    Write DataFrame To CSV    ${dataframe}    ${OUTPUT_FILE}
