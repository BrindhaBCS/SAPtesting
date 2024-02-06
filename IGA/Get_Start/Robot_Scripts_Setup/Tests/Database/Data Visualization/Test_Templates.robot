*** Settings ***
Documentation     Tests for SFE apps
Resource          Support_DvQ.robot

*** Keywords ***
Qlik and Redshift Data Comparison
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	When The Qlik data is exported  ${area}
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	
Qlik and Redshift Data Comparison with Euro currency filter applied
	[Arguments]    	${user}  ${area}    ${qlik_url}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	And The currency to filter with Euro selection is applied
	When The Qlik data is exported  ${area}
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data

Qlik and Redshift Data Comparison with Sales Rep filter applied
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	And The sales rep filter with ${qvar('sales_rep_team')} selection is applied
	When The Qlik data is exported  ${area}
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data

Qlik and Redshift Data Comparison with chart switch and currency filter
    [Arguments]    	${user}    ${area}    ${qlik_url}    ${chart_options}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	And The currency to filter with Euro selection is applied
	And The chart type is switched to the alternative option  ${chart_options}
	When The Qlik data is exported  ${area}
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	
Qlik and Redshift Data Comparison with chart switch
    [Arguments]    	${user}    ${area}    ${qlik_url}    ${chart_options}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	And The chart type is switched to the alternative option  ${chart_options}
	When The Qlik data is exported  ${area}
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data

Qlik and Redshift Data Comparison with zero records removed
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	When The Qlik data is exported  ${area}
	And Remove zero values from file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data

Qlik and Redshift Data Comparison with Euro currency filter applied and zero records removed
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	And The currency to filter with Euro selection is applied
	When The Qlik data is exported  ${area}
	And Remove zero values from file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data

Qlik and Redshift Data Comparison with invalid percentage records removed
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	When The Qlik data is exported  ${area}
	And Remove invalid percentage values from file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data

Qlik and Redshift Data Comparison with chart switch and invalid percentage records removed
    [Arguments]    	${user}    ${area}    ${qlik_url}    ${chart_options}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	And The chart type is switched to the alternative option  ${chart_options}
	When The Qlik data is exported  ${area}
	And Remove invalid percentage values from file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data

Qlik and Redshift Data Comparison with Euro currency filter applied and invalid percentage records removed
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	And The currency to filter with Euro selection is applied
	When The Qlik data is exported  ${area}
	And Remove invalid percentage values from file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data

Qlik and Redshift Data Comparison with chart switch and zero records removed
    [Arguments]    	${user}    ${area}    ${qlik_url}    ${chart_options}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	And The currency to filter with Euro selection is applied
	And The chart type is switched to the alternative option  ${chart_options}
	When The Qlik data is exported  ${area}
	And Remove zero values from file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	
Qlik and Redshift Data Comparison with chart switch and Euro currency filter applied and invalid percentage records removed
    [Arguments]    	${user}    ${area}    ${qlik_url}    ${chart_options}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	And The currency to filter with Euro selection is applied
	And The chart type is switched to the alternative option  ${chart_options}
	When The Qlik data is exported  ${area}
	And Remove invalid percentage values from file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data

Qlik and Redshift Data Comparison for Sales by Account, Platform, Product With Variable Button sheet
    [Arguments]    	${user}    ${area}    ${qlik_url}    ${chart_selections}
	Given The Qlik sheet is opened  ${user}  ${qlik_url}
	And The currency to filter with Euro selection is applied
	And The chart options are selected  ${chart_selections}
	When The Qlik data is exported  ${area}
	And Check if modifications need to be applied to the data sets e.g. remove zero values  ${chart_selections}
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	
Qlik and Redshift Data Comparison with selected VIEWAS user
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened with the VIEWAS user selected  ${user}  ${qlik_url}
	When The Qlik data is exported  ${area}
	And Process management dashboard qlik file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	
Qlik and Redshift Data Comparison with selected VIEWAS user removed
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened with the VIEWAS user selected  ${user}  ${qlik_url}
	And The viewas filter is removed
	When The Qlik data is exported  ${area}
	And Process management dashboard qlik file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	
Qlik and Redshift Data Comparison for management dashboard team calls contributions
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened with the VIEWAS user selected  ${user}  ${qlik_url}
	And The segment type filter with Specialty selection is applied
	And The segmentation_category filter with Electro-Physiology selection is applied
	When The Qlik data is exported  ${area}
	And Process management dashboard qlik file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	
Qlik and Redshift Data Comparison for management dashboard team focus on tier accounts
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened with the VIEWAS user selected  ${user}  ${qlik_url}
	And The segment type filter with One MD selection is applied
	When The Qlik data is exported  ${area}
	And Process management dashboard qlik file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	
Qlik and Redshift Data Comparison for management dashboard calls focus
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened with the VIEWAS user selected  ${user}  ${qlik_url}
	And The call type filter with Sales selection is applied
	When The Qlik data is exported  ${area}
	And Process management dashboard qlik file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	
Qlik and Redshift Data Comparison for management dashboard accounts visited
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened    ${user}  ${qlik_url}
	And The Qlik sheet is opened with the VIEWAS user selected  ${user}  ${qlik_url}
	And The segment type filter with Specialty selection is applied
	When The Qlik data is exported  ${area}
	And Process management dashboard qlik file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	
Qlik and Redshift Data Comparison for management dashboard accounts not visited
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened with the VIEWAS user selected  ${user}  ${qlik_url}
	And The currency to filter with Euro selection is applied
	When The Qlik data is exported  ${area}
	And Process management dashboard qlik file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	
Qlik and Redshift Data Comparison for management dashboard accounts not visited and VIEWAS user removed
    [Arguments]    	${user}    ${area}    ${qlik_url}
	Given The Qlik sheet is opened with the VIEWAS user selected  ${user}  ${qlik_url}
	And The viewas filter is removed
	And The currency to filter with Euro selection is applied
	When The Qlik data is exported  ${area}
	And Process management dashboard qlik file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	
Qlik and Redshift Data Comparison for management dashboard accounts not visited and SAUSER selected
    [Arguments]    	${user}    ${area}    ${qlik_url}
    Given The Qlik sheet is opened with the VIEWAS user selected  ${user}  ${qlik_url}
	And The viewas filter is removed
	And the SAUSER filter with EU\\\\NTAPADAS selection is applied
	And The currency to filter with Euro selection is applied
	When The Qlik data is exported  ${area}
	And Process management dashboard qlik file  ${OUTPUT DIR}${/}${qvar('pre_processed_dir')}${/}Qlik ${TEST NAME}.xlsx
	And The datawarehouse query is executed  ${area}
	Then The comparison results in excel indicate matching data
	