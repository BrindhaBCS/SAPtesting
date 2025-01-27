import pythoncom
import win32com.client
import time
from pythoncom import com_error
import robot.libraries.Screenshot as screenshot
import os
from robot.api import logger
import sys
import ast
import re
import glob
import  json
# from docx2pdf import convert
from PIL import Image
# import docx
# from docx import Document
# from docx.enum.table import WD_TABLE_ALIGNMENT
# from docx.shared import Cm, Pt, Mm, Inches
# from docx.enum.section import WD_ORIENT
from openpyxl import load_workbook
import pandas as pd
import  openpyxl
import json
from fpdf import FPDF
from PIL import Image
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC 
from openpyxl import load_workbook 
import shutil
import pandas as pd
import datetime
import os
import csv
from openpyxl import Workbook
import pandas as pd
from openpyxl import load_workbook
from openpyxl.styles import PatternFill


class Report_Library:    
    def __init__(self):
        self.name = "DefaultReport"
    def copy_images(self, source_dir, target_dir):
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
    def remove_rows_before_start_row(self, file_path, sheet_name, start_row):
        start_row = int(start_row)

        workbook = load_workbook(file_path)
        sheet = workbook[sheet_name]
        for _ in range(start_row - 1):  # Start row number is 1-based
            sheet.delete_rows(1)  # Always delete the first row

        workbook.save(file_path)
        workbook.close()
        return f"All rows before row {start_row} have been removed."

    def clean_excel(self, file_path, sheet_name):
        try:
            workbook = load_workbook(file_path)
            if sheet_name not in workbook.sheetnames:
                raise Exception(f"Sheet '{sheet_name}' does not exist in the file.")

            sheet = workbook[sheet_name]
            for row in sheet.iter_rows():
                for cell in row:
                    if cell.value and isinstance(cell.value, str):
                        cell.value = cell.value.strip()  # Remove leading and trailing whitespace

            # Remove completely empty rows (backward iteration to avoid index shift)
            for row_idx in range(sheet.max_row, 0, -1):
                if all(sheet.cell(row=row_idx, column=col_idx).value in [None, ""] for col_idx in range(1, sheet.max_column + 1)):
                    sheet.delete_rows(row_idx)

            # Remove completely empty columns (backward iteration to avoid index shift)
            for col_idx in range(sheet.max_column, 0, -1):
                if all(sheet.cell(row=row_idx, column=col_idx).value in [None, ""] for row_idx in range(1, sheet.max_row + 1)):
                    sheet.delete_cols(col_idx)

            # Save changes back to the file
            workbook.save(file_path)
            print("\033[92m❗ Excel sheet cleaned successfully and saved at:", file_path)  # Green exclamation mark

        except Exception as e:
            print("\033[92m❗ Failed to clean Excel sheet:", str(e))  # Green exclamation mark

    def fiori_html_report(self, excel_file, html_file, highlight_text):
        df = pd.read_excel(excel_file)

        # Initialize counters
        pass_count = 0
        warn_count = 0
        for index, row in df.iterrows():
            row_text = " ".join(row.astype(str).tolist())
            if 'Authorization check successful' in row_text:
                pass_count += 1
            if 'No authorization in user master record' in row_text:
                warn_count += 1

        current_time = datetime.datetime.utcnow().strftime('%d-%m-%Y Time: %H:%M:%S UTC')

        #HTML
        html_content = f"""
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Fiori LaunchPad Report</title>
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 0;
                    background-color: #f4f4f4;
                }}
                .container {{
                    width: 90%;
                    margin: 30px auto;
                    padding: 20px;
                    background-color: #ffffff;
                    border-radius: 8px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                }}
                h1 {{
                    color: #1f3a64;
                    text-align: center;
                }}
                .count-box {{
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    gap: 20px;
                    margin: 20px 0;
                }}
                .count-item {{
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    font-size: 18px;
                }}
                .pass-circle {{
                    display: inline-block;
                    width: 15px;
                    height: 15px;
                    background-color: green;
                    border-radius: 50%;
                    margin-right: 8px; /* Adds spacing between the circle and text */
                }}
                .warn-circle {{
                    display: inline-block;
                    width: 15px;
                    height: 15px;
                    background-color: red;
                    border-radius: 50%;
                    margin-right: 8px; /* Adds spacing between the circle and text */
                }}

                table {{
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }}
                th, td {{
                    padding: 12px;
                    text-align: left;
                    border: 1px solid #ddd;
                }}
                th {{
                    background-color: #1f3a64;
                    color: white;
                }}
                td {{
                    background-color: #fafafa;
                }}
                table tr:nth-child(even) td {{
                    background-color: #f2f2f2;
                }}
                table tr:hover td {{
                    background-color: #e9e9e9;
                }}
                .row-green {{
                    background-color: #d4edda;
                    color: green;
                }}
                .row-red {{
                    background-color: #ff0000 ;
                    color:red ;
                }}
            </style>
        </head>
        <body>

        <div class="container">
            <h1>Fiori LaunchPad Report</h1>
                <div class="count-box">
                    <div class="count-item">
                        <span class="pass-circle"></span> Authorization Count: <span>{pass_count}</span>
                    </div>
                    <div class="count-item">
                        <span class="warn-circle"></span> No Authorization Count: <span>{warn_count}</span>
                    </div>
                    <div class="count-item">
                        Generated At: <span>{current_time}</span>
                    </div>
                </div>
            <table>
                <thead>
                    <tr>
        """

        # Add table headers (columns from DataFrame)
        headers = df.columns.tolist()
        for header in headers:
            html_content += f"<th>{header}</th>"

        html_content += """
                    </tr>
                </thead>
                <tbody>
        """

        # Add table rows (data from DataFrame)
        for index, row in df.iterrows():
            # Check if the target text is in any cell of the row
            if row.astype(str).str.contains(highlight_text, case=False).any():
                html_content += '<tr class="row-red">'  
            else:
                html_content += '<tr class="row-green">'  

            for value in row:
                html_content += f"<td>{value}</td>"

            html_content += "</tr>"

        html_content += """
                </tbody>
            </table>
        </div>

        </body>
        </html>
        """

        with open(html_file, "w") as file:
            file.write(html_content)

        print(f"HTML report created successfully: {html_file}")

    def sarole_html_report(self, excel_file, html_file, highlight_text):
        df = pd.read_excel(excel_file)

        # Initialize counters
        pass_count = 0
        warn_count = 0
        for index, row in df.iterrows():
            row_text = " ".join(row.astype(str).tolist())
            if 'Authorization check successful' in row_text:
                pass_count += 1
            if 'No authorization in user master record' in row_text:
                warn_count += 1

        current_time = datetime.datetime.utcnow().strftime('%d-%m-%Y Time: %H:%M:%S UTC')

        #HTML
        html_content = f"""
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Security Authorization Report</title>
            <style>
                body {{
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 0;
                    background-color: #f4f4f4;
                }}
                .container {{
                    width: 90%;
                    margin: 30px auto;
                    padding: 20px;
                    background-color: #ffffff;
                    border-radius: 8px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                }}
                h1 {{
                    color: #1f3a64;
                    text-align: center;
                }}
                .count-box {{
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    gap: 20px;
                    margin: 20px 0;
                }}
                .count-item {{
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    font-size: 18px;
                }}
                .pass-circle {{
                    display: inline-block;
                    width: 15px;
                    height: 15px;
                    background-color: green;
                    border-radius: 50%;
                    margin-right: 8px; /* Adds spacing between the circle and text */
                }}
                .warn-circle {{
                    display: inline-block;
                    width: 15px;
                    height: 15px;
                    background-color: red;
                    border-radius: 50%;
                    margin-right: 8px; /* Adds spacing between the circle and text */
                }}

                table {{
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }}
                th, td {{
                    padding: 12px;
                    text-align: left;
                    border: 1px solid #ddd;
                }}
                th {{
                    background-color: #1f3a64;
                    color: white;
                }}
                td {{
                    background-color: #fafafa;
                }}
                table tr:nth-child(even) td {{
                    background-color: #f2f2f2;
                }}
                table tr:hover td {{
                    background-color: #e9e9e9;
                }}
                .row-green {{
                    background-color: #d4edda;
                    color: green;
                }}
                .row-red {{
                    background-color: #ff0000 ;
                    color:red ;
                }}
            </style>
        </head>
        <body>

        <div class="container">
            <h1>Security Authorization Report</h1>
                <div class="count-box">
                    <div class="count-item">
                        <span class="pass-circle"></span> Authorization Count: <span>{pass_count}</span>
                    </div>
                    <div class="count-item">
                        <span class="warn-circle"></span> No Authorization Count: <span>{warn_count}</span>
                    </div>
                    <div class="count-item">
                        Generated At: <span>{current_time}</span>
                    </div>
                </div>
            <table>
                <thead>
                    <tr>
        """

        # Add table headers (columns from DataFrame)
        headers = df.columns.tolist()
        for header in headers:
            html_content += f"<th>{header}</th>"

        html_content += """
                    </tr>
                </thead>
                <tbody>
        """

        # Add table rows (data from DataFrame)
        for index, row in df.iterrows():
            # Check if the target text is in any cell of the row
            if row.astype(str).str.contains(highlight_text, case=False).any():
                html_content += '<tr class="row-red">'  
            else:
                html_content += '<tr class="row-green">'  

            for value in row:
                html_content += f"<td>{value}</td>"

            html_content += "</tr>"

        html_content += """
                </tbody>
            </table>
        </div>

        </body>
        </html>
        """

        with open(html_file, "w") as file:
            file.write(html_content)
        print(f"HTML report created successfully: {html_file}")

    def convert_csv_to_xlsx(self, csv_file, xlsx_file):
        # Read the CSV and write to XLSX
        data = pd.read_csv(csv_file)
        data.to_excel(xlsx_file, index=False)
        print(f"File converted successfully! Saved as '{xlsx_file}'.")


    def cop_webexcel_scrap(self, file_path, output_file):
        # Create a new Workbook
        wb = Workbook()
        ws = wb.active
        ws.title = "Extracted Data"
        with open(file_path, mode='r') as file:
            reader = csv.reader(file)
            row_number = 1
            for row in reader:
                data = row[0]
                if "Number" in data or not data.strip():
                    continue
                split_data = data.split(";")
                if len(split_data) > 1:
                    number = split_data[1]
                    ws[f'A{row_number}'] = number
                    row_number += 1
                ws['A1'] = "Snote Value"
        wb.save(output_file)
        print(f"Extracted data has been saved to {output_file}")

   

    def cop_sapexcel_scrap(self, input_file, output_file):
        df = pd.read_excel(input_file)
        wb = load_workbook(output_file)
        ws = wb.active 
        ws['B1'] = "NUMM"
        ws['C1'] = "PRSTATUS"
        row_number = 2
        for index, row in df.iterrows():
            col2_data = row[0]  # Column 2 (index 1 )
            col9_data = row[2]  # Column 9 (index 8)
            if pd.isna(col2_data) or pd.isna(col9_data) or "NUMM" in str(col2_data) or "PRSTATUS" in str(col2_data) or str(col2_data).strip() == '' or str(col9_data).strip() == '':
                continue
            col2_data = str(col2_data).lstrip('0')
            if col2_data.startswith('000'):
                col2_data = col2_data[3:]
            col9_data = str(col9_data).lstrip('0')
            if col9_data.startswith('000'):
                col9_data = col9_data[3:]
            ws[f'B{row_number}'] = col2_data
            ws[f'C{row_number}'] = col9_data
            row_number += 1
        wb.save(output_file)
        print(f"Data from columns 2 and 9 of {input_file} (with first three zeros removed) has been saved to columns 2 and 3 of {output_file}")

  

    def cop_excel_compare(self, file_path, output_file):
        df = pd.read_excel(file_path)
        df.columns = df.columns.str.strip()
        print("Column Names:", df.columns)
        required_columns = ['Snote Value', 'NUMM', 'PRSTATUS']
        if all(col in df.columns for col in required_columns):
            matched_data = []
            for a_value in df['Snote Value'].dropna():
                if a_value in df['NUMM'].values:
                    matching_row = df[df['NUMM'] == a_value]
                    prstatus = matching_row['PRSTATUS'].iloc[0]
                    matched_data.append([a_value, a_value, prstatus]) 

            matched_df = pd.DataFrame(matched_data, columns=['WEB Data', 'SAP Snote', 'PRSTATUS'])
            def map_status(prstatus):
                if prstatus == '-':
                    return "Cannot be implemented"
                elif prstatus in ['U', 'u']:
                    return "Incompletely implemented"
                elif prstatus in ['E', 'e']:
                    return "Completely implemented"
                elif prstatus in ['N', 'n', None, '']:
                    return "Not yet implemented"
                else:
                    return "Unknown Status"

            matched_df['Status Message'] = matched_df['PRSTATUS'].apply(map_status)
            matched_df.to_excel(output_file, index=False)

            wb = load_workbook(output_file)
            ws = wb.active

            # color
            blue_fill = PatternFill(start_color="ADD8E6", end_color="ADD8E6", fill_type="solid")
            red_fill = PatternFill(start_color="FF0000", end_color="FF0000", fill_type="solid")
            green_fill = PatternFill(start_color="00FF00", end_color="00FF00", fill_type="solid")

            for row in range(2, len(matched_df) + 2):
                prstatus_value = ws[f'C{row}'].value
                if prstatus_value == '-':
                    for col in range(1, len(matched_df.columns) + 1):
                        ws.cell(row=row, column=col).fill = blue_fill
                elif prstatus_value in ['U', 'u']:
                    for col in range(1, len(matched_df.columns) + 1):
                        ws.cell(row=row, column=col).fill = red_fill
                elif prstatus_value in ['E', 'e']:
                    for col in range(1, len(matched_df.columns) + 1):
                        ws.cell(row=row, column=col).fill = green_fill
                elif prstatus_value in ['N', 'n', None, '']:
                    for col in range(1, len(matched_df.columns) + 1):
                        ws.cell(row=row, column=col).fill = red_fill
            wb.save(output_file)

            print("Comparison complete. Results saved to output_data_matched.xlsx with status messages and formatting applied.")
        else:
            print("Error: The required columns 'Snote Value', 'NUMM', or 'PRSTATUS' are missing from the Excel file.")