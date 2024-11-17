import time
from pywinauto import Application, keyboard

# Create a global instance of TallyLibrary
class TallyLibrary:
    def __init__(self):
        self.app = None
        self.main_window = None

    def start_and_track_tally_session(self, executable_path):
        """Start a Tally session and return its main window based on process ID."""
        self.app = Application().start(executable_path)
        process_id = self.app.process
        print(f"Started Tally with Process ID: {process_id}")
        
        time.sleep(20)  # Allow time for Tally to load fully

        self.app = Application().connect(process=process_id)
        self.main_window = self.app.top_window()  # Get the top window for this process
        self.main_window.wait('visible')
        self.main_window.set_focus()
        return self.main_window

    def send_keys_to_window(self, keys):
        """Ensure the correct Tally window is focused, then send keystrokes."""
        if self.main_window:
            self.main_window.set_focus()
            keyboard.send_keys(keys, pause=0.05)
        else:
            raise Exception("Main window is not set. Start the Tally session first.")

    def login_tally(self, executable_path):
        """Start Tally and return the main window after login."""
        self.main_window = self.start_and_track_tally_session(executable_path)
        time.sleep(10)  # Wait for Tally to fully load after login
        return self.main_window

    def close_tally_window(self):
        """Close the Tally application gracefully."""
        if self.main_window:
            try:
                # Ensure the window is focused before sending the keys
                self.focus_window(self.main_window)

                # Send Alt+F4 to close the application
                self.send_keys_to_window('%{F4}')  # Alt + F4 to close
                time.sleep(2)  # Wait for the confirmation prompt
                
                # Confirm the closure if there's a prompt
                self.send_keys_to_window('{ENTER}')  # Confirm if there's a prompt

            except Exception as e:
                raise Exception(f"Error closing Tally window: {e}")
        else:
            raise Exception("Main window is not set. Start the Tally session first.")

    def focus_window(self, window):
        """Ensure the window is in focus before sending keystrokes."""
        # Implement your logic here to focus on the window if needed
        pass

    def select_period(self, from_date, to_date):
        """Select a period in Tally by entering the from and to dates."""
        if not self.main_window:
            raise Exception("Main window is not set. Start the Tally session first.")
        
        self.send_keys_to_window('{F2}')
        time.sleep(1)
        self.send_keys_to_window(from_date)
        time.sleep(1)
        self.send_keys_to_window('{ENTER}')
        time.sleep(1)
        self.send_keys_to_window(to_date)
        time.sleep(1)
        self.send_keys_to_window('{ENTER}')
        time.sleep(5)
    
    def select_view_mode(self, view_mode):
        """Select a specific view mode in Tally (Daily, Weekly, etc.)."""
        if view_mode not in ['Daily', 'Weekly', 'Fortnightly', 'Monthly', 'Half Yearly']:
            raise ValueError("Invalid view mode. Choose from: Daily, Weekly, Fortnightly, Monthly, Half Yearly.")
      
      
        # Handle view selection based on the user input
        if view_mode == 'Daily':
            self.send_keys_to_window('{D}')  # Select 'Daily'
        elif view_mode == 'Weekly':
            self.send_keys_to_window('{W}')  # Select 'Weekly'
        elif view_mode == 'Fortnightly':
            self.send_keys_to_window('{F}')  # Select 'Fortnightly'
        elif view_mode == 'Monthly':
            self.send_keys_to_window('{M}')  # Select 'Monthly'
        elif view_mode == 'Half Yearly':
            self.send_keys_to_window('{H}')  # Select 'Half Yearly'
        
        time.sleep(3)  # Allow time for Tally to change the view

    def view_financial_reports(self, report_type):
        """View the financial report based on the provided report_type."""
        if not self.main_window:
            raise Exception("Main window is not set. Start the Tally session first.")

        # Open the 'View' menu
        self.send_keys_to_window('{Alt}V')  
        time.sleep(1)

        # Select the report based on the report_type parameter
        if report_type.lower() == 'liabilities':
            self.send_keys_to_window('{L}')  # Liabilities report
        elif report_type.lower() == 'fixed assets':
            self.send_keys_to_window('{F}')  # Fixed Assets report
        elif report_type.lower() == 'current assets':
            self.send_keys_to_window('{C}')  # Current Assets report
        else:
            raise ValueError("Invalid report type. Choose from 'liabilities', 'fixed assets', or 'current assets'.")

        time.sleep(3)  # Wait for the report to load

# Create a single instance of TallyLibrary to be reused
global_tally_instance = TallyLibrary()

# Expose functions for Robot Framework to use the global instance
def start_and_track_tally_session(executable_path):
    return global_tally_instance.start_and_track_tally_session(executable_path)

def send_keys_to_window(keys):
    return global_tally_instance.send_keys_to_window(keys)

def login_tally(executable_path):
    return global_tally_instance.login_tally(executable_path)

def close_tally_window():
    return global_tally_instance.close_tally_window()

def select_period(from_date, to_date):
    return global_tally_instance.select_period(from_date, to_date)

def select_view_mode(view_mode):
    return global_tally_instance.select_view_mode(view_mode)

def view_financial_reports(report_type):
    return global_tally_instance.view_financial_reports(report_type)
