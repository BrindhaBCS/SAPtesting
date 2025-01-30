*** Settings ***
Library    SeleniumLibrary
Library    Collections


*** Keywords ***
Opening Browser

    Open Browser    ${symvar('Java_Browser_link')}    Chrome    options=add_argument("--ignore-certificate-errors")
    Wait Until Element Is Visible    xpath:(//table[@id='tblInnerCnt']//div)[3]    60s
    Maximize Browser Window
    SeleniumLibrary.Input Text    id:logonuidfield    ${symvar('Java_user_id')}
    Sleep    2
    # SeleniumLibrary.Input Text    id:logonpassfield    ${symvar('Java_password')}
    # Sleep    2
    SeleniumLibrary.Input Text    id:logonpassfield    %{java_User_Password}
    Sleep    2
    SeleniumLibrary.Click Button    xpath://input[@value='Log On']
    Wait Until Keyword Succeeds    2 minute    5s    Wait until element is visible    id:CEPJ.IDPView.TextView    
    
    ${sap_title}    Get Title
    Log To Console    ${sap_title}

check_destinations
    Input Text    id:CEPJ.IDPView.InputField1    destinations  
    Sleep    2
    Click Element    id:CEPJ.IDPView.Button1 
    Sleep    2
    Click Element    id:CEPJFMAJ.WorkCenterOverviewView._52-text
    Wait Until Keyword Succeeds    2 minute    5s    Wait until element is visible    id:CEPJICNK.MainView.CreateButton
    Sleep    2

    Press Keys    xpath://td[@class='lsField__inputcontainer']//span[1]    ${symvar('Destination_name')}    ENTER
    Sleep    1
    
    Click Element    xpath:(//div[@class='urST5SCMetricInner'])[1]
    Sleep    1
    
    Click Element    id:CEPJICNK.DetailsView.PingButton
    Sleep    2
    ${ping_dist}    Get Text    id:CEPJ.IDPView.MessageArea-txt


    Click Element    id:CEPJICNK.DetailsView.Con_TLS_Props_Interface_View_Tab-title
    Sleep    1

    #### connection & transport ###
    ${connection & transport}    Create List
    ${url}    Get Value    id:CEPJICNKNJDI.ConTLSPropsView.Url
    Log    ${url}
    Append To List    ${connection & transport}    URL : ${url}

    ${system_id}    Get Value    id:CEPJICNKNJDI.ConTLSPropsView.SystemID
    Log    ${system_id}
    Append To List    ${connection & transport}    System id : ${system_id}

    ${Client}    Get Value    id:CEPJICNKNJDI.ConTLSPropsView.Client
    Log    ${Client}
    Append To List    ${connection & transport}    Client : ${Client}

    ${Language}    Get Value    id:CEPJICNKNJDI.ConTLSPropsView.Language
    Log    ${Language}
    Append To List    ${connection & transport}    Language : ${Language}

    ${Trusted Server Certificates Keystore View}    Get Value    id:CEPJICNKNJDI.ConTLSPropsView.AcceptedServerCertificatesKSView
    Log    ${Trusted Server Certificates Keystore View}
    Append To List    ${connection & transport}    Trusted Server Certificates Keystore View : ${Trusted Server Certificates Keystore View}

    ${connection & transport_details}    Evaluate    '\\n'.join(${connection & transport})
    

    #### Logon data ####
    Click Element    id:CEPJICNK.DetailsView.Auth_Props_Interface_View_Tab-title
    Sleep    1
    ${Logon_data}    Create List
    ${Authentication}    Get Value    id:CEPJICNKNJDI.AuthPropsView.DropDownByIndex2
    Log    ${Authentication}
    Append To List    ${Logon_data}    Authentication : ${Authentication}

    ${user_name}    Get Value    id:CEPJICNKNJDI.AuthPropsView.Username
    Log    ${user_name}
    Append To List    ${Logon_data}    user name : ${user_name}  

    ${password}    Get Value    id:CEPJICNKNJDI.AuthPropsView.Password
    Log    ${password}
    Append To List    ${Logon_data}    password : ${password}
    ${Logon_data_details}    Evaluate    '\\n'.join(${Logon_data})

    
    Log    ping Destination popup : ${ping_dist}
    Log To Console    **gbStart**ping Destination popup**splitKeyValue**${ping_dist}**gbEnd**
    Log    connection & transport_details : ${connection & transport_details}
    Log To Console    **gbStart**connection & transport_details**splitKeyValue**${connection & transport_details}**gbEnd**
    Log    Logon_data_details : ${Logon_data_details}
    Log To Console    **gbStart**Logon_data_details**splitKeyValue**${Logon_data_details}**gbEnd**
    

close_browser
    Close All Browsers