from pythoncom import com_error
import robot.libraries.Screenshot as screenshot
import os
from robot.api import logger
import  json
from PIL import Image
import pandas as pd
import json
from fpdf import FPDF
from PIL import Image
from openpyxl import load_workbook 
import shutil
import pandas as pd
import datetime
from collections import defaultdict

import qrcode
from io import BytesIO
import base64
import json


class Replay_Library:    
    def __init__(self):
        self.name = "DefaultReport"
    def copy_images(self, source_dir, target_dir):
        # Ensure the target directory exists
        if not os.path.exists(target_dir):
            os.makedirs(target_dir)                       
        image_formats = ('.jpeg', '.jpg', '.png', '.gif', '.bmp', '.tiff', '.webp')
        for file_name in os.listdir(source_dir):
            file_path = os.path.join(source_dir, file_name)
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
            for row_idx in range(sheet.max_row, 0, -1):
                if all(sheet.cell(row=row_idx, column=col_idx).value in [None, ""] for col_idx in range(1, sheet.max_column + 1)):
                    sheet.delete_rows(row_idx)
            for col_idx in range(sheet.max_column, 0, -1):
                if all(sheet.cell(row=row_idx, column=col_idx).value in [None, ""] for row_idx in range(1, sheet.max_row + 1)):
                    sheet.delete_cols(col_idx)
            workbook.save(file_path)
            print("\033[92m❗ Excel sheet cleaned successfully and saved at:", file_path)
        except Exception as e:
            print("\033[92m❗ Failed to clean Excel sheet:", str(e))

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
    def excel_remove_multiple_columns(self, file_path, col_indices):
        col_indices = sorted([int(col) for col in col_indices if int(col) > 0], reverse=True)
        workbook = load_workbook(file_path)
        sheet = workbook.active  # Uses the first sheet by default
        for col in col_indices:
            sheet.delete_cols(col)  # Deletes the specified columns
        for col in sheet.columns:
            max_length = 0
            column = col[0].column_letter  # Get the column name
            for cell in col:
                try:
                    if len(str(cell.value)) > max_length:
                        max_length = len(cell.value)
                except:
                    pass
            adjusted_width = (max_length + 2)  # Add some padding
            sheet.column_dimensions[column].width = adjusted_width
        for cell in sheet[1]:
            cell.font = cell.font.copy(bold=True)
            cell.alignment = cell.alignment.copy(horizontal='center')
        for row in sheet.iter_rows(min_row=sheet.max_row, min_col=1, max_col=sheet.max_column):
            if all(cell.value is None for cell in row):
                sheet.delete_rows(row[0].row)
        workbook.save(file_path)
        workbook.close()
        return f"Columns {', '.join(map(str, col_indices))} have been removed and formatting applied."
    def object_stcode_filter(self, file_path):
        df = pd.read_excel(file_path, dtype=str)
        filtered_df = df[df["Object"].str.contains("S_TCODE", na=False)]
        print(filtered_df)
        filtered_df.to_excel(file_path, index=False, engine='openpyxl')
        print("Filtered rows saved successfully.")
        
    def generate_list_to_json(self, numbers):
        return json.dumps({f"Delivery_{i}": num for i, num in enumerate(numbers)}, indent=2)

    def inbounddelivery_json(self, file_path):
        deliveries = defaultdict(list)
        current_delivery = None
        with open(file_path, "r") as file:
            for line in file:
                line = line.strip()
                if line.startswith("Inbounddelivery:"):
                    current_delivery = line.split(":")[1]
                elif line.startswith("Item:"):
                    item = {
                        "Item": line.split(":")[1],
                        "Material": next(file).strip().split(":")[1],
                        "DeliveryQuantity": next(file).strip().split(":")[1],
                        "SU": next(file).strip().split(":")[1]
                    }
                    deliveries[current_delivery].append(item)
        json_output = [{"InboundDelivery": key, "TotalItems": value} for key, value in deliveries.items()]
        return json.dumps(json_output, indent=2)
    
    def binallocation_json(self, file_path):
        with open(file_path, "r") as file:
            lines = file.readlines()
        data = []
        current_delivery = None
        for line in lines:
            line = line.strip()
            if line.startswith("InboundDelivery:"):
                if current_delivery:
                    data.append(current_delivery)
                current_delivery = {
                    "InboundDelivery": line.split(":")[1],
                    "VehicleNumber": "",
                    "WarehouseTasks": []
                }
            elif line.startswith("VehicleNumber:"):
                current_delivery["VehicleNumber"] = line.split(":")[1]
            elif line.startswith("WarehousetaskNumber:"):
                task = {
                    "WarehouseTaskNumber": line.split(":")[1],
                    "SourceBin": "",
                    "DestBin": ""
                }
            elif line.startswith("Sourcebin:"):
                task["SourceBin"] = line.split(":")[1]
            elif line.startswith("Destbin:"):
                task["DestBin"] = line.split(":")[1]
                current_delivery["WarehouseTasks"].append(task)
        if current_delivery:
            data.append(current_delivery)
        return json.dumps(data, indent=2)
    
    def generate_qr_json(self,file_path):
        with open(file_path, "r", encoding="utf-8") as file:
            lines = file.read().strip().split("\n")
        deliveries = {}
        current_delivery = None
        for line in lines:
            key, value = line.split(":", 1)
            key, value = key.strip(), value.strip()
            if key == "Inbounddelivery":
                current_delivery = value
                if current_delivery not in deliveries:
                    deliveries[current_delivery] = []
            else:
                if deliveries and current_delivery:
                    if key == "Material":
                        deliveries[current_delivery].append({
                            "Material": value,
                            "DeliveryQuantity": None,
                            "WarehousetaskNumber": None,
                            "Sourcebin": None,
                            "Destbin": None
                        })
                    elif deliveries[current_delivery] and key in ["DeliveryQuantity", "WarehousetaskNumber", "Sourcebin", "Destbin"]:
                        deliveries[current_delivery][-1][key] = int(value) if key in ["DeliveryQuantity", "WarehousetaskNumber"] else value
        structured_data = {
            "InboundDelivery": list(deliveries.keys())[0],  
            "Details": deliveries[list(deliveries.keys())[0]]
        }
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=5,
            border=2,
        )
        qr_data = json.dumps(structured_data, indent=4)
        qr.add_data(qr_data)
        qr.make(fit=True)
        img = qr.make_image(fill="black", back_color="white")
        buffered = BytesIO()
        img.save(buffered, format="PNG")
        img_base64 = base64.b64encode(buffered.getvalue()).decode()
        qr_json = json.dumps({
            "qr_code": img_base64,
            "format": "png",
            "data": structured_data
        }, indent=4)
        return qr_json