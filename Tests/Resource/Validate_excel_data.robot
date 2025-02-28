*** Settings ***
Library    SAP_Tcode_Library.py
Force Tags      validate

*** Variable ***
${RE_File}      C:\\Test_Project\\RE_1.xlsx
${WE_File}      C:\\Test_Project\\WE_1.xlsx
${target_file}      C:\\Test_Project\\WE.xlsx


*** Keywords ***
Read and write excel datas
    ${column_data}      Read Column From Excel      ${RE_File}      Sheet1      3
    Write Column To Excel       ${target_file}      Sheet1      1   ${column_data}



*** Test Case ***
Read and write excel datas
    Read and write excel datas
