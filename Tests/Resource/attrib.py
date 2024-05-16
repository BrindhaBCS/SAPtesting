import win32com.client

def print_control_attributes(session, control_id):
    try:
        control = session.findById(control_id)
        print(f"Attributes of control {control_id}:")
        
        # Get attributes
        print(f"Text: {control.Text}")
        print(f"Tooltip: {control.ToolTip}")
        print(f"ID: {control.ID}")
        print(f"Type: {control.Type}")
        print(f"Name: {control.Name}")
        print(f"IsEnabled: {control.IsEnabled}")
        print(f"IsVisible: {control.IsVisible}")
        print(f"Left: {control.Left}")
        print(f"Top: {control.Top}")
        print(f"Width: {control.Width}")
        print(f"Height: {control.Height}")
        print(f"AbsoluteLeft: {control.AbsoluteLeft}")
        print(f"AbsoluteTop: {control.AbsoluteTop}")

    except Exception as e:
        print(f"Error: {e}")

# Example usage
sapGuiAuto = win32com.client.GetObject("SAPGUI")
application = sapGuiAuto.GetScriptingEngine
connection = application.Children(0)
session = connection.Children(0)

control_id = "wnd[1]/usr"  # Replace with your control ID
print_control_attributes(session, control_id)
