Project: <ProjectName> Robot Framework Version: <Version_Number>
==========================================================================================

## Kibana Integration

The Robot Framework test execution infrastructure utilises the inherent robot framework listener feature to process test results and send those results to a Kibana dashboard, an open-source user interface that allows you to visualise your data.

If your test execution runs without error, you should see a record of the execution in Kibana. To access the list of test executions for your project, you can search for them as follows:

- Navigate to https://kibana.eat.jnj.com/app/discover

- From the dropdown list of loggers on the left-hand side of the page, select robot-logger

- Apply filters on the dashboard to narrow down the search results using jira_project_code, project_name, etc.

- You can also adjust the timeframe on the top of the page to a range containing the time stamp of an individual test execution if required

- Based on your selections, a list of test executions will be visible on the page if they fall inside the selected range and the test executions completed successfully without error.

!>Note that for Salesforce projects, the listener feature for the cci command is not fully implemented, so the execution records are not yet visible in Kibana.
