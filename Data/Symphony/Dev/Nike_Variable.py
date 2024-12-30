SAP_SERVER = "C:\\Program Files\\SAP\\FrontEnd\\SAPGUI\\saplogon.exe"
Client_Id = "001"
User_Name = "SELENIUM"
user_name = "ramyap"
password = "Ramya@95"
SAP_connection = "BIS"
sap_connection = "DEV_PRD"
User_Password = "Test@12345"
excel_path = "C:\\Nike\\SAPtesting\\Tests\\Resource\\User_Role_Assignment.xlsx"
# sheet_basis = "Basis"
# sheet_developer = "Developer"
# sheet_security = "Security"
# sheet_ABAP = "ABAP"
# sheet_finance = "Finance"
GetRoles_sheetname = "Get_Role"
# sheet_name = "Get_Role"

#create_role_variable
tcode = ["SU01", "SU10"]
role_creation_input_value = ["ZS_TEST_NEW_041","ZS_TEST_NEW_042","ZS_TEST_NEW_043","ZS_TEST_NEW_044"]
Description_of_role = "Test and execute"

#download_role
Download_role_names = ["ZS_TEST_new_041", "ZS_TEST_new_042", "ZS_TEST_new_043"]
download_path = "C:\\Users\\BCS267\\Documents\\SAP\\SAP GUI\\"

#delete_role_variable
Delete_role_names = ["ZS_TEST_new_041", "ZS_TEST_new_042", "ZS_TEST_new_043"]

#upload_role
upload_role_names = ["ZS_TEST_new_041", "ZS_TEST_new_042"]
uploading_file_names = [role_name + ".SAP" for role_name in upload_role_names]
uploading_path = "C:\\Users\\BCS267\\Documents\\SAP\\SAP GUI\\"

#su10_Test_role_assign
user_names = ["TEST001", "TEST002", "TEST003"]
Test_role_assign = ["ZS_TEST_NEW_041", "ZS_TEST_NEW_042", "ZS_TEST_NEW_043", "ZS_TEST_NEW_044", ]

#TR_capture
Tr_input_value = ["ZS_TEST_new_041","ZS_TEST_new_042",]
Tr_Tcode_input = ["sm50","pfcg","suim",]
Tr_input_request =  "BISK900182"



