"""
Creates a soup for the xml output report.
"""
from xml.sax.saxutils import unescape
import bs4


class Soup:
    """
    Creates and processes BeautifulSoup related functionality for Output Report parsing
    """
    def __init__(self, report_path):
        self.bs_soup = bs4.BeautifulSoup(open(report_path, "r", errors="ignore"), "xml")
        self.exclude_filters = []
        self.filter_for_tag = ""

    @staticmethod
    def get_child_element_text(tag, child_tag_name):
        """
        Gets the text of child element
        :param tag: Tag element to look for child under it
        :param child_tag_name: Tag name to look under the tag
        :return: String value read under the child tag
        """
        data_read = ""
        child_tag = tag.findChildren(child_tag_name, recursive=False)
        if child_tag:
            data_read = child_tag[0].string.strip()
        return data_read

    @staticmethod
    def get_xml_unescape(value):
        """
        Unescapes a string read from xml.
        As that may have special characters e.g. <&> as &lt; &amp; &gt;
        :param value: String to unescape
        :return: Unescaped value for xml string
        """
        return unescape(value)

    @staticmethod
    def read_inner_tags_of_type(tag, inner_tag_type, recursive=False):
        """
        Reads data from inner tag of type specified in a recursive manner selected
        :param tag: Tag to read children information from
        :param inner_tag_type: Type of tags to read as children
        :param recursive: Recursively read or not the information of children
        :return: Children tags of type searched in recursive manner
        """
        return tag.findChildren(inner_tag_type, recursive=recursive)

    def read_all_messages(self, parent_tag, recursive=True):
        """
        Reads all message information from a tag
        :param parent_tag: Tag under which to look for message information
        :param recursive: Boolean to find all underlying messages or messages
                only till tag children level
        :return: List of messages
        """
        return self.read_inner_tags_of_type(
            parent_tag, "msg", recursive)

    def _read_all_arguments(self, tag, recursive=False):
        """
        Reads all arguments information under a tag
        :param tag: Tag under which to look for message information
        :return: List of variables read
        """
        arguments_read = []
        argument_tag = self.read_inner_tags_of_type(tag, "arguments", recursive)
        if not argument_tag:
            return arguments_read
        for arg in self.read_inner_tags_of_type(argument_tag[0], "arg", recursive):
            arguments_read.append(arg.string)
        return arguments_read

    @staticmethod
    def _update_read_value_if_newline(value_read):
        """
        Checks if newline is there is value read and if so then strip and return
        stripped value
        :param value_read: line of data to be read
        :return: stripped value
        """
        if "\n" in value_read:
            value_read = value_read.split("\n", 1)[0].strip()
        return value_read

    def get_doc_extraction(self, start_string, doc_text, suite_value):
        """
        Extracts documentation data in terms of start string and an end point.
        Text may have multiple values comma separated.
        :param start_string: string to identify the start of the value
        :param doc_text: the complete text read from the result
        :param suite_value: Suite value to substitute at test level if empty
        :return: Comma separated string of values read from doc_text
        """
        value_read = ""
        updated_text = doc_text
        if start_string.upper() in doc_text.upper():
            start_index = doc_text.upper().index(start_string.upper())
            end_index = start_index + len(start_string)
            value_read = doc_text[end_index:].split(".", 1)[0]
            value_index = end_index + len(value_read) + 1
            value_read = value_read.strip()
            value_read = self._update_read_value_if_newline(value_read)
            if "," in value_read:
                all_values = value_read.split(",")
                for counter, _ in enumerate(all_values):
                    all_values[counter] = all_values[counter].strip()
                    if " " in all_values[counter]:
                        all_values[counter] = all_values[counter].split(" ", 1)[0]
                value_read = ",".join(all_values)
            elif " " in value_read:
                value_read = value_read.split(" ", 1)[0]
            updated_text = doc_text[:start_index].strip()
            if len(doc_text) >= value_index:
                updated_text += doc_text[value_index:]

        if not value_read:
            value_read = suite_value
        return value_read, updated_text

    @staticmethod
    def _soup_filter_method(tag):
        """
        Creates a filter method for finding elements in soup
        :param tag: Tag element to find object for
        :return: True if the filter is found for a particular tag
        """
        found = False
        if tag.name in ["kw"] and tag.attrs.get("type", "").lower() \
                not in ["teardown", "setup"]:
            found = True
        return found

    def get_all_keyword_tags(self, test_tag, all_kw_tags=None):
        """
        Retrieves all tags that are of kw type but not of type teardown

        :param test_tag: Xml element under which steps are added in keywords
        :param all_kw_tags: Recursively building list of tags
        """
        if all_kw_tags is None:
            all_kw_tags = {}
        kw_tags = test_tag.findChildren(self._soup_filter_method, recursive=False)
        for tag in kw_tags:
            all_kw_tags.setdefault(tag, {})
            self.get_all_keyword_tags(tag, all_kw_tags[tag])
        return all_kw_tags

    @staticmethod
    def check_update_test_if_data_driven(all_kw_tags):
        """
        Checks if the inner keywords point to a single keyword.
        In this case update all_kw_tags to point to the inner tag and update
        name to include the highest level tag name in it. If multiple keywords
        but they all have same name hinting at templated data driven test. Then
        perform the same update at next level keywords. Updates all_kw_tags to point
        to inner keyword then for processing.
        :param all_kw_tags: Keywords structure read for steps of the tests
        :return True if the keywords are of type template
        """
        # Check if all keywords are the same i.e. data driven template test
        data_driven = False
        if all_kw_tags:
            first_tag_name = list(all_kw_tags.keys())[0].attrs["name"]
            data_driven = all(x["name"] == first_tag_name for x in all_kw_tags)
        return data_driven
