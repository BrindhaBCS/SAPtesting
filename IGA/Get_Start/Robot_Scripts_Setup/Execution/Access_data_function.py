ad_project_data_access_secured = """def get_${area}_data_secured(self, fieldname, secured=True):
        "Gets data for the ${area} field name securely"
        return self.get_data("${area}", fieldname, secured)

    """
        
ad_project_data_access = """def get_${area}_data(self, fieldname, secured=False):
        "Gets data for the ${area} field name"
        return self.get_data("${area}", fieldname, secured)

    """

ad_variable_caller = """${first_char}var = d.get_${area}_data                    """ + \
    """# Access any ${area} data variable
"""
ad_variable_caller_secured = """${first_char}var_secured = d.get_${area}_data_secured      """ +\
    """# Access ${area} data variable without logging
"""

ad_import_call = """import Data.${area} as ${area}
"""

# Libraries to add
ad_selenium_lib = """Library           SeleniumLibrary
Library           Screenshot
Library           ../Library/BrowserSupport.py
"""

ad_appium_lib = """Library           AppiumLibrary  timeout=60
"""
common_libs = """Library           OperatingSystem
Library           String
Library           Process
Library           Collections"""

ad_library_files = "Library              ../Library/"
ad_newline = """
"""
ad_resource_file = "Resource          $area/Support_$area.robot"

ad_api_lib = """Library           RequestsLibrary
Library           json
"""
ad_db_lib = """Library           ../Library/RedShiftDBLib.py
Library           ../Library/AzureDBLib.py
Library           ../Library/OrmSupport.py
Library           DatabaseLibrary"""
