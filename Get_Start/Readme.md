# Robot Framework Getting Started Guide

The main robot framework documentation can be found at [Robot Docs](<https://robotdocs.xena.dev>). The following are required when setting up robot framework space on a project:

## Create a new robot framework project space

This section defines steps to take to setup a new robot framework project space using Robot Framework Get Started Guide.

### Pre-Requisites

- Identify the project capabilities. Choose from a combination of Web, Mobile, API, Salesforce and Database
- Identify what project name would be used.
- Install python version 3 on the system.
- Create a virtual environment, activate it and install dependencies using:

```
pip3 install -r Get_Start/requirements.txt
```

### Setup a bitbucket git repo

- A bitbucket repo is created for your project and is cloned on the system.

### Setup a new robot framework space in your cloned project

Identify a space in your cloned bitbucket project where the robot framework files will be added - typically this will be an empty folder in the root of your project.
To setup a new robot framework space one can use the following command.

```
python Get_Start/robot_builder.py -n <Project Name> -t <Project capabilities> -l <Project Location (absolute path)>
```

e.g.

```
python Get_Start/robot_builder.py -n SampleProject -t Web Database -l "C:\Project_Automation"
```

## Effect of creating a new project space

- A project structure is created under the identified project location.
- A virtual environment is created under the project space inside VirtualEnv folder.
  - This folder is not checked in and is added to gitignore to be ignored.
  - When a new user clones this repository they need to setup their own virtual environment and not check that in to the repository.
- Commit and push the code to the bitbucket repository.
- New users will now be able to clone this repository and start working off it following gitflow.
