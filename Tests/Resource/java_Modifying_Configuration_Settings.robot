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

Modifying Configuration Settings
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

    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.DisplayUserView.edit
    Sleep    2
    

    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.ModifyUserView.associatedRoles-title
    Sleep    2
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJAHAG.AssignParentRolesView.DatasourcesDDBI-r
    Sleep    2

    Press Keys      xpath:(//div[@data-itemindex='2'])[2]    ARROW_DOWN
    Sleep    2
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJAHAG.AssignParentRolesView.buttonRoleSearch
    Sleep    2


    ${name_count}    Set Variable    0
    WHILE    True
        ${element}    Set Variable    CEPJICNKCBKIAFHGJKNEPINJAHAG.AssignParentRolesView.avRoleID.${name_count}
        
    
        ${data_visible}    Run Keyword And Return Status    Get Text    ${element}
        Run Keyword If    not ${data_visible}    Exit For Loop
        ${data}    Get Text    ${element}
        Sleep    1
        # Run Keyword And Ignore Error    Click Element    xpath:(//div[@acf='Nxt'])[2]
        Sleep    1
        Log    Text from Table ${name_count}: ${data}

        IF  '${data}' == 'Alerting.Standard'
            
            Click Element    xpath://div[@class='urBorderBox lsSTCellHeight100 urSTSCOuterDiv urSTRowUnSelIcon urST4LbUnselIcon urST5SCStdInner']
            Capture Page Screenshot
            Sleep    1
            Exit For Loop
        END
        Run Keyword And Ignore Error    Click Element    xpath:(//div[@acf='Nxt'])[2]
        
        ${name_count}    Evaluate    ${name_count} + 1
    END
    Click Element    xpath://div[@title='Add selected roles to list of assigned roles']
    Sleep    2

    ### Assigned group ###
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.ModifyUserView.associatedGroups-title
    Sleep    2

    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJEKFD.AssignParentGroupsView.DatasourcesDDBI
    Sleep    2

    Press Keys      xpath:(//div[@data-itemindex='2'])[2]    ARROW_DOWN
    Sleep    2
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJEKFD.AssignParentGroupsView.buttonGroupSearch
    Sleep    2


    ${modify_name_count}    Set Variable    0
    
    WHILE    True
        ${Assigned_element}    Set Variable    CEPJICNKCBKIAFHGJKNEPINJEKFD.AssignParentGroupsView.avGroupUniqueIDs.${modify_name_count}
        ${data_visible}    Run Keyword And Return Status    Get Text    ${Assigned_element}
        Run Keyword If    not ${data_visible}    Exit For Loop
        ${Modify_data}    Get Text    ${Assigned_element}
        Sleep    1
        
        Log    Text from Table ${modify_name_count}: ${Modify_data}
        ${a_count}    Get Length    ${symvar('groups_name')}

        FOR  ${Assigned_group}  IN RANGE    0    ${a_count}
            IF    '${Modify_data}' == '${symvar('groups_name')}[${Assigned_group}]'
                Log    Found group: ${Assigned_group}
                Click Element    xpath://div[@class='urBorderBox lsSTCellHeight100 urSTSCOuterDiv urSTRowUnSelIcon urST4LbUnselIcon urST5SCStdInner']
                Sleep    2
                Capture Page Screenshot
                Sleep    1
                Click Element    id:CEPJICNKCBKIAFHGJKNEPINJEKFD.AssignParentGroupsView.buttonGroupAdd
                Sleep    1
                Exit For Loop
            END
        END

        ${modify_name_count}    Evaluate    ${modify_name_count} + 1
        Run Keyword And Ignore Error    Click Element    xpath:(//div[@acf='Nxt'])[2]
    END



    ####removing  groups ####
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJEKFD.RemoveParentGroupsView.DatasourcesDDBI
    Sleep    2

    Press Keys      id:CEPJICNKCBKIAFHGJKNEPINJEKFD.RemoveParentGroupsView.Datasources.displayName-key-2    ARROW_DOWN
    Sleep    2
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJEKFD.RemoveParentGroupsView.Button1_5
    Sleep    2
    ${remove_name_count}    Set Variable    0

    

    WHILE    True
        ${Assigned_remove_element}    Set Variable    CEPJICNKCBKIAFHGJKNEPINJEKFD.RemoveParentGroupsView.groupUniqueIDs.${remove_name_count}
        ${data_visible}    Run Keyword And Return Status    Get Text    ${Assigned_remove_element}
        Run Keyword If    not ${data_visible}    Exit For Loop
        ${removing_data}    Get Text    ${Assigned_remove_element}
        Sleep    1
        
        Log    Text from Table ${remove_name_count}: ${removing_data}

        ${exit_while}    Set Variable    False
        ${R-group}    Get Length    ${symvar('remove_name')}
        FOR  ${Assigned_remove_group}  IN RANGE    0    ${R-group}
            IF    '${removing_data}' == '${symvar('remove_name')}[${Assigned_remove_group}]'
                Log    Found group: ${Assigned_remove_group}
                Click Element    xpath://td[@id='CEPJICNKCBKIAFHGJKNEPINJEKFD.RemoveParentGroupsView.assignedGroups:1.0']/div[1]
                Sleep    2
                Capture Page Screenshot
                Sleep    1
                Click Element    id:CEPJICNKCBKIAFHGJKNEPINJEKFD.RemoveParentGroupsView.buttonGroupRemove
                Sleep    1
                ${exit_while}    Set Variable    True
                Exit For Loop
            END
        END

        Run Keyword If    '${exit_while}' == 'False'    Exit For Loop

    END
    
    Click Element    id:CEPJ.IDPView.LogOffLinkToAction-text
    Sleep    5

close_browser
    Close All Browsers

