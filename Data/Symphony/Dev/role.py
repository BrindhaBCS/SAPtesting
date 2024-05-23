# Nike_SAP = "$Nike_SAP"
# Nike_connection = "$Nike_connection"
# CFG_CLIENT_role = "$CFG_CLIENT_role"
# CFG_USER_role = "$CFG_USER_role"
# user_names = ["ssach8",]
# Test_role_assign = ["Z_BNWVS_ADMIN_CHANGE", "Z_BNWVS_ADMIN_CONTROL", "Z_BNWVS_ADMIN_DISPLAY", "Z_BNWVS_BATCHUSER", ]

Nike_SAP = "$Nike_SAP"
Nike_connection = "$Nike_connection"
CFG_CLIENT_role = "100"
CFG_USER_role = "ssach8"


user_names = ["splunktest",]
Test_role_assign = ["Z_BNWVS_ADMIN_CHANGE","Z_BNWVS_ADMIN_CONTROL","Z_BNWVS_ADMIN_DISPLAY",]


uploading_path = "D:\\RobotFramework\\SAPtesting\\Tests\\Resource\\Roles"
upload_role_names = ["Z_BNWVS_ADMIN_CHANGweE","Z_BNWVS_ADMIN_CONTROL","Z_BNWVS_ADMIN_DISPLAY","Z_BNWVS_BATCHUSER",]
uploading_file_names = [role_name + ".SAP" for role_name in upload_role_names]


Delete_role_names = ["Z_BNWVS_ADMIN_CHANGE", "Z_BNWVS_ADMIN_CONTROL", "Z_BNWVS_ADMIN_DISPLAY", ]

