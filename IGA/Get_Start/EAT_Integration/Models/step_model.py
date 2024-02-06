"""
Defines Step structure object for Robot Framework test report for Jira XRay
"""


class Step:
    """
    Test Step structure to be built
    """
    def __init__(self, **kwargs):
        self.description = kwargs.get("description", "")
        self.expected = kwargs.get("expected", "")
        self.actual = kwargs.get("actual", self.expected)
        self.template = kwargs.get("template", "")
        self.status = kwargs.get("status", "PASS")
        self.attachment = kwargs.get("attachment")
        self.start_time = kwargs.get("start_time", "")
        self.end_time = kwargs.get("end_time", "")
        self.execution_counter = kwargs.get("execution_counter", 1)
        self.variables = kwargs.get("variables", {})
