*** Settings ***
Documentation     Executes test with Saucelab support.
Library           RequestsLibrary

*** Keywords ***
#Using the api call to get the list of the available devices on Saucelabs
Get First Available Mobile Real devices on Saucelabs
    [Documentation]   Connect to the SL api call to get the list of the available mobile real devices
    ...               Then go through the list and find an device type
    ...               variable selectDevice = Android or specify
    ...               variable testDeviceType =   Android, iPhone, iPad, Specific Android brand example:Google, Samsung
    [Arguments]  ${selectDevice}    ${testDeviceType}
    create session  "mysession"     ${mvar('device_get_url')}     verify=true
    ${body}=      create dictionary           userId=${saucelabs_id}            accesskey=${saucelabs_key}
    ${header}=    create dictionary     Content-Type=${mvar('content_type')}    Authorization=${saucelabs_auth}
    Log     ${body}
    Log     ${header}
    ${response}=   GET On Session    "mysession"   ${mvar('path')}
     ...        data=${body}    headers=${header}
    set global variable    ${response}
    Log   ${response.status_code}
    Log   ${response.json()}
    Should Be Equal  ${response.status_code}  ${200}
    ${FirstDevices}=     Set Variable    ${response.json()}

    #Go through the list to find device Android / iPhone / iPad
    FOR    ${item}    IN    @{FirstDevices}
        ${result} =  String.Split String   ${item}    _
        ${devicetype}=  Set Variable    ${result}[0]
        Log   ${item}
        Log   ${devicetype}
        ${Device}=   Set Variable   ${item}
        Exit For Loop If  '${selectDevice}' == '${testDeviceType}' and '${devicetype}' != 'iPhone' and '${devicetype}' != 'iPAD'
        Exit For Loop If  '${selectDevice}' == 'specify' and '${devicetype}' == '${testDeviceType}'
    END
    [Return]  ${Device}

