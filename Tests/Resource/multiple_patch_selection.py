import win32com.client
import sys
 
def spam_multiple_patch_version_select(session, comp_id, search_comp_1, search_patch_1):
    # Convert string representations of lists to actual Python lists
    search_comp = ast.literal_eval(search_comp_1)
    search_patch = ast.literal_eval(search_patch_1)

    # Ensure the lists have the same length
    if not len(search_comp) == len(search_patch):
        print("Error: The lengths of the component list and patch list do not match.")
        sys.exit(1)  # Exit with a status code indicating an error

    # Find the component area using the provided ID
    comp_area = session.FindById(comp_id)
    row_count = comp_area.RowCount

    # Iterate over the component and patch pairs
    for i in range(len(search_comp)):
        comp = search_comp[i]
        patch = search_patch[i]

        try:
            # Search through the rows of the component area
            for x in range(row_count + 1):
                cell_value = comp_area.GetCellValue(x, "COMPONENT")
                if cell_value == comp:
                    # Modify the patch value for the corresponding component
                    comp_area.modifyCell(x, "PATCH_REQ", patch)
        except Exception as e:
            print(f"An error occurred while modifying the cell: {e}")
 
def main():
    sapGuiAuto = win32com.client.GetObject("SAPGUI")
    if not sapGuiAuto:
        raise RuntimeError("Cannot find SAP GUI. Please ensure it is running.")
    application = sapGuiAuto.GetScriptingEngine
    connection = application.Children(0)
    session = connection.Children(0)
   
    comp_id = "wnd[1]/usr/tabsQUEUE_CALC/tabpQUEUE_CALC_FC1/ssubQUEUE_CALC_SCA:SAPLOCS_ALV_UI:0306/cntlCONTROL_ALL_COMP/shellcont/shell"
    search_comp_1 = ["ST-PI",    "BNWVS",    "ST-A/PI"]
    search_patch_1 = ["SAPK-74003INSTPI",    "SAPK-70001INBNWVS",    "SAPKITABC5"]
   
    spam_multiple_patch_version_select(session, comp_id, search_comp_1, search_patch_1)
   
 
if __name__ == "__main__":
    main()