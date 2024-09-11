*** Settings ***
Resource    ../Tests/Resource/Read_CSV_file.robot
Test Tags   CSVfile
 
*** Test Cases ***
Read and Write CSV with Pandas
    Read CSV File
    Write CSV File
