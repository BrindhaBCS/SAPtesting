import os
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from PIL import Image
from datetime import datetime
from PyPDF2 import PdfMerger
from robot.libraries.BuiltIn import BuiltIn
import shutil

class Merger:
    @staticmethod
    def create_pdf(screenshot_directory):
        # Retrieve the current test case file name from the BuiltIn library
        test_case_file = BuiltIn().get_variable_value('${SUITE SOURCE}')
        
        # Extract the directory of the test case file
        base_dir = os.path.abspath(os.path.dirname(test_case_file))

        # Search upwards for the 'Reports' directory
        reports_dir = Merger.find_reports_directory(base_dir)

        if reports_dir:
            # Generate output PDF path using the test case file name
            pdf_filename = os.path.basename(test_case_file).replace('.robot', '.pdf')
            output_pdf = os.path.join(reports_dir, pdf_filename)

            # Initialize PdfMerger for combining PDFs
            pdf_merger = PdfMerger()

            try:
                # Get a list of all images in the screenshot directory
                images = []
                for filename in os.listdir(screenshot_directory):
                    if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):  # Add more if needed
                        image_path = os.path.join(screenshot_directory, filename)
                        # Get the timestamp (modified time) of the image
                        timestamp = os.path.getmtime(image_path)
                        images.append((image_path, timestamp, filename))

                # Sort images based on timestamp
                images.sort(key=lambda x: x[1])

                # Calculate starting vertical position (start from top of the page)
                vertical_position = A4[1] - 50  # 50 units from the top for padding
                
                # Iterate through the sorted image files
                for image_path, timestamp, filename in images:
                    # Open the image and process it
                    screenshot = Image.open(image_path)
                    screen_width, screen_height = screenshot.size
                    screenshot = screenshot.crop((0, 0, screen_width, screen_height))

                    # Calculate aspect ratio
                    aspect_ratio = float(screen_width) / float(screen_height)

                    # Adjust width and height to maintain aspect ratio
                    width = A4[0]
                    height = width / aspect_ratio

                    # Create a new canvas for each image
                    temp_pdf_path = os.path.join(reports_dir, f"temp_{filename}.pdf")
                    c = canvas.Canvas(temp_pdf_path, pagesize=A4)
                    c.setFont("Helvetica", 11)

                    # Check if there is enough space left on the page
                    if vertical_position - height < 0:
                        # If not enough space, create a new page
                        c.showPage()
                        vertical_position = A4[1] - 50  # Reset to top of the page

                    # Draw image at the current vertical position
                    c.drawInlineImage(image_path, (A4[0] - width) / 2, vertical_position - height, width=width, height=height)

                    # Generate new filename with current date and old filename
                    file_name, file_extension = os.path.splitext(filename)
                    current_time = datetime.now().strftime("%Y%m%d_%H%M%S")
                    new_filename = f"{current_time}_{file_name}{file_extension}"

                    # Save screenshot to Reports folder with new filename
                    report_path = os.path.join(reports_dir, new_filename)
                    screenshot.save(report_path)

                    # Add text annotation with filename below the image
                    text = f"Filename: {new_filename}, Time: {current_time}"
                    c.drawString((A4[0] - width) / 2 + 10, vertical_position - height - 15, text)

                    # Update vertical position for the next image (move down)
                    vertical_position -= height + 40  # 40 units padding between images

                    # Save and close the canvas
                    c.showPage()
                    c.save()

                    # Add the saved PDF page to the PdfMerger
                    pdf_merger.append(temp_pdf_path)

                # Save the combined PDF file
                with open(output_pdf, 'wb') as out_pdf:
                    pdf_merger.write(out_pdf)

                print(f"PDF created successfully: {output_pdf}")

            except Exception as e:
                print(f"Error occurred during PDF creation: {e}")

            finally:
                pdf_merger.close()
                # Clean up temporary PDF files
                for filename in os.listdir(reports_dir):
                    if filename.startswith("temp_") and filename.endswith(".pdf"):
                        os.remove(os.path.join(reports_dir, filename))
        else:
            print("Reports directory not found. PDF creation aborted.")

    @staticmethod
    def find_reports_directory(start_dir):
        """
        Recursively search upwards from start_dir for the 'Reports' directory.
        Return the path to 'Reports' directory if found, else return None.
        """
        current_dir = start_dir
        while True:
            reports_dir = os.path.join(current_dir, 'Reports')
            if os.path.exists(reports_dir) and os.path.isdir(reports_dir):
                return reports_dir
            # Move one directory up
            parent_dir = os.path.dirname(current_dir)
            if parent_dir == current_dir:
                break  # Reached root directory
            current_dir = parent_dir
        return None

    @staticmethod
    

    def copy_images(source_dir, target_dir):
        """
        Copy valid image files from source_dir to target_dir.
        Skip files whose names start with 'sap-screenshot'.
        Supported formats are '.jpeg', '.jpg', '.png', '.gif', '.bmp', '.tiff', '.webp'.
        """
        # Ensure the target directory exists
        if not os.path.exists(target_dir):
            os.makedirs(target_dir)

        # Supported image formats by PIL (Pillow)
        image_formats = ('.jpeg', '.jpg', '.png', '.gif', '.bmp', '.tiff', '.webp')

        # Iterate over files in the source directory
        for file_name in os.listdir(source_dir):
            file_path = os.path.join(source_dir, file_name)

            # Skip files that start with 'sap-screenshot'
            if file_name.lower().startswith("sap-screenshot"):
                print(f"Skipped: {file_name} - Matches the excluded pattern.")
                continue

            # Check if it's a file and if it has a valid image format
            if os.path.isfile(file_path):
                try:
                    with Image.open(file_path) as img:  # This will fail if the file is not a valid image
                        if file_name.lower().endswith(image_formats):
                            target_path = os.path.join(target_dir, file_name)
                            shutil.copy(file_path, target_path)
                            print(f"Copied: {file_name}")
                except Exception as e:
                    print(f"Skipped: {file_name} - Not a valid image file or format not supported. Error: {e}")