*** Settings ***
Library    Process
Library     String
Library    OperatingSystem

*** Variables ***
${textfile_path}    ${CURDIR}\\Read_text.txt
${writefile_path}    ${CURDIR}\\write_text.txt
@{list}     text1   text2   text3

*** Keywords ***

Read Text File
    File Should Exist    ${textfile_path}
    ${file_content}=    Get File    ${textfile_path}
    ${lines}=    Split String    ${file_content}    \n
    ${number_of_values}=    Get Length    ${lines}
    ${row}=     Evaluate    ${number_of_values} + 1
    # Log To Console      ${number_of_values}
    # Log To Console      ${row}
    # FOR     ${line}    IN      @{lines}
    #     Log      ${line}
    # END
    

Write to Notepad File
    FOR    ${item}    IN    @{list}
        Append To File    ${writefile_path}    ${\n}${item}
    END


