import pandas as pd
from datetime import datetime
 
# Load the Excel file
file1_path = "C:\\tmp\\GR.XLSX"  
file2_path = "C:\\tmp\\ME2N.XLSX"  
 
# Read Excel files
df_gr = pd.read_excel(file1_path)
df_me2n = pd.read_excel(file2_path)
 
print("Loaded the GR and ME2N files from the SAP\n")
 
# Ensure column names are stripped of any extra spaces
df_gr.columns = df_gr.columns.str.strip()
 
#Remove all the extra columns
df_me2n.dropna(how="all", inplace=True)
 
df_me2n.columns = ["Purchasing Document", "Plant", "Purchasing Doc. Type", "Name 1"]
df_me2n.columns = ["Purchasing Document", "Plant", "Purchasing Doc. Type", "Name 1"]
 
# Drop any unintended unnamed columns
#df_me2n = df_me2n.loc[:, ~df_me2n.columns.str.contains("^Unnamed")]
#df_me2n = df_me2n.loc[:, ~df_me2n.columns.str.contains("^Unnamed")]
 
# Trim whitespaces from column names and values
df_me2n.columns = df_me2n.columns.str.strip()
df_me2n = df_me2n.map(lambda x: x.strip() if isinstance(x, str) else x)
 
df_me2n = df_me2n.drop_duplicates(subset=["Purchasing Document"], keep="first")
df_me2n = df_me2n.drop_duplicates(subset=["Purchasing Document"], keep="first")
 
df_gr.columns = df_gr.columns.str.strip()
df_gr = df_gr.map(lambda x: x.strip() if isinstance(x, str) else x)
 
# Merge based on "Purchasing Doc." number
df_merged = df_gr.merge(df_me2n, left_on="Purchasing Document", right_on="Purchasing Document", how="left")
df_merged = df_gr.merge(df_me2n, left_on="Purchasing Document", right_on="Purchasing Document", how="left")
 
# Drop duplicate column if needed
df_merged.drop(columns=["Document Number", "Company Code"], inplace=True)
df_merged.rename(columns={"Purchasing Doc. Type": "PO Type", "Name 1": "Plant Name", "Plant_x": "Plant"}, inplace=True)
 
print("Merged GR file and ME2N file ON Purchasing Document Number\n")
 
# Sort by Plant (Plnt)
#df_sorted = df_merged.sort_values(by="Plnt")
#df_sorted = df_merged.sort_values(by="Plnt")
 
# Save cleaned, merged, and sorted file
output_file = "C:\\tmp\\Merged_GR_IR.xlsx"
#df_sorted.to_excel(output_file, index=False)
df_merged.to_excel(output_file, index=False)
#df_sorted.to_excel(output_file, index=False)
df_merged.to_excel(output_file, index=False)
 
# Generation of Open Invoice documents Report
 
file_clean_path = "C:\\tmp\\Merged_GR_IR.xlsx"  
 
# Read the cleaned Excel file
df_open_gr = pd.read_excel(file_clean_path)
 
# Generation of No Invoice Report comparing to PO Type Threshold days
print("Generation of Open Invoice Report started\n")
po_type_path = "C:\\tmp\\PO_Type.xlsx"
df_po_type = pd.read_excel(po_type_path)
 
# Strip column names to avoid mismatches due to spaces
df_po_type.columns = df_po_type.columns.str.strip()
 
# Identify POs that have RE
po_with_re = df_open_gr[df_open_gr["Document type"] == "RE"]["Purchasing Document"].unique()
 
# Filter for WE document types
df_we = df_open_gr[df_open_gr["Document type"] == "WE"]
 
# Remove POs that have RE from Open Invoice report
df_open_invoice = df_we[~df_we["Purchasing Document"].isin(po_with_re)]
 
# Save Open Invoice Report
df_open_invoice.to_excel("Open_Invoice_Report2.xlsx", index=False)
 
# Ensure 'Posting Date' is in datetime format
df_open_invoice.loc[:, "Posting Date"] = pd.to_datetime(df_open_invoice["Posting Date"], errors='coerce', dayfirst=True)
 
# Calculate the Days Difference column
df_open_invoice = df_open_invoice.copy()  # Make a copy to avoid SettingWithCopyWarning
df_open_invoice = df_open_invoice.copy()  # Make a copy to avoid SettingWithCopyWarning
df_open_invoice.loc[:, "Days Difference"] = (pd.Timestamp.today() - df_open_invoice["Posting Date"]).dt.days
#df_open_invoice.loc[:, "Days Difference"] = (pd.Timestamp.today() - df_open_invoice["Posting Date"]).dt.days
print("Calculated the days difference for invoice processing(Current date - Posting Date)\n")
 
# Merge File1 with PO_Type.xlsx to get the Analysis column
df_merged = df_open_invoice.merge(df_po_type, on="PO Type", how="left")
 
# Save the file with the added Days Difference column for reference
df_merged.to_excel("C:\\tmp\\No_Invoice_Input_With_Days_Difference.xlsx", index=False)
 
# Filter records where Days Difference > Analysis
df_filtered = df_merged[df_merged["Days Difference"] > df_merged["Analysis"]]
print("Filter only the records which has the days difference greater than the threshold days\n")
 
# Group by 'Plnt' and 'PO Type', count Purch.Doc., and sum Local Crcy Amt
df_report = df_filtered.groupby(["Plant", "PO Type", "Plant Name"]).agg(
df_report = df_filtered.groupby(["Plant", "PO Type", "Plant Name"]).agg(
    Count_of_Purch_Doc=("Purchasing Document", "count"),
    Sum_of_Local_Crcy_Amt=("Amount in Local Currency", "sum")
).reset_index()
 
# Convert 'Sum_of_Local_Crcy_Amt' to lakhs
df_report["Sum_of_Local_Crcy_Amt_Lakhs"] = round(df_report["Sum_of_Local_Crcy_Amt"] / 100000, 2)
 
# Calculate Grand Total
grand_total = pd.DataFrame([{
    "Plant": "Grand Total",
    "Plant": "Grand Total",
    "PO Type": "",
    "Plant Name": "",
    "Plant Name": "",
    "Count_of_Purch_Doc": df_report["Count_of_Purch_Doc"].sum(),
    "Sum_of_Local_Crcy_Amt": df_report["Sum_of_Local_Crcy_Amt"].sum(),
    "Sum_of_Local_Crcy_Amt_Lakhs": round(df_report["Sum_of_Local_Crcy_Amt"].sum() / 100000, 2)
    "Sum_of_Local_Crcy_Amt": df_report["Sum_of_Local_Crcy_Amt"].sum(),
    "Sum_of_Local_Crcy_Amt_Lakhs": round(df_report["Sum_of_Local_Crcy_Amt"].sum() / 100000, 2)
}])
print("Calculated the grand total of local currency amount\n")
 
# Append the Grand Total row
df_report = pd.concat([df_report, grand_total], ignore_index=True)
 
# Save the final No Invoice Report
output_file = "C:\\tmp\\Open_Invoice_Report.xlsx"
output_file = "C:\\tmp\\Open_Invoice_Report.xlsx"
df_report.to_excel(output_file, index=False)
print("Generation of Open Invoice Report completed\n")
 
# Generation of Partial Invoice documents Report
 
file_clean_path = "C:\\tmp\\Merged_GR_IR.xlsx"  
 
# Read the cleaned Excel file
df_gr = pd.read_excel(file_clean_path)
 
print("Generation of Partial Invoice Report started\n")
 
# Generation of No Invoice Report comparing to PO Type Threshold days
po_type_path = "C:\\tmp\\PO_Type.xlsx"
df_po_type = pd.read_excel(po_type_path)
 
# Strip column names to avoid mismatches due to spaces
df_po_type.columns = df_po_type.columns.str.strip()
 
# Group by 'Purchasing Document' and collect unique 'Document type' values  
df_filtered = df_gr.groupby("Purchasing Document")["Document type"].apply(set).reset_index()  
 
# Filter to keep only those documents that have exactly {"WE", "RE"}  
df_filtered = df_filtered[df_filtered["Document type"] == {"WE", "RE"}]  
 
# Merge to retain full details from the original dataset  
df_result = df_gr[df_gr["Purchasing Document"].isin(df_filtered["Purchasing Document"])]
 
# Sum the amounts per Purchasing Document and filter out those with a sum of 0  
sum_check = df_result.groupby("Purchasing Document")["Amount in Local Currency"].sum().reset_index()  
valid_docs = sum_check[sum_check["Amount in Local Currency"] != 0]["Purchasing Document"]  
 
# Keep only those Purchasing Documents where the sum is not zero  
df_result = df_result[df_result["Purchasing Document"].isin(valid_docs)]
 
# Drop duplicates to ensure only one 'WE' and one 'RE' per document  
df_result = df_result.drop_duplicates(subset=["Purchasing Document", "Document type"])  
 
# Sort the result  
df_result = df_result.sort_values(by=["Purchasing Document", "Document type"], ascending=[True, False])
 
# Save the filtered data to a new file
output_file = "C:\\tmp\\Partial_Invoice_Documents.xlsx"
df_result.to_excel(output_file, index=False)
 
# Load the Excel file
partial_invoice_file_path = "C:\\tmp\\Partial_Invoice_Documents.xlsx"
df_partial = pd.read_excel(partial_invoice_file_path)
 
# Count total Purch.Doc. occurrences per Plnt
count_by_plant = df_partial.groupby("Plant")["Purchasing Document"].nunique().reset_index()
count_by_plant = df_partial.groupby("Plant")["Purchasing Document"].nunique().reset_index()
 
# Rename the column names
count_by_plant.columns = ["Plant", "Total_Count_Purchase_Doc."]
count_by_plant.columns = ["Plant", "Total_Count_Purchase_Doc."]
 
# Add a Grand Total row
grand_total = pd.DataFrame([["Grand Total", count_by_plant["Total_Count_Purchase_Doc."].sum()]], columns=["Plant", "Total_Count_Purchase_Doc."])
grand_total = pd.DataFrame([["Grand Total", count_by_plant["Total_Count_Purchase_Doc."].sum()]], columns=["Plant", "Total_Count_Purchase_Doc."])
count_by_plant = pd.concat([count_by_plant, grand_total], ignore_index=True)
 
# Save the result to a new Excel file
output_file = "C:\\tmp\\Partial_Invoice_Output.xlsx"
count_by_plant.to_excel(output_file, index=False)
print("Generation of Partial Invoice Report completed\n")
print("Script executed successfully")