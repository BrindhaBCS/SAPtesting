# from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium import webdriver
import os
import fnmatch
from robot.api.deco import keyword





class ChromeOptions:

    def get_chrome_options(Self, download_dir):
        chrome_options = Options()
        prefs = {
            "download.default_directory": download_dir,
            "download.prompt_for_download": False,
            "download.directory_upgrade": True,
            "safebrowsing.enabled": True
        }
        chrome_options.add_experimental_option("prefs", prefs)
        return chrome_options
    
    
    
    def Verify_the_support_packages(self, start_str, end_str, folder_path):
        try:
            # Extract numbers from the start and end strings
            start_num = int(start_str.split('-')[1].split('INSTPI')[0])
            end_num = int(end_str.split('-')[1].split('INSTPI')[0])
        except (IndexError, ValueError) as e:
            print(f"Error parsing version numbers: {e}")
            return []

        # Generate expected file names
        expected_files = [f'K-{i:05d}INSTPI.SAR' for i in range(start_num, end_num + 1)]
        print(f"Expected files: {expected_files}")

        # List files in the folder
        try:
            files_in_folder = os.listdir(folder_path)
        except FileNotFoundError as e:
            print(f"Error accessing folder: {e}")
            return []
        
        # Identify missing files
        missing_files = [file for file in expected_files if file not in files_in_folder]
        print(f"Missing files: {missing_files}")

        return missing_files

if __name__ == "__main__":
    folder_path = "C:\\SAP_Robot\\SAPtesting\\Tests\\Resource\\Patch_Packages"
    start_str = "K-74004INSTPI.SAR"
    end_str = "K-74027INSTPI.SAR"
    verifyfiles = ChromeOptions()
    missing_files = verifyfiles.Verify_the_support_packages(start_str, end_str, folder_path)
    if missing_files:
        print(f"Missing files: {missing_files}")
    else:
        print("All expected files are present.")
   
    # my_library.py
    

    

    