*** Settings ***
Library    DateTime
Force Tags  Date

*** Keywords ***
Date
    ${date}    Get Current Date    result_format=%d.%m.%Y
    ${month}    Get Current Date    result_format=%M
    Log To Console    ${date}
    Log To Console    ${month}

*** Test Cases ***
Date format
    Date