import os
import shutil
from PIL import Image

def copy_images(source_dir, target_dir):

    # Ensure the target directory exists

    if not os.path.exists(target_dir):

        os.makedirs(target_dir)

    # Supported image formats by PIL (Pillow)

    image_formats = ('.jpeg', '.jpg', '.png', '.gif', '.bmp', '.tiff', '.webp')

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

            except Exception as e:

                print(f"Skipped: {file_name} - Not a valid image file or format not supported. Error: {e}")
 
# Example usage
# source_directory = '/path/to/source/directory'
# target_directory = '/path/to/target/directory'
# copy_images(source_directory, target_directory)

 

 
 