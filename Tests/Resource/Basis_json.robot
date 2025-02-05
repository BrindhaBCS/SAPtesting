# *** Settings ***
# Library    Report_Library.py
# *** Variables ***
# ${data}    ${symvar('Jsondata')}
# *** Keywords ***
# New_json
#     ${local}    Basis Formate Json Data    input_string=${data}    removed_lines=2
#     Log To Console    **gbStart**copilot_status_json**splitKeyValue**${local}**gbEnd**

*** Settings ***
Library    Collections
Library    String
Library    BuiltIn
Library    OperatingSystem

*** Variables ***
${HTML_FILE_PATH}    C:\\tmp\\Copilot\\Basisoutput.html
${JSON_STRING}    ${symvar('Jsondata')}

*** Keywords ***
Convert JSON to HTML and Save
    ${parsed_json}=    Evaluate    json.loads(r"""${JSON_STRING}""")    modules=json
    ${html_content}=    Create HTML From JSON    ${parsed_json}
    Create File    ${HTML_FILE_PATH}    ${html_content}
    Log    HTML file created at: ${HTML_FILE_PATH}

*** Keywords ***
Create HTML From JSON
    [Arguments]    ${json_data}
    ${html}    Set Variable    <html><head><title>Data</title></head><body>
    ${html}    Catenate    ${html}    <h2>Log Message</h2><p>${json_data["log"]}</p>
    ${html}    Catenate    ${html}    <h2>Data</h2><table border="1"><tr><th>SID</th><th>CLIENT</th><th>USER_ID</th><th>ROLE</th><th>USERNAME</th><th>FROM_DATE</th><th>TO_DATE</th><th>ROLE_DESCRIPTION</th></tr>
    FOR    ${item}    IN    @{json_data["data"]}
        ${row}    Catenate    <tr><td>${item["SID"]}</td><td>${item["CLIENT"]}</td><td>${item["USER_ID"]}</td><td>${item["ROLE"]}</td><td>${item["USERNAME"]}</td><td>${item["FROM_DATE"]}</td><td>${item["TO_DATE"]}</td><td>${item["ROLE_DESCRIPTION"]}</td></tr>
        ${html}    Catenate    ${html}    ${row}
    END
    ${html}    Catenate    ${html}    </table></body></html>
    [Return]    ${html}