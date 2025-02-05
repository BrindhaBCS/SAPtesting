*** Settings ***
Library    Process
Library    SAP_Tcode_Library.py
Library    OperatingSystem

*** Variables ***
${se16_filepath}      c:\\tmp\\SE16_Users.xlsx
${se16_filepath_cleaned}      c:\\tmp\\SE16_Users_Cleaned.xlsx
${table_auth_filepath}      c:\\tmp\\Table_Authorization_Group_Users.xlsx
${table_auth_filepath_cleaned}      c:\\tmp\\Table_Authorization_Group_Users_Cleaned.xlsx
${control_SAP_filepath}      c:\\tmp\\Control SAP standard users.xlsx
${control_SAP_filepath_cleaned}      c:\\tmp\\Control SAP standard users_Cleaned.xlsx
${auth_profiles_filepath}      c:\\tmp\\Authorization Profiles.xlsx
${auth_profiles_filepath_cleaned}      c:\\tmp\\Authorization Profiles_Cleaned.xlsx
${exempted_users_file}      c:\\tmp\\MCR_Exempted_Users.xlsx
${output_file}      c:\\tmp\\Extra_Users_List.xlsx


*** Keywords ***

Generate report
    Files Clean Username    ${se16_filepath}    ${se16_filepath_cleaned}
    Files Clean Username    ${table_auth_filepath}    ${table_auth_filepath_cleaned}    
    Files Clean User    ${control_SAP_filepath}    ${control_SAP_filepath_cleaned}    
    Files Clean Username    ${auth_profiles_filepath}    ${auth_profiles_filepath_cleaned}
    Generate Extra Users List    ${se16_filepath_cleaned}    ${table_auth_filepath_cleaned}    ${control_SAP_filepath_cleaned}    ${auth_profiles_filepath_cleaned}    ${exempted_users_file}    ${output_file} 
    Sleep    2
    Generate Word    ${symvar('MCR_excel_directory')}    ${symvar('MCR_Resized_Images_directory')}    C:\\tmp\\MCR_OUTPT_DEMO
    Sleep    2