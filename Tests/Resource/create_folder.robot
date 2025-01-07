*** Settings ***
# Library    OperatingSystem
Library     DateTime
Library     SAP_Tcode_Library.py
Library     JSONLibrary
Force Tags   folder

*** Variables ***
# ${FOLDER_PATH}    C:\\EID_Parry\\2024\\Jan

*** Test Cases ***
# Check And Create Folder
#     # Check if the folder exists
#     ${EXISTS}   Run Keyword And Return Status   Directory Should Exist    ${FOLDER_PATH}
#     IF  '${EXISTS}' == "False"
#         Create Directory    ${FOLDER_PATH}
#         Log To Console    Folder created at ${FOLDER_PATH}
#     END

# # Create Folder
# #     # [Arguments]    ${path}
# #     Create Directory    ${FOLDER_PATH}
# #     Log    Folder created at ${FOLDER_PATH}

# # Month
# #     ${month}    Get Current Date    result_format=%B
# #     Log To Console  ${month}
# Compare Dates
    # ${date1}=    Get Current Date    result_format=%d.%m.%Y
    # ${date1}=    Set Variable    31.01.2025
    # ${date2}=    Set Variable    31.12.2024
    # ${date1}=    Set Variable    2025.02.29
    # ${date2}=    Set Variable    2024.12.31
    # ${date3}=   Convert Date    31.12.2024  result_format=%Y.%m.%d
    # Log To Console      Converted date format is: ${date3}
    # # ${result}=    DateTime.Is Before    ${date1}    ${date2}
    # # Should Be True    ${result}
    # IF  '${date1}' <= '${date2}'
    #     Log To Console      The given date is valid
    # ELSE
    #     Log To Console      The given date is not valid
    # END

Read Json Variable
    # @{values}   Evaluate    json.loads('${json}')
    # FOR     ${value}    IN      @{values}
    #     # ${folder_value}     Get From List   ${value}    0
    #     # Log To Console      folder value is: ${folder_value}
    #     # ${file_value}     Get From List   ${value}    1
    #     # Log To Console      file value is: ${file_value}
    #     Log To Console      folder value is: ${value}
    @{values}   Convert Json Format     ${json}
    Log To Console      converted value is: @{values}
    # FOR     ${value}    IN      @{values}
    #     Log To Console      folder value is: ${value}
    # END

