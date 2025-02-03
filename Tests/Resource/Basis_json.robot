*** Settings ***
Library    Report_Library.py
*** Variables ***
${data}    ${symvar('Jsondata')}
*** Keywords ***
New_json
    ${local}    Basis Formate Json Data    input_string=${data}    removed_lines=2
    Log To Console    **gbStart**copilot_status_json**splitKeyValue**${local}**gbEnd**