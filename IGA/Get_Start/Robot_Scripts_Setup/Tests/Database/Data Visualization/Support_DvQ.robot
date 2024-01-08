*** Settings ***
Documentation     Support the DWH against Qlik processing keywords. This is for reference only.
...    New project needs to build similar support functionality using these.

*** Keywords ***
The Qlik sheet is opened
	[Arguments]  ${user}  ${qlik_url}
	Set up results directory for test case
	Open Qlik sheet ${qlik_url} for user ${user}
	Close unexpected popup message if it appears
	Capture Page Screenshot		${TEST NAME}-access-{index}.png
	
Open Qlik sheet ${qlik_url} for user ${user}
	Run keyword unless  '${user}'=='${current_user}'  Reopen browser for new user  ${user}
    ${sameURL}=  Run keyword and return status  Location should be  ${qvar('${qlik_url}')}
	Run keyword unless  ${sameURL}  Navigate to url  ${qvar('${qlik_url}')}
	Log into the qlik site  ${current_user}
	Wait until page loading has completed
	
Close unexpected popup message if it appears
	${closeButtonPresent}=   Run keyword and return status
	...  Element should be visible  xpath=//button[.//text() = 'Close']
	Run keyword if  ${closeButtonPresent}  Log  Unexpected pop-up window appeared  WARN
	Run keyword if  ${closeButtonPresent}  Capture Page Screenshot		${TEST NAME}-access-{index}.png
	Run keyword if  ${closeButtonPresent}  Click button  //button[.//text() = 'Close']

Set up results directory for test case
	${appname}=  Get test app name
	${sheetname}=  Get test sheet name
	${chartname}=  Get test chart name
	${resultsFolder}=  Set variable
	...  ${OUTPUT DIR}${/}${qvar('comparison_results_dir')}${/}${appname}${/}${sheetname}${/}${chartname}
	Set global variable  ${resultsFolder}
	Create directory  ${resultsFolder}
	
Reopen browser for new user
    [Arguments]  ${user}
    Close all browsers
    ${current_user}=  Set variable  ${user}
    Set global variable  ${current_user}
    Open browser with required specifications

Wait until page loading has completed
    Check app loading is completed
    Check chart loading is completed

Check app loading is completed
    ${rainElementPresent}=  Run keyword and return status
	...  Wait until page contains element  ${qvar('page_loading_animation')}  ${qvar('short_timeout')}
	Run keyword if  ${rainElementPresent}  Wait until keyword succeeds  ${qvar('page_load_time')}  2s
	...  Page should not contain element  ${qvar('page_loading_animation')}

Check chart loading is completed
    ${cancelElementPresent}=  Run keyword and return status
	...  Wait until page contains element  ${qvar('chart_cancel_animation')}  ${qvar('short_timeout')}
	Run keyword if  ${cancelElementPresent}  Wait until keyword succeeds  ${qvar('page_load_time')}  2s
	...  Page should not contain element  ${qvar('chart_cancel_animation')}
	${cancelButtonPresent}=  Run keyword and return status
	...  Wait until page contains element  ${qvar('chart_cancel_button')}  ${qvar('short_timeout')}
	Run keyword if  ${cancelButtonPresent}  Wait until keyword succeeds  ${qvar('page_load_time')}  2s
	...  Page should not contain element  ${qvar('chart_cancel_button')}
	Wait until element is visible  ${qvar('logged_in_check_xpath')}  ${qvar('long_timeout')}

Open browser with required specifications
    Set up screenshot directory
	${currentUserExists}=   Run keyword and return status  Variable should exist  \${current_user}
    Run keyword unless  ${currentUserExists}  Set default user
    ${browserOpenStatus}=   Run keyword and return status  Variable should exist  \${browserIsOpen}
    Run keyword if  '${browserOpenStatus}'=='False'  Set chrome download preferences and open chrome browser
    Maximize browser window
    
Set default user
    ${current_user}=  Set variable  DEFAULT
    Set global variable  ${current_user}

Wait Until Logged in
	Wait until page contains element  ${qvar('logged_in_check_xpath')}  ${qvar('long_timeout')}

Qlik Login Process for ${user}
	${username}=  Set variable if  '${qvar('${user}')}'=='None'  ${JnJUsername}  ${qvar('${user}')}
	${password}=  Set variable if  '${qvar('${user}')}'=='None'  ${JnJPassword}  ${qvar('PASSWORD')}
	Input Text  ${qvar('jnj_login_username_xpath')}		${username}
	Sleep  ${qvar('load_time')}  #Pause to allow qlik page to catch up
    Input Password  ${qvar('jnj_login_password_xpath')}  ${password}  
    Capture Page Screenshot		${TEST NAME}-access-{index}.png
    Press Key  ${qvar('jnj_login_password_xpath')}  \\13

Log into the qlik site
	[Arguments]  ${user}
	${present}=	Run Keyword and Return Status
	...  Wait Until Element is Visible	${qvar('jnj_login_username_xpath')}	 ${qvar('short_timeout')}
	Run Keyword If	${present}	Qlik Login Process for ${user}

Get Context Menu ${sheet}
    ${sheetName}=  Convert to lowercase  ${sheet}
    ${sheetName}=  Evaluate  '${sheetName}'.replace(' ','_')
	Return from Keyword		${qvar('${sheetName}_context')}

Navigate to ${area} chart
    Wait until chart is displayed
    Display context menu for ${area}

Wait until chart is displayed
    Wait until keyword succeeds  30s  2s  Chart is visible on the screen

Chart is visible on the screen
    ${bodyClassValue}=  Get element attribute  css:body  class
    Should contain  ${bodyClassValue}  qv-sheet-enabled
    ${elementClassValue}=  Get element attribute  xpath=//*[@id="qv-stage-container"]/div  class
    Should not contain  ${elementClassValue}  ng-hide
    Sleep  ${qvar('load_time')}  # Wait in case chart is still loading

Right click on chart ${area}
	${context_menu}=	Run Keyword  Get Context Menu ${area}
	Wait until page contains element  ${context_menu}  ${qvar('long_timeout')}
	Open Context Menu  ${context_menu}

Read excel dataexcelfile into memory
	Open Excel 	excelfile
    Get Sorted Sheet Data		Query1		True	0	8
    
The Qlik data is exported
    [Arguments]    ${area}
	Right click on chart ${area}
	Select Export data menu option
	Click download link if present

Click download link if present
    ${linkPresent}=  Run keyword and return status
    ...  Wait until element is visible  ${qvar('export_link_qlik_chart')}  ${qvar('medium_timeout')}
    Capture Page Screenshot		${TEST NAME}-before_qlik_export-{index}.png
    Run keyword if  ${linkPresent}  Click download link
    Run keyword unless  ${linkPresent}
    ...  Run keyword and ignore error  Click button  ${qvar('export_link_close_button')}
    Run keyword unless  ${linkPresent}  Fail  Qlik chart not available
    Move Most Recent Excel File	${OUTPUT DIR}${/}${qvar('download_dir')}
	...	${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx

Select Export data menu option
    Wait until element is visible  ${qvar('export_data_element')}  ${qvar('long_timeout')}
    Click Element  ${qvar('export_data_element')}
    Sleep  ${qvar('load_time')}  #Wait in case a second 'Export data' element needs to be clicked (not in QA)
    ${exportDataRequired}=  Run keyword and return status
    ...  Wait until element is visible  ${qvar('export_data_element')}  ${qvar('short_timeout')}
	Run keyword if  ${exportDataRequired}  Click Element  ${qvar('export_data_element')}

Click download link
    Click link  ${qvar('export_link_qlik_chart')}
	Wait for file download	${OUTPUT DIR}${/}${qvar('download_dir')}
	...	${qvar('long_timeout')}
	Sleep  ${qvar('load_time')}  #Pause to allow qlik page to catch up
	Click button  ${qvar('export_link_close_button')}
	Capture Page Screenshot		${TEST NAME}.png
	${sourcefile}=  Join path  ${OUTPUT DIR}  ${qvar('screenshot_dir')}  ${TEST NAME}.png
	Move file  ${sourcefile}  ${resultsFolder}

Get SQL query for ${sheet}
    ${sheetName}=  Convert to lowercase  ${sheet}
    ${sheetName}=  Evaluate  '${sheetName}'.replace(' ','_')
	Return From Keyword  ${qvar('${sheetName}_query')}

The period to be checked is selected
    [Arguments]  ${period}
    ${periodLower}=  Convert to lowercase  ${period}
    Sleep  ${qvar('load_time')}  # Need to wait for charts to load
    Wait until page contains element  ${qvar('page_title')}  ${qvar('medium_timeout')}
    ${pageTitle}=  Get page title
    Run keyword if  '${pageTitle}'=='${qvar('month_end_report_pa_title_text')}'
    ...  Select from list by label  ${qvar('month_end_report_pa_period_filter')}  ${period}
    Wait until page loading has completed

Get page title
    ${pageTitle}=  Get text  ${qvar('page_title')}
    [Return]  ${pageTitle}

Check if url needs to be changed
    [Arguments]  ${period}
    ${periodLower}=  Convert to lowercase  ${period}
    ${locationCorrect}=    Location should be  ${qvar('qlik_cca_month_end_${periodLower}')}
    Run keyword unless  ${locationCorrect}  Go to  ${qvar('qlik_cca_month_end_${periodLower}')}
    Run keyword unless  ${locationCorrect}  Wait until page loading has completed

The sales filter type is selected
    [Arguments]  ${s_filter}
    Wait until page contains element  ${qvar('page_title')}  ${qvar('medium_timeout')}
    ${pageTitle}=  Get page title
    Run keyword if  '${pageTitle}'=='${qvar('month_end_report_pa_title_text')}'
    ...  Select from list by label  ${qvar('month_end_report_pa_sales_filter')}  ${s_filter}
    ...  ELSE  Select from list by label  ${qvar('month_end_report_sales_filter')}  ${s_filter}
    Sleep  ${qvar('load_time')}   #Wait for any page changes to update

The ${value} currency is selected on the page
    Wait until page contains element  ${qvar('page_title')}  ${qvar('medium_timeout')}
    ${valueAlreadySelected}=  Run keyword and return status
    ...  Element should contain  ${qvar('filters_selected')}  ${value}
    Run keyword unless  ${valueAlreadySelected}  Select ${value} currency

Select ${value} currency
    Click element  ${qvar('month_end_report_currency_filter')}
    Sleep  ${qvar('load_time')}  # Wait for currency list to become active, otherwise currency xpath won't be found
    Click element  xpath=//*[@title="${value}"]
    Sleep  ${qvar('load_time')}  # Wait for currency to display in filter menu
    Click element  ${qvar('month_end_report_currency_filter')}
    
The ${filtername} filter with ${value} selection is applied
    ${valueAlreadySelected}=  Check whether the required filter ${filtername} is already applied
    Run keyword unless  ${valueAlreadySelected}  Select the ${value} value from ${filtername} filter on the selection page
    Check chart loading is completed
    Capture Page Screenshot		${TEST NAME}-${filtername}_filter-{index}.png

Check whether the required filter ${filtername} is already applied
    Wait until page contains element  ${qvar('selection_tools_button')}  ${qvar('long_timeout')}
	${filtername_adjusted}=    Evaluate    '${filtername}'.replace(' ','_')
    ${valueAlreadySelected}=  Run keyword and return status
    ...  Element should contain  ${qvar('filters_selected')}  ${qvar('${filtername_adjusted}_filter_name')}
    [Return]  ${valueAlreadySelected}
    
The main ${filtername} filter is applied with ${value} selected
	Wait until page contains element  ${qvar('selection_tools_button')}  ${qvar('long_timeout')}
	${filtername_adjusted}=    Evaluate    '${filtername}'.replace(' ','_')
    ${valueAlreadySelected}=  Run keyword and return status
    ...  Element should contain  ${qvar('filters_selected')}  ${qvar('${filtername_adjusted}_filter_name')}
    Run keyword unless  ${valueAlreadySelected}  Find the main ${filtername} filter on the selection page and select the ${value} value
    Check chart loading is completed
    Capture Page Screenshot		${TEST NAME}-${filtername}_filter-{index}.png

Select the ${value} value from ${filtername} filter on the selection page
    Click selection tools button to open filter page
    Wait until element is visible  ${qvar('show_fields_checkbox')}  ${qvar('long_timeout')}
    Sleep  ${qvar('load_time')}  # Wait in case page is still loading
    Click Show fields checkbox
    Input text  ${qvar('search_dimensions_fields_input')}  ${filtername}
    Sleep  ${qvar('load_time')}  # Wait for filter list to become active
    @{valueList}=  Split string  ${value}  ,${SPACE}
    ${items}=  Set variable  ${EMPTY}
    :FOR  ${item}  IN  @{valueList}
    \  ${items}=  Catenate  ${items}  ${item}
    #temporaryFix
    Run Keyword Unless    '${item}'=='Sales'    Click element  ${qvar('filter_search_open')}
    Run Keyword If    '${item}'=='Sales'    Click element  ${qvar('sales_filter')}
    #temporaryFix
    Run Keyword Unless    '${item}'=='Sales'    Input text  ${qvar('filter_search_input')}  ${items}
    Run Keyword If    '${item}'=='Sales'    Input text  ${qvar('sales_input')}  ${items}
    Sleep  ${qvar('load_time')}  # Wait for item to be selected
    :FOR  ${item}  IN  @{valueList}
    \  ${itemPresent}=  Run keyword and return status  Element should be visible  xpath=//*[@title="${item}"]
    \  Run keyword if  ${itemPresent}  Click element  xpath=//*[@title="${item}"]
    \  Run keyword if  ${itemPresent}  Sleep  ${qvar('load_time')}  # Wait for item to be selected
    \  Run keyword unless  ${itemPresent}  Close the selection tools page
    \  Run keyword unless  ${itemPresent}  FAIL  Filter value ${item} not present for selection
    Capture Page Screenshot		${TEST NAME}-${filtername}_filter_selection-{index}.png
    Close the selection tools page
    
Find the main ${filtername} filter on the selection page and select the ${value} value
    Click selection tools button to open filter page
    Wait until element is visible  ${qvar('show_fields_checkbox')}  ${qvar('long_timeout')}
    Sleep  ${qvar('load_time')}  # Wait in case page is still loading
    Input text  ${qvar('search_dimensions_input')}  ${filtername}
    Sleep  ${qvar('load_time')}  # Wait for filter list to become active
    @{valueList}=  Split string  ${value}  ,${SPACE}
    ${items}=  Set variable  ${EMPTY}
    :FOR  ${item}  IN  @{valueList}
    \  ${items}=  Catenate  ${items}  ${item}
    Click element  ${qvar('filter_search_open')}
    Input text  ${qvar('filter_search_input')}  ${items}
    Sleep  ${qvar('load_time')}  # Wait for item to be selected
    :FOR  ${item}  IN  @{valueList}
    \  Click element  xpath=//*[@title="${item}"]
    \  Sleep  ${qvar('load_time')}  # Wait for item to be selected
    Capture Page Screenshot		${TEST NAME}-${filtername}_filter_selection-{index}.png
    Close the selection tools page

I click the Period Analysis button
    Click element  ${qvar('month_end_report_period_analysis_selected')}

Click selection tools button to open filter page
    Wait until element is visible  ${qvar('selection_tools_button')}  ${qvar('long_timeout')}
    Wait until keyword succeeds  10s  2s  Click element  ${qvar('selection_tools_button')}

Close the selection tools page
    Click element  ${qvar('close_selection_tools_button')}

I switch to the Product chart
    ${platformSelected}=  Run keyword and return status  Element should be visible  ${qvar('platform_chart_option')}
    Run keyword if  ${platformSelected}  Select Product from menu option

The chart type is switched to the alternative option
	[Arguments]  ${chart_options}
	${chart_options}=  Split string  ${chart_options}  ,${SPACE}
	${first}=  Set variable  @{chart_options}[0]
	${second}=  Set variable  @{chart_options}[1]
    ${xpath}=  Set variable if  '${first}'=='Calls'  ${qvar('calls_chart_option')}  xpath=//*[@title="${first}"]
    ${firstSelected}=  Run keyword and return status
    ...  Element should be visible  ${xpath}
    Capture Page Screenshot		${TEST NAME}-chart_switch-before-{index}.png
    Run keyword if  ${firstSelected}  Change from ${first} to ${second} menu option
    ...  ELSE  Fail  Could not find switch chart menu
    
The chart is switched from ${first} to ${second}
    ${xpath}=  Set variable if  '${first}'=='Calls'  ${qvar('calls_chart_option')}  xpath=//*[@title="${first}"]
    ${firstSelected}=  Run keyword and return status
    ...  Element should be visible  ${xpath}
    Run keyword if  ${firstSelected}  Change from ${first} to ${second} menu option
    ...  ELSE  Fail  Could not find switch chart menu

Change from ${first} to ${second} menu option
    Run keyword if  '${first}'=='Calls'  Click element  ${qvar('calls_chart_option')}
    ...  ELSE  Click element  xpath=//*[@title="${first}"] 
    Wait until element is visible  ${qvar('menu_dropdown_second_option')}  ${qvar('medium_timeout')}
    ${secondMenuOption}=  Set variable  ${qvar('menu_dropdown_second_option')}
    Sleep  ${qvar('load_time')}  # Wait for item to load fully
    ${secondOptionText}=  Get text  ${secondMenuOption}
    Run keyword if  '${secondOptionText}'==''  Fail  Switch chart menu item not found for selection
    ${secondOptionText}=  Strip string  ${secondOptionText}
    Run keyword if  '${secondOptionText}'=='${second}'
    ...  Click element  ${secondMenuOption}
    Sleep  ${qvar('load_time')}  # Wait for item to be selected
    Check chart loading is completed
    Capture Page Screenshot		${TEST NAME}-chart_switch-after-{index}.png

Remove ${filtername} filter if present
    Wait until page contains element  ${qvar('selection_tools_button')}  ${qvar('long_timeout')}
    ${filtername_adjusted}=  Evaluate    '${filtername}'.replace(' ','_')
    ${filterApplied}=  Run keyword and return status
    ...  Element should contain  ${qvar('filters_selected')}  ${qvar('${filtername_adjusted}_filter_name')}
    Run keyword if  ${filterApplied}  Remove ${filtername} filter selection

Remove ${filtername} filter selection
    ${filtername_adjusted}=    Evaluate    '${filtername}'.replace(' ','_')
    :FOR  ${index}  IN RANGE  1  20
    \  ${filterTextarea}=  Catenate  SEPARATOR= 
    ...  ${qvar('filter_element_xpath_start')}  ${index}  ${qvar('filter_element_xpath_text')}
    \  ${filterClose}=  Catenate  SEPARATOR= 
    ...  ${qvar('filter_element_xpath_start')}  ${index}  ${qvar('filter_element_xpath_close')}
    \  ${filterPresent}=    Run keyword and return status
    ...  Element should be visible  ${filterTextarea}
    \  Exit for loop if  '${filterPresent}'=='False'
    \  ${filterMatch}=  Run keyword and return status
    ...  Element should contain  ${filterTextarea}  ${qvar('${filtername_adjusted}_filter_name')}
    \  Run keyword if  ${filterMatch}  Click element  ${filterClose}
    \  Run keyword if  ${filterMatch}
    ...  Wait until element does not contain  ${qvar('filters_selected')}
    ...  ${qvar('${filtername_adjusted}_filter_name')}  ${qvar('long_timeout')}
    
Click Show fields checkbox
    ${checkBoxClass}=  Get element attribute  xpath=//*[@title="Show fields"]/input  class
    ${checkBoxSelected}=  Run keyword and return status  Should contain  ${checkBoxClass}  ng-not-empty
    Run keyword unless  ${checkBoxSelected}  Click element  ${qvar('show_fields_checkbox')}
    
The chart options are selected
    [Arguments]  ${chart_selections}
    ${chart_list}=  Split string  ${chart_selections}  ,${SPACE}
    :FOR  ${buttonName}  IN  @{chart_list}
    \  Click button  //button[.//text() = '${buttonName}']
    \  Sleep  ${qvar('load_time')}  # Wait for item to be selected
    
Check if modifications need to be applied to the data sets e.g. remove zero values
    [Arguments]  ${chart_selections}
    ${percentChart}=  Run keyword and return status  Should contain  ${chart_selections}  %
    Run keyword if  ${percentChart}
    ...  Remove invalid percentage values from file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
    ...  ELSE
    ...  Remove zero values from file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx 

The Qlik sheet is opened with the VIEWAS user selected
    [Arguments]  ${user}  ${qlik_url}
    ${filterApplied}=  Run keyword and return status
    ...  Element should contain  ${qvar('filters_selected')}  VIEWAS1
    Run keyword if  ${filterApplied}  Set up results directory for test case
    Run keyword unless  ${filterApplied}  The Qlik sheet is opened  ${user}  management_filter_page_url
    Run keyword unless  ${filterApplied}  Select ${qvar('management_viewas_user')} from VIEWAS filter
    Select ${qlik_url} sheet from sheet list
	Wait until page loading has completed
    
Select ${user} from VIEWAS filter
    Click element  xpath=//*[@title="View as"]
    Sleep  ${qvar('load_time')}  # Wait for item to be selected
    ${viewasUser}=  Set variable  ${qvar('management_viewas_user')}
    Set global variable  ${viewasUser}
    Input text  xpath=//input  ${viewasUser}
    Sleep  ${qvar('load_time')}  # Wait for item to be selected
    Click element  xpath=//*[@title="${viewasUser}"]
    Sleep  ${qvar('load_time')}  # Wait for item to be selected
    Click element  xpath=//*[@title="View as"]
    
Select ${sheet} sheet from sheet list
    Click element  xpath=//*[@title="Sheets"]
    Sleep  ${qvar('load_time')}  # Wait for item to be selected
    ${sheet_list_item}=  Catenate  SEPARATOR=  ${qvar('management_sheet_list_start')}
    ...  ${qvar('${sheet}_sheet_number')}  ${qvar('management_sheet_list_end')} 
    Click element  ${sheet_list_item}
    
The ${filtername} filter is removed
    Remove ${filtername} filter if present