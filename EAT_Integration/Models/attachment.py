"""
Defines Attachment structure object for Robot Framework test report for Jira XRay
"""
import mimetypes

class Attachment:
    """
    Attachment structure read through robot report
    """
    def __init__(self, attachment_path, time_created, data=None):
        self.attachment_path = attachment_path
        self.time_created = time_created
        self.data = data
        self.filename = attachment_path.split("/")[-1]
        self.content_type = mimetypes.guess_type(attachment_path)[0]
