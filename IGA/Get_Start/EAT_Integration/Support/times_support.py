"""
This supports processing of date time data. Creating format or datetime objects to be processed.
"""
from datetime import datetime
from .date_and_time_support import DateTimeSupport


class TimeSupport:
    """
    Creates functions to support date time processing for xml data processing for Robot Framework
    """
    def __init__(self, soup_support=None):
        """
        Constructor which can call method on soup
        :param soup_support:
        """
        self.soup_support = soup_support
        self.date_time_support = DateTimeSupport()

    def get_times_and_status(self, element):
        """
        Fetches status, start and end time for an element tag of kw or test type

        :param element: Element in the xml of robot results of type kw or test
        :type element: BeautifulSoup Element of xml
        :return: dictionary of data containing start, end times and status time
        """
        status = "FAILED"
        start_time = ""
        end_time = ""
        status_tag = self.soup_support.read_inner_tags_of_type(
            element, "status", False)
        if status_tag:
            status = status_tag[0].get("status", "")
            start_time = status_tag[0].get("starttime", "")
            end_time = status_tag[0].get("endtime", "")
            start_time = self.get_date_time_format(start_time)
            end_time = self.get_date_time_format(end_time)
            status = self.apply_status(status)

        time_status_dict = {"start_time": start_time,
                            "end_time": end_time,
                            "status": status}
        return time_status_dict

    def get_date_time_format(self, date_string):
        """
        Formats the string read from robot framework to a date format

        :param date_string: String specifying robot framework test result.
                Expecting, E.g. '20160915 16:20:50.123'
        :type date_string: string
        :return: datetime format of the string. If blank then returns datetime.now()
        """
        date_value = datetime.now()
        if date_string:
            date_value = datetime.strptime(date_string, "%Y%m%d %H:%M:%S.%f")
        return self.date_time_support.make_timezone_aware(date_value)

    @staticmethod
    def apply_status(status):
        """
        Based on the content of status returns Passed or Failed as status.

        :param status: Status of the result read from XML
        :type status: string
        :returns: Updated status based on its current value in xml.
        """
        if "pass" in status.lower():
            status = "Passed"
        elif "fail" in status.lower():
            status = "Failed"
        else:
            status = "No Run"
        return status
