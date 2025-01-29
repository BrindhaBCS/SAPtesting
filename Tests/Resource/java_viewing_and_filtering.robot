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

viewing and filtering
    Input Text    id:CEPJ.IDPView.InputField1    users  
    Sleep    2
    Click Element    id:CEPJ.IDPView.Button1 
    Sleep    2
    
    Click Element    id:CEPJFMAJ.WorkCenterOverviewView._53-text
    Wait Until Keyword Succeeds    2 minute    5s    Wait until element is visible    id:CEPJICNKCBKIAFHGJKNEPINJ.UserSearchResultView.CreateButton
        
    Input Text    id:CEPJICNKCBKIAFHGJKNE.BasicSearchView.PrincipalIdIF_NL    ${symvar('logon_id')}
    Sleep    1
    Click Element    id:CEPJICNKCBKIAFHGJKNE.BasicSearchView.SearchButton1
    Sleep    1

    Click Element    xpath:(//div[@class='urST5SCMetricInner'])[1]
    Wait until element is visible    id:CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.edit    60s
    

    #### General information ######
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.generalInformation-title
    Sleep    2
    ${general}    Get Text    xpath:(//td[contains(@class,'lsContainerCell lsContainerCellVAlign--top')])[1]
    Log    ${general}

    #### Account information #####
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.accountInformation-title
    Sleep    2
    ${Account}    Get Text    xpath:(//div[@id='CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.accountInformation-cnt']//div)[1]
    Log    ${Account}


    #### contact information #####
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.contactInformation-title
    Sleep    2
    ${contact}    Get Text    xpath:(//div[@id='CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.contactInformation-cnt']//div)[1]
    Log    ${contact}

    #### Additional information #####
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.additionalInformation-title
    Sleep    2
    ${additional}    Get Text    xpath:(//div[@id='CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.additionalInformation-cnt']//div)[1]
    Log    ${additional}

    #### Assigned roles ###
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.associatedRoles-title
    Sleep    1
    
    ${role_count}=    Get Element Count    xpath://span[@id='CEPJICNKCBKIAFHGJKNEPINJAHAG.DisplayParentRolesView.roleID.0-r']
    ${ROLES_LIST}    Create List     
    FOR    ${index}    IN RANGE    ${role_count}
        ${Assign_role_name}=    Get Text    id:CEPJICNKCBKIAFHGJKNEPINJAHAG.DisplayParentRolesView.roleID.${index}
        Append To List    ${ROLES_LIST}    NAME : ${Assign_role_name}
        ${Assign_description}=    Get Text    id:CEPJICNKCBKIAFHGJKNEPINJAHAG.DisplayParentRolesView.roleName.${index}
        Append To List    ${ROLES_LIST}    DESCRIPTION : ${Assign_description}
        ${Assign_data_source}=    Get Text    id:CEPJICNKCBKIAFHGJKNEPINJAHAG.DisplayParentRolesView.TextView.${index}
        Append To List    ${ROLES_LIST}    DATA SOURCE : ${Assign_data_source}
        # Optionally, append to roles list
        ${assigned_role_details}    Evaluate    '\\n'.join(${ROLES_LIST})
        Log    ${assigned_role_details}
        
        
    END

    ### Assigned group ###
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.associatedGroups-title
    Sleep    2
    
    ${Assigned_group_count}    Set Variable    0
    ${group_list}    Create List
    WHILE    True
        ${element}    Set Variable    CEPJICNKCBKIAFHGJKNEPINJEKFD.DisplayParentGroupsView.TextView5.${Assigned_group_count}
        ${data_visible}    Run Keyword And Return Status    Get Text    ${element}
        Run Keyword If    not ${data_visible}    Exit For Loop
        # ${data}    Get Text    ${element}
        # Sleep    1
        ${Assign_group_name}=    Get Text    id:CEPJICNKCBKIAFHGJKNEPINJEKFD.DisplayParentGroupsView.TextView5.${Assigned_group_count}
        Append To List    ${group_list}    NAME : ${Assign_group_name}
        ${Assign_group_description}=    Get Text    id:CEPJICNKCBKIAFHGJKNEPINJEKFD.DisplayParentGroupsView.TextView6.${Assigned_group_count}
        Append To List    ${group_list}    DESCRIPTION : ${Assign_group_description}
        ${Assign_group_data_source}=    Get Text    id:CEPJICNKCBKIAFHGJKNEPINJEKFD.DisplayParentGroupsView.TextView.${Assigned_group_count}
        Append To List    ${group_list}    DATA SOURCE : ${Assign_group_data_source}
        Run Keyword And Ignore Error    Click Element    xpath:(//div[@acf='Nxt'])[2]
        Sleep    1
                
        ${Assigned_group_count}    Evaluate    ${Assigned_group_count} + 1
    END
    ${assigned_group_details}    Evaluate    '\\n'.join(${group_list})
    Log    ${assigned_group_details}


    ### user mapping for system Access ####
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.userMapping-title
    Sleep    2
    ${user_mapping}    Get Text    xpath:(//div[@id='CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.userMapping-cnt']//div)[1]
    Log    ${user_mapping}

close_browser
    Close All Browsers

