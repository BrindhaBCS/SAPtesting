import re
class   sample:

    def get_document_number(self, status_id):
        try:
            status = self.session.findById(status_id).Text
            print(status)
            pattern = r"Document (\d+) was posted in company code (\d+)"
            match = re.search(pattern, status)
            if match:
                # status_split = status.split()
                document_no = match.group(1)
                print(document_no)
                return document_no
            else:
                return None
        except Exception as e:
            return f"Error: {str(e)}"