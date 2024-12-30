import os
from PIL import Image
from datetime import datetime
import shutil

class ScreenshotProcessor:
    @staticmethod
    def process_screenshots(screenshot_directory, destination_directory):
        # Create the destination directory if it doesn't exist
        if not os.path.exists(destination_directory):
            os.makedirs(destination_directory)

        # Iterate through image files in the specified directory
        for filename in os.listdir(screenshot_directory):
            if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif')):
                image_path = os.path.join(screenshot_directory, filename)

                # Open the image to ensure it's a valid image file
                try:
                    screenshot = Image.open(image_path)
                    screenshot.verify()  # Verify the image is valid
                except (IOError, SyntaxError) as e:
                    print(f"Skipping invalid image file: {filename}")
                    continue

                # Copy the screenshot to the destination directory
                shutil.copy(image_path, os.path.join(destination_directory, filename))

                # Optionally, log the file copy operation
                current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                print(f"Copied {filename} at {current_time}")

# Usage
if __name__ == "__main__":
    # screenshot_directory = "C:\\Nike\\SAPtesting\\Output\\pabot_results\\0"  # Replace with your screenshot directory
    # destination_directory = "C:\\Nike\\SAPtesting\\Output\\pabot_results\\0\\Screenshot"  # Replace with your destination directory
    processor = ScreenshotProcessor()
    processor.process_screenshots(screenshot_directory, destination_directory)
