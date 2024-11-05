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
    ${File}    Create File    ${symvar('Text_File_Name')}     content=${EMPTY}
    FOR    ${day}    IN RANGE    ${DAYS_TO_RUN}
        Log To Console    Day ${day + 1} started.
        FOR    ${minute}    IN RANGE    ${MINUTES_IN_DAY}
            ${time}    Response Time    url=${url}    user=${user}    passcode=${pass}
            IF    '${time}' >= '5.0000'
                Send Mail    from_email=${symvar('From_email')}   password=${symvar('From_user_passcode')}    to_mail=${symvar('To_email')}    subject=${symvar('Subject')}     content=Hi Team,\n\nThe response time exceeds 5 Seconds. Please take a look on it :\n\n URL: https://direct.kloecknermetals.com/v2/login\n\n                                                                                                                                                                                                                                 
            END
            ${response}    Response Check    url=${url}    user=${user}    passcode=${pass}
            ${res}    Set Variable   Response Time: ${time} : ${response}
            Sleep    30 seconds
            Append To File    ${symvar('Text_File_Name')}        ${res}\n
            Log To Console    Day ${day + 1} completed.
        END
    END