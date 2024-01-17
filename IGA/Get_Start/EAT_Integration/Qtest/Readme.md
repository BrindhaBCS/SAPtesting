# qTest Uploader Workflow

This workflow explains how tests are created in qTest before adding results for them in qTest test run.

The process here is the same as for Xray:

- When the story is created, high level acceptance criteria are identified for the story.
- Tests are identified which cover all acceptance criteria.
- Tests outlined in gherkin format are added in Robot Scripts and also second level keywords (expected results) are created.
- The 2nd level keyword can contain variable names for which the values will be substituted in actual test execution.
- Ensure the documentation of these tests contain the text qTest-ID: qTest_Project_Id for logging purposes.

## Execute

- Execute the tests to upload with optional dryrun flag. E.g.

```python
python driver.py -i tag_name -dr
```

- At this point a report outline of the test steps is generated that will be used to create tests in qTest.

## Upload
- Prepare the parameters that will be passed to the upload command to update Test Level, etc. These can be found in:
 https://sourcecode.jnj.com/pages/ASX-NCOH/robot_framework/browse/docs/#/user_guide/guidelines/_qtest_parameters
- Use the command below to upload the results into qTest. The tests will be moved to Completed state by default, but this can be disabled by adding -stop_approval parameter to the command (e.g. in case the test needs to be manually approved by TQ).

```python
python EAT_Integration/qTest/qtest_uploader.py -r <Absolute path to Output.xml report> -qprj <Project Code>  -qfid <Project folder Id> -qassign <username of test assignee> -qtoken <User Bearer token> -ct_json
```

An example could be:

```python
python EAT_Integration/qTest/qtest_uploader.py -r C:/Tests/Output/Output.xml -qprj 111 -qfid 222 -qassign jbloggs1  -qtoken <User Bearer token> -ct_json -stop_approval
```

## Review tests

TQ can then review the tests ensuring they cover the Acceptance criteria and mark them as Approved.

At this point the tests are ready for execution.

## Test implementation

At the same time that the tests are under review, if dryrun parameter was used during the previous test execution, the tester can continue implementing the steps
under the second level keywords to add logic to implement test functionality and add data variable values in the Data
folder section.

## Create test result under qTest test run

Once the implementation of tests is completed the tests are executed again without the dryrun flag i.e.

```python
python driver.py -i tag_name
```

If rerunning the test, ensure that there has been no modification to the first and second level keywords used in the steps that were uploaded, in order to avoid upload issues.

## Upload test result into qTest

- If uploading test results to an existing test run then the test run Id should be passed.
- If Id is not passed for test run then a new test run is created.
- Upload using command:

```python
python EAT_Integration/qTest/qtest_uploader.py -r <Absolute path to Output.xml> -qprj <Project Id>  -qtoken <User Bearer token> -res_json -qrunid <qTest Test Run ID: Optional>
```

E.g.

```python
python EAT_Integration/qTest/qtest_uploader.py -r "Z:\Output\Output.xml" -qprj 111  -qtoken <User Bearer token> -res_json -qrunid 123456
```

## Review test Execution

- Once the test results are uploaded to the test run it can be routed to TQ for review.
- TQ reviews the test run and marks it as Approved.
