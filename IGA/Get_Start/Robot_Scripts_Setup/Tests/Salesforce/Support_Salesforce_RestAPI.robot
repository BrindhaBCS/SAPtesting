*** Settings ***
Documentation         API Testing Keywords for the operations like GET, PUT, POST, PATCH and DELETE.
...                   This library is based on RequestsLibrary.
Library               Collections
Library               RequestsLibrary

*** Keywords ***
Create HTTP Session With No Authentication
    [Documentation]  Creates session for performing HTTP actions
    [Arguments]  ${url}  ${alias}
    Create Session  ${alias}  ${url}  auth=None

Create HTTP Session With Authentication
    [Documentation]  Creates session for performing HTTP actions with credentials
    [Arguments]  ${url}  ${alias}  ${username}  ${password}
    ${auth}=    Create Dictionary   ${username}  ${password}
    Create Session  ${alias}  ${url}  auth=${auth}

Fetch Authentication Token And Instance URL
    [Documentation]  Fetches authentication token and instance URL from Salesforce Sandbox environment
    [Arguments]  ${url}  ${alias}  ${grant_type}  ${client_id}  ${client_secret}  ${username}  ${password}
    ${headers}=     Create Dictionary       Content-Type=application/x-www-form-urlencoded
    ${data}=        Create Dictionary       grant_type=${grant_type}
                    ...     client_id=${client_id}
                    ...     client_secret=${client_secret}
                    ...     username=${username}
                    ...     password=${password}
    Create HTTP Session With No Authentication  ${url}  ${alias}
    ${response}=    POST On Session    ${alias}     /services/oauth2/token    data=${data}     headers=${headers}
    ${AccessToken}=    Evaluate    $response.json().get("access_token")
    ${InstanceUrl}=    Evaluate    $response.json().get("instance_url")
    Set Global Variable  ${AccessToken}
    Set Global Variable  ${InstanceUrl}

Get Headers With Bearer Token
    [Documentation]  Creates headers with Bearer Token
    ${BearerToken}=     Catenate  Bearer  ${AccessToken}
    ${headers}=         Create Dictionary       Content-Type=application/json
                                    ...         Accept-Encoding=gzip
                                    ...         Authorization=${BearerToken}
    [Return]  ${headers}

Get Method
    [Documentation]  Invokes GET Request from RequestKeywords library
    [Arguments]     ${endpoint}  ${alias}
    ${headers}=     Get Headers With Bearer Token
    ${response}=     GET On Session  ${alias}  ${endpoint}  headers=${headers}
    [Return]  ${response}

Post Method
    [Documentation]  Invokes POST Request from RequestKeywords library
    [Arguments]     ${endpoint}  ${alias}  ${data}
    ${headers}=     Get Headers With Bearer Token
    ${response}=     POST On Session    ${alias}  ${endpoint}  data=${data}  headers=${headers}
    [Return]  ${response}

Put Method
    [Documentation]  Invokes PUT Request from RequestKeywords library
    [Arguments]     ${endpoint}  ${alias}  ${data}
    ${headers}=     Get Headers With Bearer Token
    ${response}=     PUT On Session  ${alias}  ${endpoint}  headers=${headers}  data=${data}
    [Return]  ${response}

Patch Method
    [Documentation]  Invokes PATCH Request from RequestKeywords library
    [Arguments]     ${endpoint}  ${alias}  ${data}
    ${headers}=     Get Headers With Bearer Token
    ${response}=     PATCH On Session  ${alias}  ${endpoint}  headers=${headers}  data=${data}
    [Return]  ${response}

Delete Method
    [Documentation]  Invokes DELETE Request from RequestKeywords library
    [Arguments]     ${endpoint}  ${alias}
    ${headers}=     Get Headers With Bearer Token
    ${response}=     DELETE On Session  ${alias}  ${endpoint}  headers=${headers}
    [Return]  ${response}

