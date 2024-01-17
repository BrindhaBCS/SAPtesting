"""
This supports processing of date time data. Creating format or datetime objects to be processed.
"""
import functools
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
from dateutil import tz


class DateTimeSupport:
    """
    Creates functions to support date time processing for json
    payload processing for Robot Framework
    """
    def __init__(self, args=None):
        self.args = args

    @staticmethod
    def get_time_format_string(execution_time=None):
        """
        Converts to readable string format for a time object
        :param execution_time: Time object to get string format for
        :return: String representation of time or current time
        """
        time_format = "%a %d %b %Y at %T:%f"
        if not execution_time:
            execution_time = datetime.now()
        return execution_time.strftime(time_format)[:-3]

    @property
    @functools.lru_cache()
    def get_timezone_local(self):
        """
        Fetches current timezone difference in string format of type +05:30
        :return: Timezone format string
        """
        if self.args and self.args.time_difference_from_gmt:
            timezone_difference = self.args.time_difference_from_gmt
        else:
            datetime_object = datetime.now()
            local_now = datetime_object.astimezone()
            local_tz = local_now.tzinfo
            local_time = datetime_object.astimezone(local_tz)
            timezone_difference = local_time.astimezone().strftime("%z")
        return timezone_difference

    @staticmethod
    def get_datetime_timezone_unaware(datetime_object):
        """
        Removes datetime from timezone aware to timezone not aware object
        :param datetime_object: datetime object to convert
        :return: timezone unaware format of datetime object
        """
        return datetime_object.replace(tzinfo=None)

    def get_api_datetime(self, date_object):
        """
        Converts a datetime object to api accepted string format which is
        e.g. "2014-08-30T11:47:35+01:00"
        :param date_object: datetime object to convert to required format
        :return: string format expected by XRay api
        """
        timezone_format = self.get_timezone_local
        timezone_format = timezone_format[:3] + ":" + timezone_format[3:]
        return date_object.strftime("%Y-%m-%dT%H:%M:%S" + timezone_format)

    def get_time_string_for_action(self, start_time, end_time):
        """
        Fetches time string to be logged for information into XRay report
        :param start_time: Start time in datetime format
        :param end_time: Finish time in datetime format
        :return: string data to represent the execution times
        """
        total_time = str((end_time - start_time).total_seconds())
        start_time_string = self.get_time_format_string(start_time)
        end_time_string = self.get_time_format_string(end_time)
        string_representation = "Start Time: " + start_time_string + "\nEnd Time: " +\
                                end_time_string + "\nTotal Time: " + total_time +\
                                " seconds\n\n"
        return string_representation

    @staticmethod
    def get_time_from_jira_string(jira_time_representation):
        """
        Gets time representation from jira time which is of the format 2020-01-27T05:08:00.000-0500
        :param jira_time_representation: datetime object from string
        """
        if jira_time_representation and isinstance(jira_time_representation, str):
            format_time = "%Y-%m-%dT%H:%M:%S.%f%z"
            jira_time = datetime.strptime(
                jira_time_representation, format_time)
        else:
            jira_time = datetime.now()
            local_now = jira_time.astimezone()
            timezone_object = local_now.tzinfo
            jira_time = timezone_object.localize(jira_time)
        return jira_time

    def make_timezone_aware(self, date_object):
        """
        Converts a date object to timezone aware date object
        :param date_object: datetime object
        :return: timezone aware datetime object
        """
        date_string = date_object.strftime("%Y-%m-%dT%H:%M:%S.%f") + \
            self.get_timezone_local
        timezone_aware = datetime.strptime(date_string, "%Y-%m-%dT%H:%M:%S.%f%z")
        return timezone_aware

    def convert_for_jira(self, date_object):
        """
        Converts to string object for jira consumption
        :param date_object: datetime object
        :return: date of format %Y-%m-%dT%H:%M:%S.%f%z. E.g. '2020-02-03T05:24:00.000-0500'
        """
        milliseconds = date_object.strftime("%f")[:3].zfill(3)
        return date_object.strftime("%Y-%m-%dT%H:%M:%S.") + milliseconds +\
            self.get_timezone_local

    def get_datetime_for_json(self, json_date_string):
        """
        Converts a datetime for json report time string into datetime object
        :param json_date_string: String in datetime with format: %Y%m%d %H:%M:%S.%f
        :return: datetime object from the input string
        """
        json_date_string += self.get_timezone_local
        return datetime.strptime(json_date_string, "%Y%m%d %H:%M:%S.%f%z")

    @staticmethod
    def get_datetime_representation_json(date_object):
        """
        From a datetime object converts it into string of format %Y%m%d %H:%M:%S.%f
        :return: string representation of datetime of format %Y%m%d %H:%M:%S.%f
        """
        return datetime.strftime(date_object, "%Y%m%d %H:%M:%S.%f")

    @property
    @functools.lru_cache()
    def get_time_zone_difference(self):
        """
        Deprecated. Here for future reference
        Fetches the difference in timezone to be added to a datetime field to update
        Jira field values. Fetches time difference from US/Eastern timezone
        :return: Time difference in hours
        """
        utc_now = datetime.utcnow()
        now = datetime.now()
        local_now = now.astimezone()
        local_timezone = local_now.tzinfo
        local_time = utc_now.astimezone(local_timezone).replace(tzinfo=None)
        est_time = utc_now.astimezone(tz.gettz("US/Eastern")).replace(tzinfo=None)
        offset = relativedelta(est_time, local_time)
        negative = offset.hours < 0 or offset.minutes < 0
        time_representation_format = "%s%s%s"
        timezone_difference_from_gmt = "+"
        if negative:
            timezone_difference_from_gmt = "-"
        hours = str(abs(offset.hours)).zfill(2)
        minutes = str(abs(offset.minutes)).zfill(2)
        time_representation = time_representation_format % (
            timezone_difference_from_gmt, hours, minutes)
        return time_representation

    def add_timezone_difference(self, date_object):
        """
        Adds timezone difference to date object to result in US/Eastern time.
        Deprecated. Here for future reference
        :param date_object: datetime object
        :return: Date converted to target timezone
        """
        timezone_difference = self.get_time_zone_difference
        if not timezone_difference.endswith("0000"):
            timezone_change = "+"
            if timezone_difference[-5] == "-":
                timezone_change = "-"
            hour_difference = int(timezone_change + timezone_difference[-4:-2])
            minute_difference = int(timezone_change + timezone_difference[-2:])
            time_to_add = timedelta(hours=hour_difference, minutes=minute_difference)
            date_object += time_to_add
        return date_object