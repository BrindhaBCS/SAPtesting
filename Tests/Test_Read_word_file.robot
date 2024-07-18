*** Settings ***
Resource    ../Tests/Resource/Read_word_file.robot
Test Tags   wordfile
 
*** Test Cases ***
Read and Write Word File
    ${content}    Read Word File From Library    ${INPUT_FILE}
    Log To Console    ${content}
    Write Word File To Library    ${OUTPUT_FILE}    ${TEXT}