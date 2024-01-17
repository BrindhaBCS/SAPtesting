"""
Executes processes in a thread. Helps speed up xray interaction processes.
"""
import threading


class ThreadExecution:
    """
    Supports parallel execution of Threads
    """
    def __init__(self, max_threads=10):
        """
        Initializes ThreadExecution with the executable function to run in parallel threads

        :param max_threads: Maximum number of threads that can run in parallel

        """
        self.semaphore = threading.BoundedSemaphore(value=max_threads)
        self.threads_to_run = {}
        self.counter = 1

    def add_to_threads(self, call_function, *args, **kwargs):
        """
        Adds to threads to run
        :param call_function: Function to parallelize
        :param args: list of arguments
        :param kwargs: dict arguments
        """
        new_thread = threading.Thread(target=call_function,
                                      args=args, kwargs=kwargs)
        self.threads_to_run[self.counter] = {"thread": new_thread, "status": "New"}
        self.counter += 1

    def get_semaphore(self):
        """
        Returns self.semaphore
        """
        return self.semaphore

    def start_and_join_threads(self):
        """
        Starts the threads to execute and immediately joins them
        """
        # Start New thread execution
        for counter in self.threads_to_run:
            thread_object = self.threads_to_run[counter]["thread"]
            if self.threads_to_run[counter]["status"] == "New":
                thread_object.start()
                self.threads_to_run[counter]["status"] = "Started"

        # Join started threads. Wait until all of them finish execution
        for counter in self.threads_to_run:
            if self.threads_to_run[counter]["status"] == "Started":
                self.threads_to_run[counter]["thread"].join()
                self.threads_to_run[counter]["status"] = "Joined"
