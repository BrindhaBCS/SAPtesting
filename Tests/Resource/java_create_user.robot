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

Create_user_id
    Input Text    id:CEPJ.IDPView.InputField1    users  
    Sleep    2
    Click Element    id:CEPJ.IDPView.Button1 
    Sleep    2
    
    Click Element    id:CEPJFMAJ.WorkCenterOverviewView._53-text
    Wait Until Keyword Succeeds    2 minute    5s    Wait until element is visible    id:CEPJICNKCBKIAFHGJKNEPINJ.UserSearchResultView.CreateButton
    
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.UserSearchResultView.CreateButton
    Sleep    2
    Input Text    id:CEPJICNKCBKIAFHGJKNEPINJ.ModifyUserView.LogonId    ${symvar('logon_id')}
    Sleep    1
    Input Text    id:CEPJICNKCBKIAFHGJKNEPINJ.ModifyUserView.newPassword    ${symvar('password')}
    Sleep    1
    Input Text    id:CEPJICNKCBKIAFHGJKNEPINJ.ModifyUserView.confirmPassword    ${symvar('password')}
    Sleep    1
    Input Text    id:CEPJICNKCBKIAFHGJKNEPINJ.ModifyUserView.lastName    ${symvar('lastname')}
    Sleep    1
    Input Text    id:CEPJICNKCBKIAFHGJKNEPINJ.ModifyUserView.firstName    ${symvar('firstname')}
    Sleep    1

    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.ModifyUserView.associatedRoles-title
    Sleep    1
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJAHAG.AssignParentRolesView.DatasourcesDDBI-btn
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
        
        Sleep    1
        Log    Text from Table ${name_count}: ${data}

        IF  '${data}' == 'Administrator'
            
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
    Capture Page Screenshot




    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.ModifyUserView.associatedGroups-title
    Sleep    2
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJEKFD.AssignParentGroupsView.DatasourcesDDBI
    Sleep    2
    Press Keys      xpath:(//div[@data-itemindex='2'])[2]    ARROW_DOWN
    Sleep    2
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJEKFD.AssignParentGroupsView.buttonGroupSearch
    Sleep    2

    ${Assigned_name_count}    Set Variable    0

    WHILE    True
        ${Assigned_element}    Set Variable    CEPJICNKCBKIAFHGJKNEPINJEKFD.AssignParentGroupsView.avGroupUniqueIDs.${Assigned_name_count}
        
    
        ${data_visible}    Run Keyword And Return Status    Get Text    ${Assigned_element}
        Run Keyword If    not ${data_visible}    Exit For Loop
        ${data}    Get Text    ${Assigned_element}
        Sleep    1
        
        Log    Text from Table ${Assigned_name_count}: ${data}
        ${g_count}    Get Length    ${symvar('groups_to_check')}

    
        FOR  ${group}  IN RANGE    0    ${g_count} 
            IF    '${data}' == '${symvar('groups_to_check')}[${group}]'
                # Log    Found group: ${group}
                Click Element    xpath://div[@class='urBorderBox lsSTCellHeight100 urSTSCOuterDiv urSTRowUnSelIcon urST4LbUnselIcon urST5SCStdInner']
                Capture Page Screenshot
                Sleep    1
                Click Element    id:CEPJICNKCBKIAFHGJKNEPINJEKFD.AssignParentGroupsView.buttonGroupAdd
                Sleep    1
                
                Exit For Loop
                # BREAK
            END
        END
        
        ${Assigned_name_count}    Evaluate    ${Assigned_name_count} + 1
        Run Keyword And Ignore Error    Click Element    xpath:(//div[@acf='Nxt'])[2]
        
    END
    
    Click Element    id:CEPJICNKCBKIAFHGJKNEPINJ.ModifyUserView.save
    Sleep    4

    
close_browser
    Close All Browsers


    