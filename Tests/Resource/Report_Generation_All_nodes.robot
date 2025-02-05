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
 
${sap_query_filepath}      c:\\tmp\\SAP_QUERY.xlsx
${sap_query_filepath_cleaned}      c:\\tmp\\SAP_QUERY_Cleaned.xlsx
 
${start_programs_filepath}      c:\\tmp\\START_PROGRAMS.xlsx
${start_programs_filepath_cleaned}      c:\\tmp\\START_PROGRAMS_Cleaned.xlsx
 
${maint_workflow_filepath}      c:\\tmp\\Maintenance Workflow.xlsx
${maint_workflow_filepath_cleaned}      c:\\tmp\\Maintenance Workflow_Cleaned.xlsx
 
${access_password_filepath}      c:\\tmp\\Access password.xlsx
${access_password_filepath_cleaned}      c:\\tmp\\Access password_Cleaned.xlsx
 
${user_control_gebru_filepath}      c:\\tmp\\Usercontrol gebruikers met User Maintenance.xlsx
${user_control_gebru_filepath_cleaned}      c:\\tmp\\Maintenance Workflow_Cleaned.xlsx
 
${Usercontrol gebruikers_filepath}      c:\\tmp\\Usercontrol gebruikers met User Maintenance.xlsx
${Usercontrol gebruikers_filepath_cleaned}      c:\\tmp\\Usercontrol gebruikers met User Maintenance_Cleaned.xlsx
 
${user_control_gebru_filepath}      c:\\tmp\\Usercontrol gebruikers met User Maintenance.xlsx
${user_control_gebru_filepath_cleaned}      c:\\tmp\\Maintenance Workflow_Cleaned.xlsx
 
${control_access_filepath}      c:\\tmp\\Control Access.xlsx
${control_access_filepath_cleaned}      c:\\tmp\\Control Access_Cleaned.xlsx
 
${release_debug_filepath}      c:\\tmp\\Release Debug.xlsx
${release_debug_filepath_cleaned}      c:\\tmp\\Release Debug_Cleaned.xlsx
 
${delete_audit_filepath}      c:\\tmp\\Deleteaudit.xlsx
${delete_audit_filepath_cleaned}      c:\\tmp\\Deleteaudit_Cleaned.xlsx
 
${control_booking_filepath}      c:\\tmp\\Control Booking.xlsx
${control_booking_filepath_cleaned}      c:\\tmp\\Control Booking_Cleaned.xlsx
 
${Mandantonderhoud_filepath}      c:\\tmp\\Mandantonderhoud.xlsx
${Mandantonderhoud_filepath_cleaned}      c:\\tmp\\Mandantonderhoud_Cleaned.xlsx
 
${table_maintenace_filepath}      c:\\tmp\\Table maintenance without restrictions.xlsx
${table_maintenace_filepath_cleaned}      c:\\tmp\\Table maintenance without restrictions_Cleaned.xlsx
 
${sap_profiles_filepath}      c:\\tmp\\SAP_Profiles.xlsx
${sap_profiles_filepath_cleaned}      c:\\tmp\\SAP_Profiles_Cleaned.xlsx
 
${user_accounts_filepath}      c:\\tmp\\User_Accounts.xlsx
${user_accounts_filepath_cleaned}      c:\\tmp\\User_Accounts_Cleaned.xlsx
 
${Access_to_transport_taking_into_production}    C:\\tmp\\Users_By_Complex_Selection.xlsx
${Access_to_transport_taking_into_production_cleaned}    C:\\tmp\\Users_By_Complex_Selection_Cleaned.xlsx
 
${license_checking}    C:\\tmp\\Licensed_User.xlsx    
${license_checking_cleaned}    C:\\tmp\\Licensed_User_Cleaned.xlsx
 
${production_systems_open_via_OSS}    C:\\tmp\\SAP_Support_Users.xlsx    
${production_systems_open_via_OSS_cleaned}    C:\\tmp\\SAP_Support_Users_Cleaned.xlsx
 
${Transportstraat_Management}    C:\\tmp\\Transportstraat_Users.xlsx
${Transportstraat_Management_cleaned}    C:\\tmp\\Transportstraat_Users_Cleaned.xlsx
 
${Table_view_without_restrictions}    C:\\tmp\\Table_Authorization_Group_Users.xlsx
${Table_view_without_restrictions_cleaned}    C:\\tmp\\Table_Authorization_Group_Users_Cleaned.xlsx
 
${Check_System_Parameters_Transaction_SA38}    C:\\tmp\\SA38.xlsx    
${Check_System_Parameters_Transaction_SA38_cleaned}    C:\\tmp\\SA38_Cleaned.xlsx
 
${ControlInactive_Users}    C:\\tmp\\SE16.xlsx
${ControlInactive_Users_cleaned}    C:\\tmp\\SE16_Cleaned.xlsx
 
${Access_Batch_Job_Management}    C:\\tmp\\Req7_users_filter.xlsx
${Access_Batch_Job_Management_cleaned}    C:\\tmp\\Req7_users_filter_Cleaned.xlsx
 
${Control_SAP_developers}    C:\\tmp\\Control SAP developers.xlsx    
${Control_SAP_developers_cleaned}    C:\\tmp\\Control SAP developers_Cleaned.xlsx
 
${exempted_users_file}      c:\\tmp\\MCR_Exempted_Users.xlsx
${output_file}      c:\\tmp\\Extra_Users_List.xlsx
${FILE1}        C:\\tmp\\Control SAP standard users.xlsx
 
${file_list_path}    c:\\tmp\\file_list_path.txt
 
*** Keywords ***
 
Generate report
    Files Clean Username    ${se16_filepath}    ${se16_filepath_cleaned}
    Files Clean Username    ${table_auth_filepath}    ${table_auth_filepath_cleaned}    
    Files Clean User    ${control_SAP_filepath}    ${control_SAP_filepath_cleaned}    
    Files Clean Username    ${auth_profiles_filepath}    ${auth_profiles_filepath_cleaned}
    Generate Extra Users List    ${se16_filepath_cleaned}    ${table_auth_filepath_cleaned}    ${control_SAP_filepath_cleaned}    ${auth_profiles_filepath_cleaned}    ${exempted_users_file}    ${output_file}
    Sleep    4
    Generate Word    ${symvar('MCR_excel_directory')}    ${symvar('MCR_Resized_Images_directory')}    "C:\\tmp\\MCR_OUTPT_DEMO"
    Sleep    2
   
Generate report All Nodes
    Files Clean Username    ${se16_filepath}    ${se16_filepath_cleaned}
    Files Clean Username    ${table_auth_filepath}    ${table_auth_filepath_cleaned}    
    Files Clean User    ${control_SAP_filepath}    ${control_SAP_filepath_cleaned}    
    Files Clean Username    ${auth_profiles_filepath}    ${auth_profiles_filepath_cleaned}
    Files Clean Username Cleaned    ${sap_query_filepath}    ${sap_query_filepath_cleaned}
    Files Clean Username    ${start_programs_filepath}    ${start_programs_filepath_cleaned}    
    Files Clean Username    ${maint_workflow_filepath}    ${maint_workflow_filepath_cleaned}    
    Files Clean Username    ${access_password_filepath}    ${access_password_filepath_cleaned}    
    Files Clean Username    ${user_control_gebru_filepath}    ${user_control_gebru_filepath_cleaned}    
    Files Clean Username    ${Usercontrol gebruikers_filepath}    ${Usercontrol gebruikers_filepath_cleaned}    
    Files Clean Username    ${control_access_filepath}    ${control_access_filepath_cleaned}    
    Files Clean Username    ${release_debug_filepath}    ${release_debug_filepath_cleaned}    
    Files Clean Username    ${delete_audit_filepath}    ${delete_audit_filepath_cleaned}    
    Files Clean Username    ${control_booking_filepath}    ${control_booking_filepath_cleaned}    
    Files Clean Username    ${Mandantonderhoud_filepath}    ${Mandantonderhoud_filepath_cleaned}    
    Files Clean Username    ${table_maintenace_filepath}    ${table_maintenace_filepath_cleaned}    
    Files Clean User    ${sap_profiles_filepath}    ${sap_profiles_filepath_cleaned}    
    Files Clean User    ${user_accounts_filepath}    ${user_accounts_filepath_cleaned}    
    Files Clean Username    ${Access_to_transport_taking_into_production}    ${Access_to_transport_taking_into_production_cleaned}    
    Files Clean Username    ${license_checking}    ${license_checking_cleaned}    
    Files Clean User    ${production_systems_open_via_OSS}    ${production_systems_open_via_OSS_cleaned}    
    Files Clean Username    ${Transportstraat_Management}    ${Transportstraat_Management_cleaned}    
    Files Clean Username    ${Table_view_without_restrictions}    ${Table_view_without_restrictions_cleaned}    
    # Files Clean Username    ${Check_System_Parameters_Transaction_SA38}    ${Check_System_Parameters_Transaction_SA38_cleaned}    
    Files Clean BNAME    ${ControlInactive_Users}    ${ControlInactive_Users_cleaned}    
    Files Clean Username Cleaned    ${Access_Batch_Job_Management}    ${Access_Batch_Job_Management_cleaned}    
    Files Clean UNAME    ${Control_SAP_developers}    ${Control_SAP_developers_cleaned}    
    Generate Extra Users List All Nodes    ${file_list_path}    ${exempted_users_file}    ${output_file}



 
   
 