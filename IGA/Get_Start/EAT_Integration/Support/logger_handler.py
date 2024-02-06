"""
Handles logging functionality for the test uploader module
"""
import logging
import ntpath
import os

LOGGER = None


def setup(results_file="", action="EAT"):
    """
    Sets up logging for test uploader
    :param results_file: Path to where the result file.
    :param action: The action being performed in the test management tool
    """
    global LOGGER
    if LOGGER:
        return LOGGER
    logger = logging.getLogger("Logger for Test Uploader")
    logger.setLevel(logging.INFO)
    # create file handler which logs even debug messages
    folder_location = os.path.dirname(os.path.abspath(__file__))
    if results_file:
        if not os.path.isabs(results_file):
            results_file = os.path.abspath(results_file)
        folder_location = os.path.dirname(results_file)
    # Log to Test_Management_Uploader.log file
    file_path = os.sep.join([folder_location, action + '_Uploader.log'])
    create_logging_file(file_path)
    file_handler = logging.FileHandler(file_path)
    file_handler.setLevel(logging.NOTSET)
    # create console handler with a higher log level
    console_handler = logging.StreamHandler()
    console_handler.setLevel(logging.INFO)
    # create formatter and add it to the handlers
    formatter = logging.Formatter('%(asctime)s %(filename)s:%(funcName)s:'
                                  '%(lineno)d:%(levelname)s - %(message)s')
    file_handler.setFormatter(formatter)
    console_handler.setFormatter(formatter)
    # add the handlers to the logger
    logger.addHandler(file_handler)
    logger.addHandler(console_handler)
    LOGGER = logger
    return LOGGER


def create_logging_file(file_path):
    """
    Creates file with no data in it if it does not exist
    :param file_path: Path of the file to create
    """
    dir_path = ntpath.dirname(file_path)
    if not os.path.exists(dir_path):
        os.makedirs(dir_path)
    open(file_path, "w").close()
