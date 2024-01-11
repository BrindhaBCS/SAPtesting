"""
Reads through logged metadata that are used to execute the robot framework test.
Requires that the test logs this information in robot output using driver script
Also the test execution should have been built using the latest getting started guide.
"""


class MetadataSupport:
    """
    Reads through test execution python dependency to verify that the python
    dependencies used to execute the test was part of compliant GxP dependencies
    """
    def __init__(self, soup):
        """
        Initializes Dependencies using the soup object for the xml file.
        This supports reading through dependencies logged under pip_dependencies variable.
        :param soup: bs4.BeautifulSoup object
        """
        self.soup = soup
        self.highest_suite = self.soup.findChild("suite")
        self.metadata_tag = self.highest_suite.findChild("metadata", recursive=False)

    def get_dependencies(self):
        """
        Fetches dependencies used to execute the test
        :return: List of dependencies
        """
        dependencies = []
        try:
            if self.metadata_tag:
                logged_dependencies = self.metadata_tag.findChild(
                    "item", attrs={"name": "test_freeze_dependencies"})
            else:
                logged_dependencies = self.highest_suite.findChild(
                    "meta", attrs={"name": "test_freeze_dependencies"})
            if logged_dependencies:
                dependencies = logged_dependencies.split(",")
        except TypeError:
            pass
        return dependencies

    def _get_browser_details(self):
        """
        Fetches details such as browser and url information used to execute the test.
        :param test:
        :return: dict of browser information
        """
        browser_details = {"browser_name": "",
                           "browser_version": "",
                           "browser_driver_version": ""}

        if self.metadata_tag:
            browser_version = self.metadata_tag.findChild(
                "item", attrs={"name": "test_browser_version"})
            browser_driver_version = self.metadata_tag.findChild(
                "item", attrs={"name": "test_driver_version"})
            browser_name = self.metadata_tag.findChild(
                "item", attrs={"name": "test_browser_name"})
        else:
            browser_version = self.highest_suite.findChild(
                "meta", attrs={"name": "test_browser_version"})
            browser_driver_version = self.highest_suite.findChild(
                "meta", attrs={"name": "test_driver_version"})
            browser_name = self.highest_suite.findChild(
                "meta", attrs={"name": "test_browser_name"})
        if browser_name:
            browser_details["browser_name"] = browser_name.string
        if browser_version:
            browser_details["browser_version"] = browser_version.string
        if browser_driver_version:
            browser_details["browser_driver_version"] = browser_driver_version.string

        return browser_details

    def _get_platform_details(self):
        """
        Fetches details such as Platform information used to execute the test.
        :return: string of platform information
        """
        platform_information = ""
        try:
            if self.metadata_tag:
                logged_platform_info = self.metadata_tag.findChild(
                    "item", attrs={"name": "test_execution_platform"})
            else:
                logged_platform_info = self.highest_suite.findChild(
                    "meta", attrs={"name": "test_execution_platform"})
            if logged_platform_info:
                platform_information = logged_platform_info.string
        except TypeError:
            pass
        return platform_information

    def _get_test_environment(self):
        """
        Fetches details for test environment information used to execute the test.
        :return: string of Test Type
        """
        environment = ""
        try:
            if self.metadata_tag:
                logged_environment_info = self.metadata_tag.findChild(
                    "item", attrs={"name": "test_environment"})
            else:
                logged_environment_info = self.highest_suite.findChild(
                    "meta", attrs={"name": "test_environment"})
            if logged_environment_info:
                environment = logged_environment_info.string
        except TypeError:
            pass
        return environment

    def get_meta_data_combined_information(self):
        """
        Reads through information into dict variable from other metadata functions
        apart from dependencies
        :return: dict of data of format: {metadata: {...}}
        """
        return {"metadata": {"platform": self._get_platform_details(),
                             "browser": self._get_browser_details(),
                             "test_environment": self._get_test_environment(),
                             }}
