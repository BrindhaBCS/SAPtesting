*** Settings ***
Resource    ../Tests/Resource/Read_text_file.robot
Test Tags   Textfile
 
*** Test Cases ***
Read and write a text file
    Read Text File
    Write to Notepad File
