*** Settings ***
Library    SeleniumLibrary
Library    FileOperations.py

*** Variables ***
${file_path}    ${symvar('filepath')}\\${symvar('filename')}

*** Keywords ***
Delete Files In Directory
    Delete File    ${FILE_PATH} 

