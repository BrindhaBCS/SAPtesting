import logging
import os

LOGGER = None


def setup(log_name="Log"):
    """
    Sets up logging for robot framework generation
    """
    global LOGGER
    if LOGGER:
        return LOGGER
    logger = logging.getLogger(log_name)
    logger.setLevel(logging.INFO)
    # create file handler which logs even debug messages
    folder_location = os.path.dirname(os.path.abspath(__file__))
    file_path = os.sep.join([folder_location, 'Robot_Framework_Codebase_Generation.log'])
    fh = logging.FileHandler(file_path)
    fh.setLevel(logging.NOTSET)
    # create console handler with a higher log level
    ch = logging.StreamHandler()
    ch.setLevel(logging.INFO)
    # create formatter and add it to the handlers
    formatter = logging.Formatter('%(asctime)s %(filename)s:%(funcName)s:'
                                  '%(lineno)d:%(levelname)s - %(message)s')
    fh.setFormatter(formatter)
    ch.setFormatter(formatter)
    # add the handlers to the logger
    logger.addHandler(fh)
    logger.addHandler(ch)
    LOGGER = logger
    return LOGGER
