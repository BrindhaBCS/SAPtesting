XRay Uploader Workflow
======================

**Important Notice**:

The current release utilizes updates from robot framework version 4.x. Please install and use this version for local test executions, especially if you plan to upload tests to Xray or qTest via command line (pip install robotframework==4.1.3).

Due to modifications in the structure of the Output.xml file generated from robot framework test executions introduced in robot framework version 4.x, the test upload functionality has changed from previous releases as follows:

- **Previous release**: Test_Management_Automation folder supporting uploads for tests executed with robot framework version 3.x. Supports uploads to Jira-Xray only.
- **Current release**: EAT_Integration folder supporting uploads for tests executed with robot framework version 4.x. Supports uploads to Jira-Xray and qTest.

Test uploads using robot framework version 3.x is no longer supported, but the Test_Mangement_Automation folder will be maintained on the develop branch of the robot framework bitbucket repository in the short-term, for use by legacy projects if required.

WARNING: You are likely to see unexpected results if you attempt to upload robot framework 3.x test executions to Xray using the EAT_Integration folder upload commands, and vice-versa, using the Test_Management_Automation folder commands to upload robot framework 4.x test executions.

Robot Framework Xray Integration is detailed here:
https://sourcecode.jnj.com/pages/ASX-NCOH/robot_framework/browse/docs/#/user_guide/guidelines/rf_xray_integration


# Dependencies

1. Install Python.
2. Install dependencies on test machine: pip install -r EAT_Integration/requirements.txt
3. Make sure the user has the required ScrumTeam access in the JIRA project where tests are to be created. If not, request on https://appdevtools.jnj.com


# Create tests under Jira Stories
This workflow explains how tests are created in Jira before adding results for them in XRay test execution.
- The process here is that when the story is created, high level acceptance criteria are identified for the story.
- Tests are identified which cover the acceptance criteria.
- Tests outline in gherkin format are added in Robot Scripts and also second level keywords are created.
- After upload to Xray, the Test Steps (1st Level keywords) will appear in the Action column, and the child keywords of these steps (2nd level keywords) will appear in the Expected Result column.
- (3rd and subsequent level keywords do not appear in Xray)
- The 2nd level keyword may contain variable names (which will appear in the Data column in Xray) for which the values may be substituted in actual test execution.
- Ensure the documentation of these tests contains the text Jira-ID: <Story Jira ID>. 
- This is used to link the test to the jira story during Xray Upload

## Execute
- Execute the tests to upload with optional dryrun flag. E.g.
```
python driver.py -i <story tag> --dryrun
```
- At this point a report outline is generated for us to create tests in XRay.


## Upload
- Prepare the parameters that will be passed to the upload command to update Fix Version, Affects Version, etc. These can be found in:
 https://sourcecode.jnj.com/pages/ASX-NCOH/robot_framework/develop/browse/docs/#/user_guide/guidelines/_xray_parameters
- Use the command below, along with the parameters identifed in the previous step, to upload the results into XRay (-stop_approval is added here in the event that test cases are required to undergo manual approval for GxP project, but if not, the parameter can be excluded and test will be automatically approved).

```
python EAT_Integration/xray_uploader.py -r <Absolute path to Output.xml file> -jprj <Project Code>  -u <username> -p <password> -ct_json -stop_approval
```

An example could be:
```
python EAT_Integration/xray_uploader.py -r C:/Tests/Output/Output.xml -jprj AABD  -u <username> -p <password> -ct_json -stop_approval
```

## Review tests (for GxP projects, in particular)
These are manual steps to be performed for the test to be reviewed.
- Test are sent for review marking the status as Done.
- Test are assigned to TQ for review.
- TQ reviews the tests ensuring they cover the Acceptance Criteria and mark them as Complete.

Once in Completed state, the tests are ready for execution.

## Test implementation
At the same time that the tests are under review, if the tests were previously executed using dryrun parameter, the tester can now continue implementing the steps
under the 2nd level keywords to add logic to implement the test functionality and add data variable values in the Data
folder section.


# Create test result under XRay test execution
Once the implementation of tests is completed the tests are executed again without the dryrun flag i.e.
```
python driver.py -i <story tag>
```

If rerunning the test, ensure that there has been no modification to the first and second level keywords used in the steps that were uploaded, in order to avoid upload issues.

## Upload test result into XRay
- Note: Test Status must be 'Completed' prior to uploading test execution and results.
- If uploading tests to an existing test execution then that test execution key should be passed.
- If value is not passed for test execution then a new test execution is created.
- If an existing test execution is used and the test result already exists in the test execution and it is not in Completed state, then the result is overwritten.
- Upload using command:

```
python EAT_Integration\Xray\xray_uploader.py -r <Path to Output.xml file> -jprj <Project code>  -u <username> -p <password> -res_json -xex <Test Execution Id>
```
E.g.
```
python EAT_Integration\Xray\xray_uploader.py -r "/Robot_Tests/Output/Output.xml" -jprj AAOU  -u abcde -p password123 -res_json -xex "ABCD-123"
```

## Review test Execution
- Once the test results are uploaded to the test execution the Test execution status is changed to in-review and assigned to TQ.
- TQ reviews the test execution and once they have approved, the test execution is marked as Completed.
