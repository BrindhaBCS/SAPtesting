# Project: <ProjectName> Robot Framework Version: <Version_Number>

To start with automation.

# Pre-requisite

1. Install Python v3.x
2. Install Git

# Create Virtual environment

From cmd prompt CD to Project directory location

## On Windows

```
python -m pip3 install --upgrade pip
pip3 install virtualenv
mkdir Virtualenv
cd Virtualenv
virtualenv <ProjectName>
<ProjectName>\Scripts\activate.bat
cd ..
pip3 install -r dependencies\requirements.txt
Virtualenv\<ProjectName>\Scripts\deactivate.bat
```

## On Linux/Mac

```
python3 -m pip3 install --upgrade pip
pip3 install virtualenv
mkdir Virtualenv
cd Virtualenv
virtualenv <ProjectName>
<ProjectName>/bin/activate
cd ..
pip3 install -r dependencies/requirements.txt    #(should include robotframework==4.1.3 and dependencies)
Virtualenv/<ProjectName>/bin/deactivate
```

# Execute tests

From cmd prompt CD to Project directory location

```
python Execution/driver.py --dryrun
```

# Setup cumulusci.yaml file

##From cmd prompt CD to Project directory location.
###To generate the cumulusci.yaml file execute the command below
only once. The result might be a failure but will generate a
cumulusci.yaml file required for generating connected app for salesforce

```
python Execution/driver.py -i helloworld --salesforce
```

# Ensure cumulusci.yaml added to .gitignore

In the project space at highest level .gitignore file ensure
it has added \*\*/cumulusci.yaml in that file.

#SALESFORCE

# Prequisite for Salesforce test execution (need to first connect to a target Salesforce org):

1. Determine the client_id (Consumer Key) and the client_secret (Consumer Secret) for the target org (once off action per org):
   a. Log in manually to the Salesforce org
   b. Go to Setup-> Apps-> App Manager
   c. Select the connected app for Cumulusci and click View from the dropdown on the right (If it doesn't exist, first create one as per f. below)
   d. Retrieve both the Consumer Key and Consumer Secret
   e. On the command line issue the following command to configure the Connected App as a service (once off action per org):

```
cci service connect connected_app

login_url (Default Salesforce Login URL to be used with this Connected App) https://login.salesforce.com: https://test.salesforce.com

callback_url (Callback URL configured on the Connected App) http://localhost:8080/callback: http://localhost:8080/callback

client_id (Client ID/Consumer Key from the Connected App):

client_secret (Client Secret/Consumer Secret from the Connected App):

There is already a connected_app:default service. Do you want to overwrite it? [y/N]: y

A default service already exists for service type connected_app. Would you like to set this service as the new default? [y/N]: y

Service connected_app:default is now connected

Service connected_app:default is now the default for service type: connected_app.
```

f. To create a connected app :
Go to Setup-> Apps-> App Manager and click 'New Connected App' button
Enter a unique value for the Name and API Name field
Enter a Contact Email
Check "Enable OAuth Settings"
Set the Callback URL to http://localhost:8080/callback
Enable the scopes: full, refresh_token, and web
Save the Connected App

2.  Connect to the org (or sandbox) and assign an alias (to be repeated once per Sandbox)

```
cci org connect --login-url <Salesforce org/sandbox URL>  <alias for org/sandbox> --default (optional)
```

# Execute tests (Salesforce)

From cmd prompt CD to Salesforce Project directory location.
This location should be git tracked. If it is not execute 'git init'
from terminal or command line in this location.

```
python  <relative path to>Execution/Exact_Files/driver.py  -i <tags to include> --salesforce -co <Connected Org>
```

Other options to be used :
--debug Drops into pdb, the Python debugger, on an exception
--debug-before Drops into the Python debugger right before task start
--debug-after Drops into the Python debugger at task completion
