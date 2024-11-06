*** Settings ***
Library    SAP_Tcode_Library.py
Library    OperatingSystem

*** Variables ***
${MINUTES_IN_DAY}   1440
${DAYS_TO_RUN}      365
${url}    ${symvar('URL')}
${user}    ${symvar('User_Name')}
${pass}    ${symvar('Passcode')}
*** Keywords ***
response_page
    ${File}    Create File    ${symvar('File_Path')}${symvar('File_Name')}.csv     content=${EMPTY}
    Convert Csv To Xlsx    xls_file=${symvar('File_Path')}${symvar('File_Name')}.csv    xlsx_file=${symvar('File_Path')}${symvar('File_Name')}.xlsx
    Delete Specific File    file_path=${symvar('File_Path')}${symvar('File_Name')}.csv
    ${row}    Set Variable    1
    FOR    ${day}    IN RANGE    ${DAYS_TO_RUN}
        Log To Console    Day ${day + 1} started.
        FOR    ${minute}    IN RANGE    ${MINUTES_IN_DAY}
            ${time}    Response Time    url=${url}    user=${user}    passcode=${pass}
            IF    '${time}' >= '1.0000'
                Send Mail    from_email=${symvar('From_email')}   password=${symvar('From_user_passcode')}    to_mail=${symvar('To_email')}    subject=${symvar('Subject')}     content=Hi Team,\n\nThe response time exceeds 5 Seconds. Please take a look on it :\n\n URL: https://direct.kloecknermetals.com/v2/login\n\n                                                                                                                                                                                                                                 
            END
            ${response}    Response Check    url=${url}    user=${user}    passcode=${pass}
            ${res}    Set Variable   Response Time: ${time} : ${response}
            Sleep    30 seconds
            Write Value To Excel    file_path=${symvar('File_Path')}${symvar('File_Name')}.xlsx    sheet_name=Kci_Monitoring    cell=A${row}    value=${res}
            ${row}    Evaluate    ${row} + 1
            Log To Console    Day ${day + 1} completed.
        END
    END