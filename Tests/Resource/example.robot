*** Settings ***
Library    DateTime
Force Tags  Date

*** Keywords ***
Date
    ${date}    Get Current Date    result_format=%d.%m.%Y
    ${month}    Get Current Date    result_format=%m
    ${year}    Get Current Date    result_format=%Y
    ${Month}    Get Current Date    result_format=%b
    Log To Console    ${year}
    Log To Console    ${Month}

*** Test Cases ***
Date format
    Date