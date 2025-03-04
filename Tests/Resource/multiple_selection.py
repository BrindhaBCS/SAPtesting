import pandas as pd

def get_column_excel_to_text_create(excel_path, txt_path, column_name, sheet_name):
    try:
        df = pd.read_excel(excel_path, dtype=str, sheet_name=sheet_name)
        if column_name not in df.columns:
            print(f"Column '{column_name}' not found in sheet '{sheet_name}'.")
            return
        # values = df[column_name].dropna().astype(int).tolist()
        values = df[column_name].dropna().astype(str).tolist()
        unique_values = sorted(set(values))
        with open(txt_path, "w") as file:
            for item in unique_values:
                file.write(f"{item}\n")
        print("Saved successfully!")
    except Exception as e:
        print(f"An error occurred: {e}")
     
if __name__ == "__main__":
    get_column_excel_to_text_create(excel_path, txt_path, column_name, sheet_name)