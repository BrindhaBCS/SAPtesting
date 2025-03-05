import win32com.client
import pandas as pd
import sys
import ast
import  time

def select_layout(session, table_id):
        table = session.findById(table_id)
        row = table.RowCount
        print(row)
        for i in range(row):
            layout_value = table.GetCellValue(i, "TEXT")
            if layout_value == "Contracts - Header":
                table.selectedRows = str(i)
                table.doubleclickCurrentCell
                break
        if layout_value != "Contracts - Header":
            print("No row with 'TEXT' value 'header' found.")

# Simulate the SAP table value retrieval function (you will replace this with the actual logic)
def get_sap_table_value(session, table_id, button_id, search_term):
    table = session.findById(table_id)
    # button = session.findById(button_id)
    row = table.RowCount
    # for j in range(len(search_terms)):
    #     item = search_terms[j]
    try:
        for i in range(row):
            table.currentCellRow = i
            cell_value = table.getCellValue(i, "SELTEXT")
            if cell_value == search_term:
                table.selectedRow = i
                # time.sleep(2)
                # session.sendvkey(7)
                # time.sleep(2)
                # session.sendvkey(7)
    except Exception as e:
                return f"Error: {e}"   

def select_form_header(session, table_id, row, column):
        # table = session.findById(table_id).findByName(name)
        # # table.SelectItem(row, column)
        # table.DoubleClickItem()
        # print(f"Available methods: {dir(table)}")
        # return  data
    session.findById(table_id).selectItem (row,column)
    session.findById(table_id).ensureVisibleHorizontalItem (row,column)
    session.findById(table_id).doubleClickItem (row,column)
    session.findById(table_id).selectItem ("0002",column)
    session.findById(table_id).ensureVisibleHorizontalItem ("0002",column)
    session.findById(table_id).doubleClickItem ("0002",column)
    session.findById(table_id).selectItem ("0003",column)
    session.findById(table_id).ensureVisibleHorizontalItem ("0003",column)
    session.findById(table_id).doubleClickItem ("0003",column)
    
    session.findById(table_id).selectedNode = "0002"
    session.findById(table_id).doubleClickNode ("0002")
    session.findById(table_id).selectedNode = row
    session.findById(table_id).doubleClickNode (row)
    session.findById(table_id).selectedNode = "0003"
    session.findById(table_id).doubleClickNode ("0003")

def get_column_excel_to_text_create(session, excel_path, txt_path, column_name, sheet_name):
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

# def get_lable_value(session, lable_id, area_id):
#         user_area = session.findById(lable_id)
#         item_count = user_area.Children.Count
#         print(item_count)
#         found_elements = []
#         for i in range(13, item_count):
#             full_area_id = f"{area_id},{i}]"
#             print(full_area_id)
#             element = session.findById(full_area_id)
#             text = element.Text
#             print(text)
#             if element.Text.strip() != "Finished":
#                 found_elements.append(element.Text)
#                 text = element.Text
#                 print(f"Job is not in Finished status")
#                 # return("search text is not found")
#         else:
#             print("search text is not found")
#             # return("search text is not found")
#         print(found_elements)
#         return found_elements
 
def get_lable_value(session, lable_id, area_id):
    user_area = session.findById(lable_id)
    item_count = user_area.Children.Count
    found_elements = []
    for i in range(13, item_count):
        full_area_id = f"{area_id},{i}]"
        # print(f"Trying to access: {full_area_id}")
        try:
            element = session.findById(full_area_id)
            if element.Text.strip() != "Finished":
                found_elements.append(element.Text)
                print(f"Job is not in Finished status")
            else:
                print("Job is Finished")
        
        except Exception as e:
            print("Exiting the loop due to missing element.")
            break
    # if not found_elements:
    #     print("All the jobs in finished status")
    # else:
    #     print(f"Found elements: {found_elements}")
    return found_elements


def main():
    sapGuiAuto = win32com.client.GetObject("SAPGUI")
    if not sapGuiAuto:
        raise RuntimeError("Cannot find SAP GUI. Please ensure it is running.")
    application = sapGuiAuto.GetScriptingEngine
    connection = application.Children(0)
    session = connection.Children(0)

    # table_id = "wnd[0]/usr/tabsTABSTRIP_OVERVIEW/tabpKFTE/ssubSUBSCREEN_BODY:SAPLV70T:2100/cntlSPLITTER_CONTAINER/shellcont/shellcont/shell/shellcont[0]/shell"
    # row = "0001"
    # column = "Column1"
    # name = "Form Header"
    # table_id = "wnd[1]/usr/subSUB_CONFIGURATION:SAPLSALV_CUL_LAYOUT_CHOOSE:0500/cntlD500_CONTAINER/shellcont/shell"
    # table_id1 = "wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/cntlCONTAINER1_LAYO/shellcont/shell"
    # button_id = "wnd[1]/usr/tabsG_TS_ALV/tabpALV_M_R1/ssubSUB_CONFIGURATION:SAPLSALV_CUL_COLUMN_SELECTION:0620/btnAPP_WL_SING"
    # search_term = "Sold-To Party Name"
    # select_layout(session, table_id)
    # time.sleep(10)
    # get_sap_table_value(session, table_id1, button_id, search_term)
    # select_form_header(session, table_id, row, column)
    # excel_path = "C:\\tmp\\GRIR_Requirement.xlsx"
    # txt_path = "C:\\tmp\\Purchase_DocumentOnly.txt"
    # column_name = "Purchasing Document"
    # sheet_name = "RE"
    # get_column_excel_to_text_create(excel_path, txt_path, column_name, sheet_name)
    lable_id = "wnd[0]/usr"
    area_id = "wnd[0]/usr/lbl[64"
    get_lable_value(session, lable_id, area_id)
     
if __name__ == "__main__":
    main()