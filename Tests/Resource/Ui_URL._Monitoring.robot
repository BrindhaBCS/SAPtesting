*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Library    ui_url_keywords.py
Library    OperatingSystem

*** Variables ***
${First_url}    ${symvar('UI_First_url')} 
${First_Username}    ${symvar('UI_First_Username')} 
${First_Password}    ${symvar('UI_First_Password')}
${Second_url}    ${symvar('UI_Second_url')}
${Second_Username}    ${symvar('UI_Second_Username')}
${Second_Password}    ${symvar('UI_Second_Password')}
${Third_url}    ${symvar('UI_Third_url')}
${Third_Username}    ${symvar('UI_Third_Username')}
${Third_Password}    ${symvar('UI_Third_Password')}
${Browser}    ${symvar('UI_Browser')}
${MINUTES_IN_DAY}    ${symvar('UI_MINUTES_IN_DAY')}
${Days_to_run}    ${symvar('UI_Days_to_run')}
*** Keywords ***
Response_time_user
    FOR    ${day}    IN RANGE    ${Days_to_run}
        Log To Console    Day ${day + 1} started.
        FOR    ${minute}    IN RANGE    ${MINUTES_IN_DAY}
            Response_Time_First_Url    Url=${First_url}    CustomerCode=c100001    Username=${First_Username}    Password=${First_Password}
            Response_Time_Second_Url    Url=${Second_url}    Username=${Second_Username}    Password=${Second_Password}
            Response_Time_third_Url    Url=${Third_url}    Username=${Third_Username}    Password=${Third_Username}
        END
    END
Response_Time_First_Url
    [Arguments]    ${Url}    ${CustomerCode}    ${Username}    ${Password}
    ${Starttime}    Get Current Date    time_zone=UTC
    Open Browser    ${Url}    ${Browser}
    Wait Until Element Is Visible    id:user_name    timeout=60s
    Input Text        id=customer_code    ${CustomerCode}
    Input Text         id=user_name    ${Username}
    Input Text         id=password    ${Password}
    Click Button       xpath://button[normalize-space(text())='LOGIN']
    Set Screenshot Directory    ${symvar('Screenshot_Directory_path')}
    Capture Page Screenshot    filename=screenshot.png
    ${Endtime}    Get Current Date    time_zone=UTC
    ${Duration}    Calculate Time Difference   start_time_str=${Starttime}    end_time_str=${Endtime}
    Log    ${Duration} seconds.
    Close Browser
Response_Time_Second_Url
    [Arguments]    ${Url}    ${Username}    ${Password}
    ${Starttime}    Get Current Date    time_zone=UTC
    Open Browser    ${Url}    ${Browser}
    Wait Until Element Is Visible    id:user_name    timeout=60s
    Input Text         id=user_name    ${Username}
    Input Text         id=user_password    ${Password}
    Click Button       id:sysverb_login
    Set Screenshot Directory    ${symvar('Screenshot_Directory_path')}
    Capture Page Screenshot    filename=screenshot1.png
    ${Endtime}    Get Current Date    time_zone=UTC
    ${Duration}    Calculate Time Difference   start_time_str=${Starttime}    end_time_str=${Endtime}
    Log    ${Duration} seconds.
    Close Browser
Response_Time_third_Url
    [Arguments]    ${Url}    ${Username}    ${Password}
    ${Starttime}    Get Current Date    time_zone=UTC
    Open Browser    ${Url}    ${Browser}
    Click Element    xpath://a[normalize-space()='Login']
    Wait Until Element Is Visible    id:username    timeout=60s
    Input Text         id=username    ${Username}
    Input Text         id=password    ${Password}
    Click Button       xpath://button[text()='Sign in']
    Set Screenshot Directory    ${symvar('Screenshot_Directory_path')}
    Capture Page Screenshot    filename=screenshot2.png
    ${Endtime}    Get Current Date    time_zone=UTC
    ${Duration}    Calculate Time Difference   start_time_str=${Starttime}    end_time_str=${Endtime}
    Send Mail    from_email=${symvar('UI_FROM_EMAIL')}    password=${symvar('UI_PASSWORD')}    to_mail=${symvar('UI_TO_EMAILS')}    subject=${symvar('UI_SUBJECT')}    content=${symvar('UI_CONTENT')}\n${symvar('UI_First_url')}\n${symvar('UI_Second_url')}\n${symvar('UI_Third_url')}    file_paths=["${symvar('Screenshot_Directory_path')}\\screenshot.png","${symvar('Screenshot_Directory_path')}\\screenshot1.png","${symvar('Screenshot_Directory_path')}\\screenshot2.png",]
    File Remove    directory=${symvar('Screenshot_Directory_path')}    extensions=.png
    Log    ${Duration} seconds.