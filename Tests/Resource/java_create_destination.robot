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

create_destinations
    Input Text    id:CEPJ.IDPView.InputField1    destinations  
    Sleep    2
    Click Element    id:CEPJ.IDPView.Button1 
    Sleep    2
    Click Element    id:CEPJFMAJ.WorkCenterOverviewView._52-text
    Wait Until Keyword Succeeds    2 minute    5s    Wait until element is visible    id:CEPJICNK.MainView.CreateButton
    Sleep    2

    Click Element    id:CEPJICNK.MainView.CreateButton    
    Sleep    2
    Input Text    id:CEPJICNK.GeneralPropsView.Name    ${symvar('Destination_name')}
    Sleep    1
    Click Element    id:CEPJICNK.GeneralPropsView.DestTypeID-btn
    Sleep    2

    Select Frame    xpath=//iframe[@id='URLSPW-0']
    Sleep    1
    
    Click Element    xpath://span[text()='${symvar('Destination_type')}']
    Sleep    2
    Unselect Frame
    Click Element    id:CEPJICNK.WizardView.WizNextButton
    Sleep    2
    Input Text    id:CEPJICNKNJDI.ConTLSPropsView.Url    ${symvar('connection_information_url')}
    Sleep    1
    Input Text    id:CEPJICNKNJDI.ConTLSPropsView.SystemID    ${symvar('system_id')}
    Sleep    1
    Click Element    id:CEPJICNK.WizardView.WizNextButton
    Sleep    2
    Click Element    id:CEPJICNKNJDI.AuthPropsView.DropDownByIndex2-btn
    Sleep    1
    Click Element    xpath://div[@data-itemvalue1='${symvar('Authentication')}']
    Sleep    1
    Input Text    id:CEPJICNKNJDI.AuthPropsView.Username    ${symvar('Basic_Authentication_user_name')}
    Sleep    1
    Input Text    id:CEPJICNKNJDI.AuthPropsView.Password    ${symvar('Basic_Authentication_password')}
    Sleep    1
    Click Element    id:CEPJICNK.WizardView.WizFinishButton
    Sleep    2
    ${success_popup}    Get Text    id:CEPJ.IDPView.MessageArea
    Log    ${success_popup}
    Log To Console    **gbStart**create_destination_Status**splitKeyValue**${success_popup}**gbEnd**



close_browser
    Close All Browsers



    
    