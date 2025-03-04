import pandas as pd
from datetime import datetime
 
# Load the Excel file
file1_path = "C:\\tmp\\GR.XLSX"  
file2_path = "C:\\tmp\\ME2N.XLSX"  
 
# Read Excel files
df_gr = pd.read_excel(file1_path)
df_me2n = pd.read_excel(file2_path)
 
# Ensure column names are stripped of any extra spaces
df_gr.columns = df_gr.columns.str.strip()
 
#Remove all the extra columns
df_me2n.dropna(how="all", inplace=True)
 
df_me2n.columns = ["Purch.Doc.", "Type", "Plnt", "Name 1"]
 
# Drop any unintended unnamed columns
df_me2n = df_me2n.loc[:, ~df_me2n.columns.str.contains("^Unnamed")]
 
# Trim whitespaces from column names and values
df_me2n.columns = df_me2n.columns.str.strip()
df_me2n = df_me2n.map(lambda x: x.strip() if isinstance(x, str) else x)
 
df_me2n = df_me2n.drop_duplicates(subset=["Purch.Doc."], keep="first")
 
df_gr.columns = df_gr.columns.str.strip()
df_gr = df_gr.map(lambda x: x.strip() if isinstance(x, str) else x)
 
# Merge based on "Purchasing Doc." number
df_merged = df_gr.merge(df_me2n, left_on="Purchasing Document", right_on="Purch.Doc.", how="left")
 
# Drop duplicate column if needed
df_merged.drop(columns=["Purch.Doc.", "Document Number", "Company Code", "Plant"], inplace=True)
df_merged.rename(columns={"Type": "PO Type", "Name 1": "Plant Name"}, inplace=True)
 
# Sort by Plant (Plnt)
df_sorted = df_merged.sort_values(by="Plnt")
 
# Save cleaned, merged, and sorted file
output_file = "C:\\tmp\\Merged_GR_IR.xlsx"
df_sorted.to_excel(output_file, index=False)
 
# Generation of Open Invoice documents Report
 
file_clean_path = "C:\\tmp\\Merged_GR_IR.xlsx"  
 
# Read the cleaned Excel file
df_open_gr = pd.read_excel(file_clean_path)
 
# Generation of No Invoice Report comparing to PO Type Threshold days
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
 
# Filter only rows where Document type is "WE"
#df_filtered_gr_we = df_open_gr[df_open_gr["Document type"] == "WE"]
#df_filtered_gr_we.columns = df_filtered_gr_we.columns.str.strip()
 
# Ensure 'Posting Date' is in datetime format
df_open_invoice.loc[:, "Posting Date"] = pd.to_datetime(df_open_invoice["Posting Date"], errors='coerce', dayfirst=True)
 
# Calculate the Days Difference column
df_open_invoice.loc[:, "Days Difference"] = (pd.Timestamp.today() - df_open_invoice["Posting Date"]).dt.days
 
# Merge File1 with PO_Type.xlsx to get the Analysis column
df_merged = df_open_invoice.merge(df_po_type, on="PO Type", how="left")
 
# Save the file with the added Days Difference column for reference
df_merged.to_excel("C:\\tmp\\No_Invoice_Input_With_Days_Difference.xlsx", index=False)
 
# Filter records where Days Difference > Analysis
df_filtered = df_merged[df_merged["Days Difference"] > df_merged["Analysis"]]
 
# Group by 'Plnt' and 'PO Type', count Purch.Doc., and sum Local Crcy Amt
df_report = df_filtered.groupby(["Plnt", "PO Type"]).agg(
    Count_of_Purch_Doc=("Purchasing Document", "count"),
    Sum_of_Local_Crcy_Amt=("Amount in Local Currency", "sum")
).reset_index()
 
# Calculate Grand Total
grand_total = pd.DataFrame([{
    "Plnt": "Grand Total",
    "PO Type": "",
    "Count_of_Purch_Doc": df_report["Count_of_Purch_Doc"].sum(),
    "Sum_of_Local_Crcy_Amt": df_report["Sum_of_Local_Crcy_Amt"].sum()
}])
 
# Append the Grand Total row
df_report = pd.concat([df_report, grand_total], ignore_index=True)
 
# Save the final No Invoice Report
output_file = "C:\\tmp\\No_Invoice_Report_New.xlsx"
df_report.to_excel(output_file, index=False)
 
# Generation of Partial Invoice documents Report
 
file_clean_path = "C:\\tmp\\Merged_GR_IR.xlsx"  
 
# Read the cleaned Excel file
df_gr = pd.read_excel(file_clean_path)
 
# Generation of No Invoice Report comparing to PO Type Threshold days
po_type_path = "C:\\tmp\\PO_Type.xlsx"
df_po_type = pd.read_excel(po_type_path)
 
# Strip column names to avoid mismatches due to spaces
df_po_type.columns = df_po_type.columns.str.strip()
 
# Load your dataframe (assuming it's already loaded as df)
df_filtered = df_gr.groupby("Purchasing Document")["Document type"].apply(lambda x: set(x)).reset_index()
 
# Filter where both "WE" and "RE" are present
df_filtered = df_filtered[df_filtered["Document type"].apply(lambda x: x == {"WE", "RE"})]
 
# Merge with original dataframe to get full details
df_result = df_gr[df_gr["Purchasing Document"].isin(df_filtered["Purchasing Document"])]
df_result = df_result.sort_values(by=["Purchasing Document", "Document type"], ascending=[True, False])
 
# Save the filtered data to a new file
output_file = "C:\\tmp\\Partial_Invoice_Documents.xlsx"
df_result.to_excel(output_file, index=False)
 
# Load the Excel file
partial_invoice_file_path = "C:\\tmp\\Partial_Invoice_Documents.xlsx"
df_partial = pd.read_excel(partial_invoice_file_path)
 
# Count total Purch.Doc. occurrences per Plnt
count_by_plant = df_partial.groupby("Plnt")["Purchasing Document"].count().reset_index()
 
# Rename the column names
count_by_plant.columns = ["Plnt", "Total_Count_Purchase_Doc."]
 
# Add a Grand Total row
grand_total = pd.DataFrame([["Grand Total", count_by_plant["Total_Count_Purchase_Doc."].sum()]], columns=["Plnt", "Total_Count_Purchase_Doc."])
count_by_plant = pd.concat([count_by_plant, grand_total], ignore_index=True)
 
# Save the result to a new Excel file
output_file = "C:\\tmp\\Partial_Invoice_Output.xlsx"
count_by_plant.to_excel(output_file, index=False)

print("Script executed successfully")