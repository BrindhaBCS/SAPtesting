from pywinauto import Application, keyboard
import time

def start_and_track_tally_session(executable_path):
    """Start a Tally session and return its main window based on process ID."""
    # Start the application and get the process ID
    app = Application().start(executable_path)
    process_id = app.process
    print(f"Started Tally with Process ID: {process_id}")
    
    time.sleep(20)  # Allow time for Tally to load fully

    # Reconnect using the process ID to avoid ambiguity
    app = Application().connect(process=process_id)
    main_window = app.top_window()  # Get the top window for this process
    main_window.wait('visible')
    main_window.set_focus()
    return main_window

def send_keys_to_window(window, keys):
    """Ensure the correct Tally window is focused, then send keystrokes."""
    window.set_focus()
    keyboard.send_keys(keys, pause=0.05)  # Send keystrokes with a brief pause

def automate_tally_instance():
    # Path to the Tally executable
    path_to_tally = r"C:\Program Files\TallyPrime\tally.exe"  # Adjust path as necessary

    # Start Tally and obtain the main window handle for this session
    main_window = start_and_track_tally_session(path_to_tally)

    # Perform actions in this specific Tally session
    send_keys_to_window(main_window, '+T')  # Shift+T to continue in educational mode
    time.sleep(10)

    # Example of further actions, customized as needed
    send_keys_to_window(main_window, '{F1}')
    time.sleep(2)
    send_keys_to_window(main_window, '{LEFT}')
    time.sleep(2)
    send_keys_to_window(main_window, '{ENTER}')
    time.sleep(2)

    # Additional actions
    send_keys_to_window(main_window, '+E')
    time.sleep(2)
    send_keys_to_window(main_window, '+Y')
    time.sleep(2)

    # Close Tally for this specific session
    main_window.close()
    print(f"Closed Tally session with Process ID: {main_window.process}")

if __name__ == "__main__":
    automate_tally_instance()
