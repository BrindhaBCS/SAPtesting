*** Settings ***
Library    SAP_Tcode_Library.py
Library    OperatingSystem
Library    String
*** Variables ***
${MINUTES_IN_DAY}   1440
${DAYS_TO_RUN}      365
${url}    ${symvar('URL')}
${user}    ${symvar('User_Name')}
${pass}    ${symvar('Passcode')}
*** Keywords ***
response_page
    ${File}    Create Empty Excel   ${symvar('File_Path')}${symvar('File_Name')}.xlsx
    ${row}    Set Variable    1
    TRY
        FOR    ${day}    IN RANGE    ${DAYS_TO_RUN}
            Log To Console    Day ${day + 1} started.
            FOR    ${minute}    IN RANGE    ${MINUTES_IN_DAY}
                ${time_o}    Get Response Time HTTPBasicAuth    url=${url}    username=${user}    password=${pass}
                # ${time_o}    Response Time    url=${url}    user=${user}    passcode=${pass}
                ${timer}    Run Keyword And Ignore Error      Convert To Number    ${time_o}
                ${threshold}    Run Keyword And Ignore Error    Convert To Number    0004.9999
                ${lo}    If Condition    response=${timer}    yourdata=${threshold}
                IF    '${lo}' == 'OK'
                    Send Mail    from_email=${symvar('From_email')}   password=${symvar('From_user_passcode')}    to_mail=${symvar('To_email')}    subject=${symvar('Subject')}     content=Hi Team,\n\nThe response time exceeds 5 Seconds. Please take a look on it :\n\n URL: ${symvar('URL')}\n\n                                                                                                                                                                                                                                 
                END
                ${response}    Get Response Check HTTPBasicAuth    url=${url}    username=${user}    password=${pass}
                ${res}    Set Variable   Response Time, ${time_o} , ${response}
                ${split_data}    Split String    ${res}    ,
                Run Keyword And Ignore Error    Write Value To Excel    file_path=${symvar('File_Path')}${symvar('File_Name')}.xlsx    sheet_name=${symvar('File_Name')}    cell=A${row}    value=${split_data[0]}
                Run Keyword And Ignore Error    Write Value To Excel    file_path=${symvar('File_Path')}${symvar('File_Name')}.xlsx    sheet_name=${symvar('File_Name')}    cell=B${row}    value=${split_data[1]}
                Run Keyword And Ignore Error    Write Value To Excel    file_path=${symvar('File_Path')}${symvar('File_Name')}.xlsx    sheet_name=${symvar('File_Name')}    cell=C${row}    value=${split_data[2]}
                Run Keyword And Ignore Error    Write Value To Excel    file_path=${symvar('File_Path')}${symvar('File_Name')}.xlsx    sheet_name=${symvar('File_Name')}    cell=D${row}    value=${split_data[3]}
                Run Keyword And Ignore Error    Write Value To Excel    file_path=${symvar('File_Path')}${symvar('File_Name')}.xlsx    sheet_name=${symvar('File_Name')}    cell=E${row}    value=${split_data[4]}
                Run Keyword And Ignore Error    Write Value To Excel    file_path=${symvar('File_Path')}${symvar('File_Name')}.xlsx    sheet_name=${symvar('File_Name')}    cell=F${row}    value=${split_data[5]}
                Run Keyword And Ignore Error    Write Value To Excel    file_path=${symvar('File_Path')}${symvar('File_Name')}.xlsx    sheet_name=${symvar('File_Name')}    cell=G${row}    value=${split_data[6]}
                Run Keyword And Ignore Error    Write Value To Excel    file_path=${symvar('File_Path')}${symvar('File_Name')}.xlsx    sheet_name=${symvar('File_Name')}    cell=H${row}    value=${split_data[7]}
                Run Keyword And Ignore Error    Write Value To Excel    file_path=${symvar('File_Path')}${symvar('File_Name')}.xlsx    sheet_name=${symvar('File_Name')}    cell=I${row}    value=${split_data[8]}
                Sleep     1 minutes 
                ${row}    Evaluate    ${row} + 1
                Log To Console    Day ${day + 1} completed.
            END
        END
    EXCEPT
        Continue For Loop
    END