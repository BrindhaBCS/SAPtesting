import os, sys

def setup_path():
    "Adds parent location to system path if not already added"
    dir_path = os.path.dirname(os.path.realpath(__file__))
    parent_path = os.path.abspath(os.path.join(dir_path, os.pardir))
    if parent_path not in sys.path:
        sys.path.append(parent_path)
        
setup_path()

