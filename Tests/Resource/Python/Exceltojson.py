import pandas as pd
import sys
import json
import os

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

def delete_files(files):
    for file in files:
        try:
            os.remove(file)
            print(f"Deleted file: {file}")
        except Exception as e:
            print(f"Error deleting file {file}: {e}")

def main():
  excel_file = sys.argv[1]
  json_file = sys.argv[2]

  excel_to_json(excel_file, json_file)
  data = read_json(json_file)
  print(f"##gbStart##copilot_key##splitKeyValue##{data}##splitKeyValue##object##gbEnd##")

  # Delete the files
  delete_files([excel_file, json_file])
if __name__ == '__main__':
    main()