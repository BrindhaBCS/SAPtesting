SAP_SERVER = "$SAP_SERVER"
Client_Id = "$Client_Id"
User_Name = "$User_Name"
SAP_connection = "$SAP_connection"

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



