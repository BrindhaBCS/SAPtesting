Project: <ProjectName> Robot Framework Version: <Version_Number>
==========================================================================================

## How to execute Applitool Script - 
```
In /tests/Web/applitools - 
   Add server_url = <APPLITOOLS_SERVER_URL>
   Add api_key = <APPLITOOLS_PROJECT_API_KEY>  #Go to applitools/users/Teams/My API Key 
In /tests/Web/Tests/Support_Web_Applitools - 
   Set runner parameter to - runner=web_ufg or runner=web 
   Set config = <path for applitools.yaml>
For applitools, please change PyYAML==5.4.0 from 6.0 to the following files 
   Web/dependencies/requirements.txt
   robot_common_requirements.txt
   Get_Start/requirements.txt

For applitools you need to install eye-robotframework==5.4.0 libraries in your Virtual Env.
Add this to Web/dependencies/requirements.txt  
For more info on applitools eyes selenium library, please refer - https://applitools.com/docs/api/robot/robot-configuration-file.html
```