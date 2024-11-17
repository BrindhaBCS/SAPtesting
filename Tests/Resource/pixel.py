import pyautogui
import time

print("Move your mouse to the desired position. Coordinates will be printed below.")
try:
    while True:
        x, y = pyautogui.position()
        print(f"Mouse Position: x={x}, y={y}", end="\r")  # Print coordinates in real-time
        time.sleep(1)
except KeyboardInterrupt:
    print("\nStopped.")

    
 