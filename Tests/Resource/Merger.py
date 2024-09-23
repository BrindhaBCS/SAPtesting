# import os
# import shutil
# from PIL import Image

# def copy_images(source_dir, target_dir):

#     # Ensure the target directory exists

#     if not os.path.exists(target_dir):

#         os.makedirs(target_dir)

#     # Supported image formats by PIL (Pillow)

#     image_formats = ('.jpeg', '.jpg', '.png', '.gif', '.bmp', '.tiff', '.webp')

#     # Iterate over files in the source directory

#     for file_name in os.listdir(source_dir):

#         file_path = os.path.join(source_dir, file_name)

#         # Check if it's a file and if it has a valid image format

#         if os.path.isfile(file_path):

#             try:

#                 with Image.open(file_path) as img:  # This will fail if the file is not a valid image

#                     if file_name.lower().endswith(image_formats):

#                         target_path = os.path.join(target_dir, file_name)

#                         shutil.copy(file_path, target_path)

#                         print(f"Copied: {file_name}")

#             except Exception as e:

#                 print(f"Skipped: {file_name} - Not a valid image file or format not supported. Error: {e}")
 
# # Example usage
# # source_directory = '/path/to/source/directory'
# # target_directory = '/path/to/target/directory'
# # copy_images(source_directory, target_directory)

import os
import shutil
from PIL import Image

def copy_images(source_dir, target_dir):
    # Ensure the target directory exists
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)
 
    # Supported image formats by PIL (Pillow)
    image_formats = ('.jpeg', '.jpg', '.png', '.gif', '.bmp', '.tiff', '.webp')
    images = []  # List to store opened images

    # Iterate over files in the source directory
    for file_name in os.listdir(source_dir):
        file_path = os.path.join(source_dir, file_name)
 
        # Check if it's a file and if it has a valid image format
        if os.path.isfile(file_path):
            try:
                with Image.open(file_path) as img:  # This will fail if the file is not a valid image
                    if file_name.lower().endswith(image_formats):
                        target_path = os.path.join(target_dir, file_name)
                        shutil.copy(file_path, target_path)
                        print(f"Copied: {file_name}")
                        
                        # Convert image to RGB and append it to the list for the PDF
                        images.append(Image.open(target_path).convert('RGB'))

            except Exception as e:
                print(f"Skipped: {file_name} - Not a valid image file or format not supported. Error: {e}")
    
    # Call merge_images_to_pdf to merge all copied screenshots into a PDF
    if images:
        merge_images_to_pdf(images, target_dir)

def merge_images_to_pdf(images, target_dir):
    # Extract the folder name from the target directory
    folder_name = os.path.basename(target_dir.rstrip('/\\'))
    
    # Create the path for the PDF file using the folder name
    pdf_path = os.path.join(target_dir, f'{folder_name}.pdf')
    
    if images:
        # Save all images into a single PDF
        images[0].save(pdf_path, save_all=True, append_images=images[1:])
        print(f"Merged screenshots saved as {pdf_path}")

# Example usage
# source_dir = r'C:\SAP_Testing\SAPtesting\Output\pabot_results\0'
# target_dir = r'D:\Screenshots\Pre'
# copy_images(source_dir, target_dir)


 
 