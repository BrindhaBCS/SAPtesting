import pandas as pd
from robot.api.deco import keyword

class PandasLibrary:

    @keyword
    def read_csv_file_to_dataframe(self, file_path):
        return pd.read_csv(file_path)

    @keyword
    def dataframe_to_list(self, dataframe):
        return dataframe.values.tolist()

    @keyword
    def add_column_to_dataframe(self, dataframe, column_name, default_value):
        dataframe[column_name] = default_value
        return dataframe

    @keyword
    def write_dataframe_to_csv(self, dataframe, file_path):
        dataframe.to_csv(file_path, index=False)

    @keyword
    def log_dataframe_info(self, dataframe):
        print(dataframe.info())
