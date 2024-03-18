import win32com.client
import time
import re

def verify_the_idoc_jobs(session, table_id, search_text, process_log_btn):
        try:
            control = session.findById(table_id)
            row = control.RowCount
            for i in range(row):
                job_id = f"{table_id}/ctxtDNAST-KSCHL[1,{i}]"
                # print(job_id)
                cell_value = session.findById(job_id).Text
                # print(cell_value)
                if cell_value == search_text:
                    status_id = f"{table_id}/lblDV70A-STATUSICON[0,{i}]"
                    status = session.findById(status_id).tooltip
                    # print(status)
                    if status == "Successfully processed":
                        control.getAbsoluteRow(i).selected = -1
                        session.findById(process_log_btn).press()
                        time.sleep(5)
                        session.findById("wnd[1]").close()
                        break
                    else:
                        print(status)
                        time.sleep(10)
                                        
        except Exception as e:
            return f"Error: {e}"

def main():
    sapGuiAuto = win32com.client.GetObject("SAPGUI")
    
    if not sapGuiAuto:
        raise RuntimeError("Cannot find SAP GUI. Please ensure it is running.")
    
    application = sapGuiAuto.GetScriptingEngine
    connection = application.Children(0)
    session = connection.Children(0)
    table_id = "wnd[0]/usr/tblSAPDV70ATC_NAST3"
    search_text = "ZBA0"
    process_log_btn = "wnd[0]/tbar[1]/btn[26]"
    verify_the_idoc_jobs(session, table_id, search_text, process_log_btn)

if __name__ == "__main__":
    main()
