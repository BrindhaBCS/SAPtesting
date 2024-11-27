*** Settings ***
Library    PVH_ImageComparison.py

*** Keywords ***
Compare
    compare pdfs and generate report    pdf1_path=${symvar('Pre_PDF_PATH')}     pdf2_path=${symvar('Post_PDF_PATH')}    output_pdf=${symvar('Target_PDF_PATH')}
    Sleep    3