*** Settings ***
Library    DateTime
Library     SAP_Tcode_Library.py
Force Tags  Date

*** Variable ***
${data}     ${symvar('data')}

*** Keywords ***
Date
    ${date}    Get Current Date    result_format=%d.%m.%Y
    ${month}    Get Current Date    result_format=%m
    ${year}    Get Current Date    result_format=%Y
    ${Month}    Get Current Date    result_format=%b
    Log To Console    ${year}
    Log To Console    ${Month}
    ${subject}  Get Mail Subject    ${data}
    Log To Console      month of ${subject}

    ${month}    Subject Month
    Log To Console      The month should be in subject ${month}

    ${next_month}    Add Time To Date    ${subject}    1 months
    Log To Console    Next Month is ${next_month}

*** Test Cases ***
Date format
    Date