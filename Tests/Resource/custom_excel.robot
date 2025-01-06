*** Settings ***

Library    OperatingSystem
Library    String
Library    SAP_Tcode_Library.py
Library     DateTime
Library     ExcelLibrary
Library     openpyxl

*** Variables ***

${file_name}    C:\\EID_Parry\\Rental.xlsx
${sheet_name}    Sheet1
${target_file_name}    C:\\EID_Parry\\Rental_output.xlsx
${target_sheet_name}    Sheet1
${list_value}    ${symvar('document_json')}
@{column_names}    Sales document type    Valid-To Date    Sold-To Party

*** Keywords ***

customize excel for output
    ${column_count}    Count Excel Columns    ${file_name}    ${sheet_name}
    Log To Console      ${column_count}

    ${column}    Evaluate    ${column_count} + 1
    Log To Console      rental excel column: ${column}

    FOR    ${name}    IN    @{column_names}
        Log To Console      column to be deleted is:${name}

        FOR  ${l}  IN RANGE  1    ${column}
            Log To Console      pre excel column is: ${l}

            ${data}    Read Excel Cell Value    ${file_name}    ${sheet_name}    1    ${l}
            Log To Console      column name in pre excel:${data}

            IF  '${data}' == '${name}'
                Delete Excel Column    ${file_name}    ${sheet_name}    ${l}
                Log To Console    column ${l} deleted
            # ELSE IF  '${data}' == 'Sold-To Party'
            #     Delete Excel Column    ${file_name}    ${sheet_name}    ${l}
            #     Log To Console    column ${l} deleted
            END
        END
    END

    FOR  ${i}  IN RANGE  1    ${column}
        Log To Console      pre excel column1 : ${i}

        ${data}    Read Excel Cell Value    ${file_name}    ${sheet_name}    1    ${i}
        Log To Console      pre excel column name is:${data}

        IF  '${data}' == 'Sales document'
            @{documents}    Evaluate    [item['document'] for item in ${list_value}]
            ${row_count}    Count Excel Rows    ${file_name}    ${sheet_name}
            Log To Console      pre excel row count for write output:${row_count}

            ${rows}    Evaluate    ${row_count} + 1
            Log To Console      pre excel row range for write output: ${rows}

            FOR  ${document}  IN  @{documents}
                Log To Console    document no is :${document}
                FOR  ${j}  IN RANGE  2    ${rows}
                    ${input}    Read Excel Cell Value    ${file_name}    ${sheet_name}    ${j}    ${i}
                    IF    ${input} == "${document}"
                        Log To Console    ${input} is in row of ${j}

                        ${input}    Get Index    ${documents}    ${document}
                        Log To Console      Index number for selected document:${input}

                        ${index}    Evaluate    ${index_number} + 2
                        Log To Console    Index is: ${index}

                        ${row_data}    Read Row From Excel    ${file_name}    ${sheet_name}    ${j}
                        Log To Console    row data is:${row_data}

                        Write Row To Excel    ${target_file_name}    ${target_sheet_name}    ${index}    ${row_data}

                    END
                END
            END
        END
    END
    
delete the existing excel details
    ${excel_row}    Count Excel Rows    ${target_file_name}    ${target_sheet_name}
    ${excel_rows}    Evaluate    ${excel_row} + 1
    FOR  ${k}  IN RANGE    2    ${excel_rows}
        Delete Excel Row        ${target_file_name}    ${target_sheet_name}    ${k}    
    END
    



