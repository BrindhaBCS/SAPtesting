import pandas as pd
import json

def excel_to_json(excel_file, json_file):
    # Read the Excel file
    df = pd.read_excel(excel_file, engine='openpyxl')

    # Convert Timestamp objects to strings
    for column in df.select_dtypes(['datetime']):
        df[column] = df[column].astype(str)
    
    # Convert the DataFrame to a dictionary
    data = df.to_dict(orient='records')
    
    # Write the dictionary to a JSON file
    with open(json_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

def read_json(json_file):
    # Open and read the JSON file
    with open(json_file, 'r', encoding='utf-8') as f:
        data = json.load(f)
    return data

# Example usage
excel_file = r'C:\tmp\payments.xlsx'  # Replace with your Excel file path
json_file = r'C:\tmp\Json\payments.json'  # Replace with your desired JSON file path
excel_to_json(excel_file, json_file)
data = read_json(json_file)
print(f"##gbStart##Key##splitKeyValue##{data}##splitKeyValue##object##gbEnd##")