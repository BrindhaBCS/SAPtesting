import os

class FileOperations:
    def delete_file(self, file_path):
        if os.path.isfile(file_path):
            try:
                os.remove(file_path)
                print(f"Deleted file: {file_path}")
            except Exception as e:
                print(f"Error deleting file {file_path}: {str(e)}")
        else:
            print(f"File not found: {file_path}")
