*** Settings ***
Library    SeleniumLibrary
Library    FileOperations.py

*** Variables ***
${file_path}    ${CURDIR}\\${symvar('filename')}

*** Keywords ***
Delete Files In Directory
    Delete File    ${FILE_PATH} 
