import requests

# Define the Selenium Grid server URL and session ID
grid_url = "https://symphony4cloud.com:4444/wd/hub/session"
session_id = "ec5eea91e1536e94bb0903907db045c0"

# Construct the URL for the DELETE request
delete_url = f"{grid_url}/{session_id}"

# Send the DELETE request
response = requests.delete(delete_url)

# Check the response
if response.status_code == 200:
    print("Session deleted successfully.")
else:
    print(f"Failed to delete session. Status code: {response.status_code}")
    print("Response:", response.text)