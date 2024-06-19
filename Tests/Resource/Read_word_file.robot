*** Settings ***
Library    wordlibrary.py

*** Variables ***
${INPUT_FILE}    ${CURDIR}\\input.docx
${OUTPUT_FILE}   ${CURDIR}\\output.docx
${TEXT}       This is the content to be written to the Word file.

*** Keywords ***
Read Word File From Library
    [Arguments]    ${file_path}
    ${content}    Read Word File    ${file_path}
    [Return]    ${content}

Write Word File To Library
    [Arguments]    ${file_path}    ${content}
    Write Word File    ${file_path}    ${content}
