import os
import fitz  # PyMuPDF
import cv2  # opencv-python
import numpy as np
from fpdf import FPDF

def pdf_to_images(pdf_path, output_folder):
    """Convert PDF pages to images and save them with meaningful filenames."""
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    pdf_document = fitz.open(pdf_path)
    image_paths = []

    for page_num in range(pdf_document.page_count):
        page = pdf_document.load_page(page_num)
        pix = page.get_pixmap()
        
        # Saving images with a meaningful name
        image_path = f"{output_folder}/page_{page_num + 1}.png"
        pix.save(image_path)
        image_paths.append(image_path)

    return image_paths

def change_different_data_color(img1, img2, change_color=(0, 0, 255)):
    """Change the color of differing data in the image."""
    # Compute the absolute difference
    diff = cv2.absdiff(img1, img2)
    gray_diff = cv2.cvtColor(diff, cv2.COLOR_BGR2GRAY)
    
    # Threshold the grayscale difference image
    _, thresh = cv2.threshold(gray_diff, 30, 255, cv2.THRESH_BINARY)

    # Create a mask of the differing pixels
    mask = np.zeros_like(img1, dtype=np.uint8)
    mask[thresh == 255] = change_color  # Set differing pixels to the desired color

    # Create the output image where differing pixels are replaced with the change color
    colored_image = img1.copy()
    colored_image[mask > 0] = mask[mask > 0]  # Change only differing pixels to the new color

    return colored_image

def compare_images(image1_path, image2_path):
    """Compare two images and return an image with differing data colored."""
    img1 = cv2.imread(image1_path)
    img2 = cv2.imread(image2_path)

    # Resize images if they are not the same size
    if img1.shape != img2.shape:
        img2 = cv2.resize(img2, (img1.shape[1], img1.shape[0]))

    # Change color of differing data
    colored_image = change_different_data_color(img1, img2)
    
    # Return colored image and a boolean indicating if differences were found
    return colored_image, cv2.countNonZero(cv2.cvtColor(cv2.absdiff(img1, img2), cv2.COLOR_BGR2GRAY)) > 0

def find_differences(images1, images2):
    """Find differences between two sets of images by comparing filenames."""
    differences = []

    # Use a set to match images based on filename
    images1_dict = {os.path.basename(img): img for img in images1}
    images2_dict = {os.path.basename(img): img for img in images2}

    # Compare images by filename
    common_filenames = set(images1_dict.keys()) & set(images2_dict.keys())

    for filename in common_filenames:
        img1_path = images1_dict[filename]
        img2_path = images2_dict[filename]

        # Compare the two images
        colored_image, has_differences = compare_images(img1_path, img2_path)
        if has_differences:
            highlighted_path = f"colored_diff_{filename}"
            cv2.imwrite(highlighted_path, colored_image)  # Save colored image
            differences.append((highlighted_path, img1_path, img2_path))  # Store paths of differing images

    return differences

def create_diff_pdf(differences, output_pdf):
    """Create a PDF report of the differences."""
    pdf = FPDF()
    
    for highlighted_path, img1_path, img2_path in differences:
        pdf.add_page()
        
        # Add images to the PDF: colored image and original images
        pdf.image(highlighted_path, x=10, y=10, w=90)  # Colored image
        pdf.image(img1_path, x=110, y=10, w=90)  # Original image 1
        pdf.image(img2_path, x=110, y=110, w=90)  # Original image 2

    pdf.output(output_pdf)

def compare_pdfs_and_generate_report(pdf1_path, pdf2_path, output_pdf):
    """Main function to compare two PDFs and generate a report."""
    folder1 = "pdf1_images"
    folder2 = "pdf2_images"
    
    images_pdf1 = pdf_to_images(pdf1_path, folder1)
    images_pdf2 = pdf_to_images(pdf2_path, folder2)

    differences = find_differences(images_pdf1, images_pdf2)

    if differences:
        create_diff_pdf(differences, output_pdf)
        print(f"Differences found and report generated: {output_pdf}")
    else:
        print("No differences found.")