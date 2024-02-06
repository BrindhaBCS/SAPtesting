Project: Sap_Testing Robot Framework Version: 1.5.0
==========================================================================================

To start with automation.
# Pre-requisite

1. Install Python v3.x
2. Install Git
3. Pull latest code from https://sourcecode.jnj.com/scm/asx-ncoh/robot_framework.git

# Build robot framework folder for your project on your local machine

Use the robot_builder.py script to build a new robot framework folder structure for your project. The steps to follow are specified in the 'Build in local OS environment' tab in https://sourcecode.jnj.com/pages/ASX-NCOH/robot_framework/browse/docs/#/user_guide/get_start/rf_quick_start_guide?id=building-your-framework.

1. Create an empty folder in your project to hold the new robot framework content
2. Run the following commands in a terminal:
    - pip3 install -r Get_Start/requirements.txt
    - python Get_Start/robot_builder.py -n <Name of Project> -t <Type of project, e.g Web Database> -l <Absolute path of newly created robot framework folder>
3. Start building robot framework tests using the sample tests as a guide for format and structure.

# Create Virtual environment

The robot_builder.py script above creates a virtual environment in your robot framework folder by default, but if you want to manually create a virtual env, the steps are below. This process assumes you have a dependencies/requirements.txt file containing the packages required for your tests.

From cmd prompt, CD to Project directory location

## On Windows

```cmd
python -m pip install --upgrade pip
pip install virtualenv
mkdir Virtualenv
cd Virtualenv
virtualenv Sap_Testing
Sap_Testing\Scripts\activate.bat
cd ..
pip install -r dependencies\requirements.txt
Virtualenv\Sap_Testing\Scripts\deactivate.bat
```

## On Linux/Mac

```cmd
python3 -m pip install --upgrade pip
pip install virtualenv
mkdir Virtualenv
cd Virtualenv
virtualenv Sap_Testing
Sap_Testing/bin/activate
cd ..
pip install -r dependencies/requirements.txt #(should include robotframework==4.1.3 and dependencies)
Virtualenv/Sap_Testing/bin/deactivate
```

# Executing  tests
From cmd prompt CD to Project directory location and execute the driver.py script, e.g.

```cmd
python Execution/driver.py -i regression
```

# How to migrate from Robot Framework version 1.0 to version 1.5

If you have an existing robot framework folder built using release version 1.0, follow these steps to obtain the latest release code:

1. Pull the latest code from robot framework repo at https://sourcecode.jnj.com/scm/asx-ncoh/robot_framework.git.
2. Create an empty folder in your project to hold the new robot framework content
3. Use the robot_builder.py script to build a new robot framework folder structure for your project. The commands to execute in a terminal as follows:
    - pip3 install -r Get_Start/requirements.txt
    - python Get_Start/robot_builder.py -n <Name of Project> -t <Type of project, e.g Web Database> -l <Absolute path of newly created robot framework folder>
4. Copy and paste the test files from your old robot framework folder to the new one.
5. Copy and paste the data files from your old robot framework folder to the new one.
6. If any project specific package dependency, that also need to be added in requirement.txt file (under "dependencies" folder) 
7. If any project specific custom library present in "Library" folder that also need to be added in "Library" folder for newly created project space. 
8. If you wish to execute your tests in a JPM pipeline and your project is not already setup to do so, the folder/files in the JPM_Template folder can be copied to the top-level of the project folder and the files updated with your project specific details (i.e. Jenkins team key, manifest configuration, etc). Please refer to the below mentioned links for more details on how to configure the files:
    - JPM Quick Start Guide](https://sourcecode.jnj.com/pages/ASX-NAGH/jpm_shared_lib/develop/browse/docs/#/user-guide/jpm-quick-start-guide?id=jpm-quick-start-user-guide)
    - [XENA Training Course 140](https://sourcecode.jnj.com/pages/asx-xena/xena-training/main/browse/docs/#/140-Creating-JPM-Pipeline
9. The docker image used for regressionTest/integrationTest stages in JPM manifest will be `jnj.artifactrepo.jnj.com/robot/execution:latest` by default. The release 1.0 docker image is now deprecated, but can be used to override the default image by passing regressionTest.overridingProperties.dockerImage parameter as `jnj.artifactrepo.jnj.com/robot/execution:stable`.
