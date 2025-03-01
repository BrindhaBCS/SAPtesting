import os
import shutil
from PIL import Image
from fpdf import FPDF
import os
from datetime import datetime

def copy_images(source_dir, target_dir):
        # Ensure the target directory exists
        if not os.path.exists(target_dir):
            os.makedirs(target_dir)                       
        image_formats = ('.jpeg', '.jpg', '.png', '.gif', '.bmp', '.tiff', '.webp')
        for file_name in os.listdir(source_dir):
            file_path = os.path.join(source_dir, file_name)
            if os.path.isfile(file_path):
                try:
                    with Image.open(file_path) as img:
                        if file_name.lower().endswith(image_formats):
                            target_path = os.path.join(target_dir, file_name)
                            shutil.copy(file_path, target_path)
                            print(f"Copied: {file_name}")
                except Exception as e:
                    print(f"Skipped: {file_name} - Not a valid image file or format not supported. Error: {e}")

def images_to_pdf(image_folder, output_pdf):
    try:
        # Check if the folder exists
        if not os.path.exists(image_folder):
            raise FileNotFoundError(f"The folder {image_folder} does not exist.")
        # Create a PDF instance
        pdf = FPDF()
        pdf.set_auto_page_break(0)  # Disable auto page break
        # Collect all image files from the folder
        image_files = [f for f in os.listdir(image_folder) if f.lower().endswith(('.png', '.jpg', '.jpeg', '.bmp', '.gif'))]
        if not image_files:
            raise ValueError("No supported image files found in the folder.")
        # Sort files to maintain order
        for image_file in sorted(image_files):
            image_path = os.path.join(image_folder, image_file)
            try:
                # Open and process each image
                image = Image.open(image_path)
                # Convert the image to RGB if necessary
                if image.mode in ('RGBA', 'LA'):
                    image = image.convert('RGB')
                # Get the image size in pixels
                width, height = image.size
                # Convert size to mm for FPDF
                width_mm = width * 0.364583  # Convert pixels to mm
                height_mm = height * 0.364583
                # A4 page dimensions in mm
                pdf_page_width = 265
                pdf_page_height = 330
                # Scale the image to fit within A4 dimensions
                scale = min(pdf_page_width / width_mm, pdf_page_height / height_mm)
                new_width_mm = width_mm * scale
                new_height_mm = height_mm * scale
                # Center the image on the page
                x_offset = (pdf_page_width - new_width_mm) / 4
                y_offset = (pdf_page_height - new_height_mm - 20) / 4 
                # Add a new page with appropriate orientation
                orientation = 'P' if width_mm <= height_mm else 'L'
                pdf.add_page(orientation=orientation)
                # Add the image to the PDF
                pdf.image(image_path, x=x_offset, y=y_offset, w=new_width_mm, h=new_height_mm)
                # Add the filename and timestamp below the image
                filename = os.path.basename(image_path)
                timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                pdf.set_xy(10, y_offset + new_height_mm + 5)
                pdf.set_font("Arial", size=10)
                pdf.cell(0, 10, f"File name: {filename}   Timestamp: {timestamp}", align='C')
            except Exception as e:
                print(f"Error processing image {image_file}: {e}")
                continue
        # Save the resulting PDF
        pdf.output(output_pdf)
        print(f"PDF created successfully: {output_pdf}")
    except Exception as e:
        print(f"An error occurred: {e}")