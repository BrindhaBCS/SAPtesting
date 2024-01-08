"""
This module performs DB connectivity and provides functionality to process DB queries
"""
from DatabaseLibrary import DatabaseLibrary
import sqlalchemy


class AzureDBLib(DatabaseLibrary):
    "Handles Databaselibrary through overriding and extending functionality."
    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'

    def __init__(self):
        self.connected = False
        self.orm_con = None
        self.column_names = []

    def connect_using_orm(self, server, database, uid, password):
        """
        Connects using SQLAlchemy for providing further functionality.
        For reference see: https://docs.sqlalchemy.org/en/13/core/connections.html

        :param server: Server name to be connected to database.
                        E.g. in Dev it is: mdh-dev-sqlserver.database.windows.net
        :param database: Database to connect to in Azure environment. E.g. MDH-CORE
        :param uid: Username to connect to Azure DB
        :param password: Password to connect to Azure DB
        """
        driver = self._get_driver_string()
        engine_stmt = ("mssql+pyodbc://%s:%s@%s/%s?driver=%s" %
                       (uid, password, server, database, driver))
        engine = sqlalchemy.create_engine(engine_stmt)
        self.orm_con = engine.connect()

    def query_using_orm(self, query):
        """
        Executes the query using the orm
        :param query: String of sql query to execute
        :return: Result from running the query
        """
        result = []
        if self.orm_con:
            result_set = self.orm_con.execute(query)
            self.column_names = result_set.keys()
            result = result_set.fetchall()
        return result

    def disconnect_orm(self):
        """
        Disconnects orm connection if it is connected.
        """
        if self.orm_con:
            self.orm_con.close()
            self.orm_con = None

    def check_null_values(self, query_result, colname, description=None):
        """
        Verifies for null value absence in the query results under the index location.
        :param query_result: List of tuples of query results fetched from query.
        :param colname: Column name to be searched within the results
        :param description: Description of the query
        :return: True if no null values are found at inner_index in the query result tuples
        """
        null_not_found = True
        index = 0
        if not description:
            description = self.column_names
        for i, item in enumerate(description):
            if item[0] == colname:
                index = i
                break
        for result in query_result:
            print(result)
            if result[index] in ["N/A", "n/a", "Null", "None", "null", ""]:
                null_not_found = False
                break
        return null_not_found
