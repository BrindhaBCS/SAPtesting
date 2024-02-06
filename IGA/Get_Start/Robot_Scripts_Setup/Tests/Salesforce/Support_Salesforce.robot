*** Settings ***
Documentation     						Support For Every Salesforce Test. This file should be
...											populated ONLY with very generic, flexible functions and
...											variables that can be used for every Salesforce project.
Resource          						cumulusci/robotframework/Salesforce.robot
Resource                                ../Support.robot
Resource                                Support_Salesforce_RestAPI.robot

*** Variables ***
#header
${Logged In Header}						//div[contains(@class, 'system-message')]
${Done Setting Location}				False
${Generic Picklist}				        SEPARATOR=	//div[contains(@class, "uiInputSelect")]//span[text()="replaceMe"]
...                                     //following::a[1]
${Generic Picklist Popup}               SEPARATOR=	//label[contains(text(),"replaceMe")]//following::div[2]
${User Frame}                           //iframe[contains(@title,"User:")]
${PermissionSet Count}                  //div[contains(@id,'RelatedPermsetAssignmentList_body')]/table/tbody
${Related PublicGroup}                  //div[contains(@id,"RelatedPublicGroupMemberList_body")]/table/tbody

*** Keywords ***
Login As
	[Documentation]						Open the Test Broswer and Login As a profile.
	...										Use as part of user Login Keywords
	...										DO NOT use as suite setup.
	...										Instead, use "Login As Username"
	[Arguments]							${Target URL}  ${User ID}
    @{Org List} 	  					Salesforce Query  Organization
	&{Org}  							Get From List	${Org List}	0
	${Org ID}							Set Variable  	&{Org}[Id]

	Open Test Browser
    #Log browser capabilities
	${Home URL}  						Get Base URL
	Set Suite Variable  				${Home URL}  ${Home URL}
	${Login As URL}						Catenate	SEPARATOR=	${Home URL}
	...										/servlet/servlet.su?oid=	${Org ID}
	...										&suorgadminid=	${User ID}	&targetURL=	 ${Target URL}
	Go To								${Login As URL}

Login As Username
    [Documentation]                     Open browser and login as the given username. This assumes the authenticated
    ...                                 user is a System Administrator and has privilege to login as another user
    [Arguments]                         ${Username}
    ${User Id}                          Get User Id By Username     ${Username}
    Login As                            /   ${User Id}
	Wait For Aura
	${Logged In Text}					Get Text  ${Logged In Header}/span
	Should Contain  					${Logged In Text}   ${Username}    ignore_case=True

Logout From Salesforce
    close browser

Log Out User
   Click Element                      ${Logged In Header}/a

Get Base URL
	[Documentation]						Get the current base URL (Everything before '.com')
	${Current URL}						Get Location
	${Split Current URL}				Split String  ${Current URL}  separator=.com
	${Base URL}  						Get From List	${Split Current URL}	0
	[Return]							${Base URL}.com/

Get User Id By Username
    [Documentation]                     Returns the ID of the user
    [Arguments]                         ${Username}
    @{User List}                        Salesforce Query    User    Username=${Username}
    &{User}                             Get From List       ${User List}    0
    [Return]                            &{User}[Id]

Get Object ID
    [Documentation]                     Get Object ID
    [Arguments]                         ${ObjectName}  ${Value}
    @{ObjectID}						    Salesforce Query  ${ObjectName}  select=Id  Name=${Value}
	&{ObjectID}  			            Get From List	${ObjectID} 	0
	${Obj ID}							Set Variable  	${ObjectID}[Id]
	[Return]                            ${Obj ID}

Get User name
    [Documentation]                     Get User name
    [Arguments]                         ${UserID}
    @{ObjectID}						    Salesforce Query  User  select=Name  Id=${UserID}
	&{ObjectID}  			            Get From List	${ObjectID} 	0
	${Obj Name}							Set Variable  	${ObjectID}[Name]
	[Return]                            ${Obj Name}

Get Recordtype name
    [Documentation]                     Get recordtype name
    [Arguments]                         ${ID}
    @{ObjectID}                         Salesforce Query  RecordType  select=Name  Id=${ID}
    &{ObjectID}                         Get From List    ${ObjectID}     0
    ${Obj Name}                         Set Variable      ${ObjectID}[Name]
    [Return]                            ${Obj Name}

Get Recordtype ID
    [Documentation]                     Get recordtype name
    [Arguments]                         ${name}
    @{ObjectID}                         Salesforce Query  RecordType  select=Id  Name =${name}
    &{ObjectID}                         Get From List    ${ObjectID}     0
    ${Obj Id}                           Set Variable      ${ObjectID}[Id]
    [Return]                            ${Obj Id}

Get Casecomment createdby ID
    [Documentation]                     Get Casecomment createdby ID
    [Arguments]                         ${CaseID}
    @{ObjectID}						    Salesforce Query  CaseComment  select=CreatedById  ParentId=${CaseID}
	&{ObjectID}  			            Get From List	${ObjectID} 	0
	${CreatedById}						Set Variable  	${ObjectID}[CreatedById]
	[Return]                            ${CreatedById}

Go To App
	[Documentation]						Waits for page to fully load.
	...										Then checks if a selected app is already open
	...										If it isn't open, open it.
	[Arguments]							${Selected App}
	Wait Until Page Contains Element  	${App Name}
	# Check if app is already open
	${App Open} =
	...	Run Keyword And Return Status	SeleniumLibrary.Element Text Should Be  ${App Name}		${Selected App}
	Run Keyword Unless    				${App Open}   Select App Launcher App	${Selected App}
	Wait Until Element Contains  		${App Name}		${Selected App}

Go To Tab
	[Documentation]						Redirect to a provided tab.
	...										Specify the Tab API Name and not the label.
	...										Eg: Case_Limited_View
	[Arguments]							${Selected Tab}
	${Base URL}  						Get Base URL
	${Tab URL}							Catenate	SEPARATOR=	${Base URL}		lightning/n/
	...										${Selected Tab}

	# Check if tab is already open
	${Tab Open} =
	...	Run Keyword And Return Status	Title Should Contain  ${Selected Tab}
	Run Keyword Unless    				${Tab Open}   	Go To	${Tab URL}
	Wait For Aura

Scroll To Element
	[Documentation]						Scroll to an element and then scroll an extra 200px to be
	...										sure the footer doesn't cover the element.
    [Arguments]           				${Element}
    Execute Javascript    				window.document.evaluate(
	...										"${Element}", document, null,
	...										XPathResult.FIRST_ORDERED_NODE_TYPE, null)
	...										.singleNodeValue.scrollIntoView(true);
    Execute Javascript    				window.scrollBy(0, -200)

Click Element Using JavaScript Xpath
    [Arguments]                         ${xpath}
    [Documentation]                     Click element using javascript while passing location using xpath
    Execute JavaScript                  document.evaluate('${xpath}',document.body,null,9,null).singleNodeValue.click();

Populate Picklist
	[Documentation]						Populate a selected picklist with a selected value
    [Arguments]							${Name}		${Value}
    ${Picklist}							Replace String	${Generic Picklist}	replaceMe	${Name}
    Wait Until Page Contains Element    ${Picklist}    15
    Scroll Element Into View            ${Picklist}
    Click Element                       ${Picklist}
    Select Picklist Value from dropdown  ${Picklist}  //a[@title="${Value}"]
    Take Screenshot                     Selenium

Populate Popup Picklist
	[Documentation]						Populate a selected popup picklist with a selected value
    [Arguments]							${Name}		${Value}
    ${Picklist}							Replace String	${Generic Picklist Popup}	replaceMe	${Name}
    Wait Until Page Contains Element    ${Picklist}    15
    Scroll Element Into View            ${Picklist}
    Click Element Using JavaScript Xpath  ${Picklist}
    Select Picklist Value from dropdown  ${Picklist}
    ...                                 (//label[contains(text(),'${Name}')]//following::span[text()='${Value}'])[1]
    Take Screenshot                     Selenium

Populate Popup Combobox
	[Documentation]						Populate a selected popup Combobox with a selected value
    [Arguments]							${Name}		${Value}
    ${Picklist}							Replace String	${Generic Picklist Popup}	replaceMe	${Name}
    Wait Until Page Contains Element    ${Picklist}    15
    Scroll Element Into View            ${Picklist}
    Click Element                       ${Picklist}
    Take Screenshot                     Selenium
    Select Picklist Value from dropdown  ${Picklist}  //lightning-base-combobox-item//span[text()='${Value}']
    Take Screenshot                     Selenium

Select Picklist Value from dropdown
	[Documentation]						Select Picklist Value from dropdown
    [Arguments]                         ${XpathofSpan}   ${SelectedValue}
    Wait Until Page Contains Element    ${XpathofSpan}    10
    Wait For Aura
    Wait Until Page Contains Element    ${SelectedValue}
    Scroll Element Into View            ${SelectedValue}
    Click Element                       ${SelectedValue}

Validate field
	[Documentation]						Validate field value
	[Arguments]							${Value1}  ${Value2}
	Wait Until Element is Visible       ${Value1}     40
	SeleniumLibrary.Scroll Element Into View            ${Value1}
	${response}    Get Text             ${Value1}
	Should Be Equal As Strings          ${response}  ${Value2}
	Take Screenshot                     Selenium

Close Multiple tabs
	[Documentation]						Close all open tabs
    Press Keys                          None  keys.SHIFT+W
    Wait For Aura
    ${status}  Run Keyword and Return Status  Wait Until Element is Visible  //button[text()='Close All']  5
    Run Keyword If  '${status}'=='True'  Press Keys  //button[text()='Close All']  \\13
    Wait Until Element is not Visible   //button[text()='Close All']  5

Upload a file
    [Documentation]                     Upload file with xpath and location
    [Arguments]                         ${xpath}  ${Location}  ${Donebtn}
    Choose File                         ${xpath}       ${Location}
    Wait Until Element is Visible       ${Donebtn}    40
    Take Screenshot                     Selenium
    Click Element                       ${Donebtn}
    Wait For Aura
    Take Screenshot                     Selenium

Click button with JS
    [Documentation]                     Replace xpath and click Button using Java Script
    [Arguments]                         ${xpath}  ${Name}
    ${Result}                           Replace String	 ${xpath} 	replace 	${Name}
    Wait Until Element is Visible       ${Result}    40
    Click Element Using JavaScript Xpath  ${Result}
    Wait For Aura

Navigate to AdvancedUserDetails page
    [Documentation]						Navigate to AdvancedUserDetails page and select iframe.
    ${URL}      						Catenate	SEPARATOR=	${Home URL}  lightning/settings/personal/
    ...                                 AdvancedUserDetails/home
    Go To								${URL}
    Wait For Aura
    Wait Until Element is Visible       ${User Frame}
    select frame                        ${User Frame}

Validate User Permissionset
    [Documentation]						Validate available user Permissionsets. logic has two parameters "avail"
    ...                                 and "notavail". "avail" to validate Permissionsets are available.
    ...                                 "notavail" to validate Permissionsets are not available.
    [Arguments]                         ${Permission}  ${logic}
    Navigate to AdvancedUserDetails page
    Scroll Element Into View            //h3[contains(@id,'RelatedSessionPermsetAssignmentList_title')]
    ${rowCount}  SeleniumLibrary.Get Element Count   ${PermissionSet Count}/tr[contains(@class,'dataRow')]/th
    FOR  ${rowIndex}  IN RANGE  1  ${rowCount}+1
    ${curText}  Get Text                ${PermissionSet Count}/tr[contains(@class,'dataRow')][${rowIndex}]/th
    ${status}  Run Keyword and Return Status  Should Be Equal  ${Permission}  ${curText}
    Run Keyword If  '${logic}'=='avail'  Run Keyword If  ${status}  Exit For Loop
    Run Keyword If  '${logic}'=='notavail'  Run Keyword If  '${status}'=='True'  Fail
    END
    Run Keyword If  '${logic}'=='avail'  Run Keyword If  '${status}'=='False'  Fail
    Take Screenshot                     Selenium
    unselect frame

Validate User Public Group Membership
    [Documentation]						Validate available user Public Group Membership. logic has two parameters "avail"
    ...                                 and "notavail". "avail" to validate Public Group Membership are available.
    ...                                 "notavail" to validate Public Group Membership are not available.
    [Arguments]                         ${Permission}  ${logic}
    Navigate to AdvancedUserDetails page
    Scroll Element Into View            //h3[contains(@id,"RelatedQueueMemberList_title")]
    ${rowCount}  SeleniumLibrary.Get Element Count   ${Related PublicGroup}/tr[contains(@class,'dataRow')]/th
    FOR  ${rowIndex}  IN RANGE  1  ${rowCount}+1
    ${curText}  Get Text                ${Related PublicGroup}/tr[contains(@class,'dataRow')][${rowIndex}]/th
    ${status}  Run Keyword and Return Status  Should Be Equal  ${Permission}  ${curText}
    Run Keyword If  '${logic}'=='avail'  Run Keyword If  ${status}  Exit For Loop
    Run Keyword If  '${logic}'=='notavail'  Run Keyword If  '${status}'=='True'  Fail
    END
    Run Keyword If  '${logic}'=='avail'  Run Keyword If  '${status}'=='False'  Fail
    Take Screenshot                     Selenium
    Unselect frame

Validate User Profile
    [Documentation]						Validate User Profile.
    [Arguments]                         ${Name}
    Navigate to AdvancedUserDetails page
    Validate field                      (//a[text()="${Name}"])[1]  ${Name}
    unselect frame

Verify User Role
    [Documentation]						Verify Role of the user
    [Arguments]                         ${role}
    Navigate to AdvancedUserDetails page
    Validate field                      ${svar('user_role')}  ${role}
    Unselect Frame

Get list from query
    [Documentation]                     Get list of values present in field from query
    [Arguments]                         ${Objectname}  ${Field}
    @{records}=                         Salesforce Query  ${Objectname}  select=${Field}
	${ReturnedList}                     Create List
	FOR    ${item}     IN      @{records}
	${Responce}=                        get from dictionary  ${item}  ${Field}
    Append To List                      ${ReturnedList}  ${Responce}
    END
    Log List                            ${ReturnedList}
    Sort List                           ${ReturnedList}
	[Return]                            ${ReturnedList}

Navigate to record Detail Page
    [Documentation]                     Get record ID and navidate to record detail page.
    [Arguments]                         ${Object}  ${Name}
    ${Res} =                            Get Object ID  ${Object}  ${Name}
    Run Keyword And Ignore Error        Go To Record Home  ${Res}
    Wait For Aura
    Take Screenshot                     Selenium

Validate Checkbox
    [Documentation]                     Validate Checkbox state. logic has two parameters "Check" and "UnCheck".
    ...                                 "Check" to validate if Checkbox is checked.
    ...                                 "UnCheck" to validate if Checkbox is unchecked.
    [Arguments]                         ${xpath}  ${logic}
    Run Keyword If  '${logic}'=='Check'  Checkbox Should Be Selected  ${xpath}
    Run Keyword If  '${logic}'=='UnCheck'  Checkbox Should Not Be Selected  ${xpath}
    Take Screenshot                     Selenium

Select from Listbox
    [Documentation]                     Select from listbox
    [Arguments]                         ${FieldName}  ${FieldValue}
    Wait until element is visible       //label[text()="${FieldName}"]/following-sibling::div/descendant::button
    Click Element                       //label[text()="${FieldName}"]/following-sibling::div/descendant::button
    Wait until element is visible       //div[@role='listbox']/descendant::span[text()="${FieldValue}"]
    Click Element                       //div[@role='listbox']/descendant::span[text()="${FieldValue}"]

Replace xpath and Select by Label
    [Documentation]                     Replace xpath and Select by Label
    [Arguments]                         ${xpath}  ${value}  ${value1}
    ${res}      					    Replace String	 ${xpath}	 replace 	${value}
    Wait Until Element Is Visible       ${res}  30s
    select from list by label           ${res}  ${value1}

Replace xpath and Select by Value
    [Documentation]                     Replace xpath and Select by Value
    [Arguments]                         ${xpath}  ${value}  ${value1}
    ${res}      					    Replace String	 ${xpath}	 replace 	${value}
    Wait Until Element Is Visible       ${res}  30s
    Select From List By Value           ${res}  ${value1}

Wait until Locator is Enabled
    [Documentation]                     Wait until Locator is Enabled
    [Arguments]                         ${locator}
    Wait Until Keyword Succeeds         2 min    5 sec  Identify and wait    ${locator}

Identify and wait
    [Documentation]                     Identify and Wait until Locator is Enabled
    [Arguments]                         ${locator}
    Wait Until Element Is Enabled       ${locator}
    Set Focus To Element                ${locator}

Select From Lookup
    [Documentation]                     Select value From Lookup
    [Arguments]                         ${field}  ${Value}
    click element using javascript xpath  (//label[contains(text(),"${field}")]//following::input)[1]
    Input text                          (//label[contains(text(),"${field}")]//following::input)[1]  ${Value}
    Wait for Aura
    click element
    ...  //span[@class="slds-listbox__option-text slds-listbox__option-text_entity"]//lightning-base-combobox-formatted-text

Enter Random data in Long Text area
    [Documentation]                     Enter random text in Long Text area Input field
    [Arguments]                         ${xpath}
    ${Text}                             String.Generate Random String  255
    Input Text                          ${xpath}  ${Text}

Enter Random data in Text area
    [Documentation]                     Enter random text in Text area Input field
    [Arguments]                         ${xpath}
    ${Text}                             String.Generate Random String  10
    Input Text                          ${xpath}  ${Text}

Enter Random EmailID in Text Area
    [Documentation]                     Genereate Random EmailID in Text Area
    [Arguments]                         ${xpath}
    ${String}                           Generate Random String  4  [LOWER]
    ${Text}						        Catenate	SEPARATOR=	${String}  @test.com
    Input Text                          ${xpath}   ${Text}

Enter Random PhoneNo in Text Area
    [Documentation]                     Genereate Random PhoneNo in Text Area
    [Arguments]                         ${xpath}
    ${PhoneNo}                          Generate random string  9  0123456789
    Input Text                          ${xpath}   ${PhoneNo}

Select Date Value
    [Documentation]                     Click on field and Enter Date to the filed with specified Increment Day.
    ...                                 Day argument will take number of day's to increment or decrement
    ...                                 (negative(-) sign can be used for decrement)
    ...                                 Quick formats examples: %a = Mon (First 3 letters of day), %A = Monday,
    ...                                 %d = 24 (Day in numeric), %B = May, %m = 05 (Month in numeric),
    ....                                %Y = 2019, %H:%M:%S - 13:04:09
    [Arguments]                         ${xpath}  ${'Day'}
    Clear Element Text                  ${xpath}
    Click Element                       ${xpath}
    ${date}  Get Current Date           time_zone=local  increment=${'Day'}  result_format=%m/%d/%Y  exclude_millis=True
    input text                          ${Xpath}  ${date}
    Wait For Aura

Navigate to Custom Object
    [Documentation]                     User Navigates project specific Customised object
    [Arguments]                         ${Objname}
    ${Home URL}  						Get Base URL
    ${URL}      						Catenate	SEPARATOR=	${Home URL}  lightning/n/${Objname}
    Go To								${URL}
    Wait For Aura

Replace xpath and click
    [Documentation]                     Replace xpath and click Button
    [Arguments]                         ${xpath}  ${Name}
    ${Result}                           Replace String	 ${xpath} 	replace 	${Name}
    Wait Until Element is Visible       ${Result}    40
    Click Element                       ${Result}
    Wait For Aura

Replace xpath and validate field
    [Documentation]                     Replace xpath and validate field
    [Arguments]                         ${xpath}  ${fieldname}  ${Newvalue}
    ${res}                              Replace String	 ${xpath}  replace  ${fieldname}
    Validate field                      ${res}   ${Newvalue}

Replace xpath and click element using javascript
    [Documentation]                     Replace xpath and click element using javascript xpath
    [Arguments]                         ${xpath}  ${field}
    ${res}                              Replace String	${xpath} 	replace 	${field}
    Wait until element is visible       ${res}
    click element using javascript xpath  ${res}

Replace xpath and Element Is Visible
    [Documentation]                     Replace xpath and Element Is Visible
    [Arguments]                         ${xpath}  ${Name}
    ${res}                              Replace String  ${xpath}   replace   ${Name}
    Wait Until Element Is Visible       ${res}  40s

Replace xpath and Element Is Not Visible
    [Documentation]                     Replace xpath and Element Is Visible
    [Arguments]                         ${xpath}  ${Name}
    ${res}                              Replace String  ${xpath}   replace   ${Name}
    Wait Until Element Is Not Visible   ${res}  40s

Replace xpath and Input Text
    [Documentation]                     Replace Text and Input
    [Arguments]                         ${xpath}  ${value}  ${value1}
    ${res}         					    Replace String	 ${xpath}	 replace 	${value}
    Wait Until Element Is Visible       ${res}
    Input Text                          ${res}  ${value1}
    Wait for Aura

Replace xpath Clear and Input text
    [Documentation]                     Replace xpath Clear available text and Input new text
    [Arguments]                         ${xpath}  ${value}  ${value1}
    ${res}         					    Replace String	 ${xpath}	 replace 	${value}
    clear element text                  ${res}
    input text                          ${res}  ${value1}

Verify Fields available on Layout
    [Documentation]                     Verify all the mentioned fields as available on UI
    [Arguments]                         ${List}
    FOR  ${field}  IN  @{List}
    Page should contain                 ${field}
    END

Replace Xpath and Validate Mandatory fields
    [Documentation]                     Replace Xpath and Validate Mandatory fields
    [Arguments]                         ${xpath}   ${value}   ${value2}
    ${res}      					    Replace String	 ${xpath}	 replace 	${value}
    Wait Until Element Is Visible       ${res}
    Scroll Element Into View            ${res}
	${response}    Get Text             ${res}
	run keyword if                      '${response}'!='${Value2}'  Validate mandatory field  ${res}

Validate mandatory field
	[Documentation]						Validate mandatory field
	[Arguments]                         ${xpath}
	${response}    Get Text             ${xpath}
	${response1}      					Get Substring	 ${response}	 0  1
	Should Be Equal As Strings          ${response1}  *
	Take Screenshot                     Selenium

Press Tab
    [Documentation]                     Simulate clicking Tab key x number of times
    [Arguments]                         ${count}
    FOR  ${i}      IN RANGE      0      ${count}
    Press Keys                          None     TAB
    Sleep                               .07
    END

Arrow Down
    [Documentation]                     Arrow Down
    [Arguments]                         ${count}
    FOR  ${i}      IN RANGE      0      ${count}
    Press Keys                          None   ARROW_DOWN
    END

Arrow Up
    [Documentation]                     Simulate clicking ARROW_UP key x number of times
    [Arguments]                         ${count}
    FOR  ${i}      IN RANGE      0      ${count}
    Press Keys                          None   ARROW_UP
    Sleep                               .07
    END

Arrow Right
    [Documentation]                     Simulate clicking ARROW_RIGHT key x number of times
    [Arguments]                         ${count}
    FOR  ${i}      IN RANGE      0      ${count}
    Press Keys                          None   ARROW_RIGHT
    Sleep                               .07
    END

Arrow Left
    [Documentation]                     Simulate clicking ARROW_LEFT key x number of times
    [Arguments]                         ${count}
    FOR  ${i}      IN RANGE      0      ${count}
    Press Keys                          None   ARROW_LEFT
    Sleep                               .07
    END

Page Down
    [Documentation]                     Page Down
    [Arguments]                         ${count}
    FOR  ${i}      IN RANGE      0      ${count}
    Press Keys                          None   PAGE_DOWN
    Sleep                               .07
    END

