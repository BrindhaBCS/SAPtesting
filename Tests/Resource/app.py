import json
import numpy as np

def convert_json_to_string(data):
    # Convert the JSON object to a string
    value = json.dumps(data, indent=4)
    print(value)
    return value
    # return json.dumps(data, indent=4)
# import pandas as pd
# import numpy as np
# from openpyxl import load_workbook

# def excel_to_json(self, excel_file, json_file):
#         df = pd.read_excel(excel_file, engine='openpyxl')
#         for column in df.select_dtypes(['datetime']):
#             df[column] = df[column].astype(str)
#         data = df.to_dict(orient='records')
#         with open(json_file, 'w', encoding='utf-8') as f:
#             json.dump(data, f, ensure_ascii=False, indent=4)
#         with open(json_file, 'r', encoding='utf-8') as f:
#             json_data = json.load(f)
#         return json_data

# def process_excel(self, file_path, sheet_name, column_index=None):
#     df = pd.read_excel(file_path, sheet_name=sheet_name, header=None)
#     if column_index is not None:
#         try:
#             column_index = int(column_index)  # Ensure column_index is an integer
#         except ValueError:
#             print("Invalid column index provided. Please provide a valid integer.")
#             return
#         if 0 <= column_index < df.shape[1]:
#             df.drop(df.columns[column_index], axis=1, inplace=True)
#         else:
#             print(f"Column index {column_index} is out of bounds.")
#             return
#     df = df.applymap(lambda x: x.strip() if isinstance(x, str) else x)
#     df.dropna(how='all', inplace=True)
#     df.dropna(axis=1, how='all', inplace=True)
#     if df.iloc[0].isnull().all(): 
#         new_header = df.iloc[1]  
#         df = df[2:]  # Remove first two rows
#     else:
#         new_header = df.iloc[0]  # Use first row as header
#         df = df[1:]  # Remove first row
#     df.columns = new_header
#     df.reset_index(drop=True, inplace=True)
#     try:
#         # Write the modified DataFrame back to the Excel file
#         with pd.ExcelWriter(file_path, engine='openpyxl', mode='w') as writer:
#             df.to_excel(writer, index=False, sheet_name=sheet_name)
#         print(f"Processed Excel sheet '{sheet_name}' has been updated in: {file_path}")
#     except Exception as e:
#         print(f"Error writing to Excel: {e}")

# def convert_nan(data):
#     for entry in data:
#         for key, value in entry.items():
#             if value == 'nan':  
#                 entry[key] = np.nan
#             elif value is None:  
#                 entry[key] = np.nan
#     return data

# def convert_to_string(data):
#     for entry in data:
#         for key, value in entry.items():
#             if pd.isna(value):
#                 entry[key] = 'null'  
#             else:
#                 entry[key] = str(value)
#     return data

# def excel_to_string(data):
#     # df = pd.read_excel(file_path, sheet_name=sheet_name, engine='openpyxl')
#     # df_string = df.to_string(index=False)
    
#     # return df_string
#     for entry in data:
#         if isinstance(entry['Billing Block Description'], float) and entry['Billing Block Description'] != entry['Billing Block Description']:  # check for nan
#             entry['Billing Block Description'] = None

# # Example usage
# # file_path = 'C:\EID_Parry\Rental_output.xlsx'  # Path to your Excel file
# # sheet_name = 'Sheet1'  # Name of the sheet you want to convert

# # excel_string = excel_to_string(file_path, sheet_name)
# # print(excel_string)


data = [{'Customer Reference (Header)': 'Demo - Rental Contra', 'Document Date': '2024-12-04', 'Sales document': '"40026213"', 'Net Value (Header)': 940.94, 'Document Currency': 'INR', 'Created by': 'BCSSUPPORT1', 'Sold-To Party Name': 'PARRY AGRO INDUSTRIES LTD', 'Billing Block Description': 'empty', 'Invoice Details': 'Document 707326183 has been saved.'}, {'Customer Reference (Header)': 'Demo - Rental Contra', 'Document Date': '2024-12-04', 'Sales document': '"40026214"', 'Net Value (Header)': 940.94, 'Document Currency': 'INR', 'Created by': 'BCSSUPPORT1', 'Sold-To Party Name': 'PARRY AGRO INDUSTRIES LTD', 'Billing Block Description': 'empty', 'Invoice Details': 'Document 707326184 has been saved.'}]
# excel_to_string(data)
# data_with_nan = convert_nan(data)
# result = convert_to_string(data_with_nan)
# print(result)
convert_json_to_string(data)