import os
import PyPDF2

class Merge():
    @staticmethod
    def merge_pdfs_in_folder(folder_path, output_path):
        merger = PyPDF2.PdfMerger()
        # Iterate through all files in the folder
        for filename in os.listdir(folder_path):
            if filename.endswith('.pdf'):
                file_path = os.path.join(folder_path, filename)
                merger.append(file_path)
        # Write the merged PDF to the output path
        with open(output_path, 'wb') as output_file:
            merger.write(output_file)

    # Specify the folder containing the PDF files
    # folder_path = '/path/to/your/pdf/folder'

    # # Specify the output path for the merged PDF file
    # output_path = '/path/to/merged/file.pdf'

    # # Merge the PDFs in the folder and save the merged PDF
    # merge_pdfs_in_folder(folder_path, output_path)

# Usage
if __name__ == "__main__":
    pdf_instance = Merge()
    pdf_instance.merge_pdfs_in_folder(folder_path, output_path)
