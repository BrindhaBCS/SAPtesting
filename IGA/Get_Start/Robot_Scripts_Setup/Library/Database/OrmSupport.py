"""
Supports connection and execution of tests using Object Relational Mapper
"""
import ast
import os
from datetime import datetime
import re
import pyodbc
from sqlalchemy.sql.expression import select, literal_column
from sqlalchemy import MetaData, Table, text, create_engine, join
from sqlalchemy.engine import reflection
from sqlalchemy.orm import sessionmaker
from DatabaseLibrary import DatabaseLibrary
from robot.api import logger
import pandas as pd


class OrmSupport(DatabaseLibrary):
    """
    Hanldes working with ORM SqlAlchemy
    """
    def __init__(self):
        self.table_model = None
        self.column_names = []
        self.orm_con = None
        self.meta = None
        self.engine = None
        self.session = None
        self.query_list = []

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

        self._set_engine(server, database, uid, password)
        self._set_metadata(self.engine)
        self._create_session(self.engine)
        self.orm_con = self.engine.connect()

    def close_session(self):
        """
        Closes the session
        """
        if self.session:
            self.session.close()

    def disconnect_orm(self):
        """
        Disconnects orm connection if it is connected.
        """
        if self.orm_con:
            self.orm_con.close()
            self.orm_con = None

    def _set_engine(self, server, database, uid, password):
        """
        Creates engine by connecting to database
        :param server: server you want to connect to
        :param database:  database which you want to access
        :param uid: username
        :param password: password
        :return: sets engine
        """
        driver = self._get_driver_string()
        engine_stmt = ("mssql+pyodbc://%s:%s@%s/%s?driver=%s&Mars_Connection=Yes" %
                       (uid, password, server, database, driver))
        self.engine = create_engine(engine_stmt)

    def _set_metadata(self, engine):
        """
        Initialises metadata and binds it to the engine
        Also reflects database i.e. automatically load all tables from the bound database
        :param engine:
        :return: sets metadata
        """
        self.meta = MetaData(bind=engine, reflect=True)

    def _create_session(self, engine):
        """
        Creates a session and binds engine
        """
        if not self.session:
            session = sessionmaker(bind=engine)
            self.session = session()

    def _set_table(self, table_name):
        """
        :param table_name: takes table name from robot test and sets it in a table object
        :return: SQLAlchemy Table object
        """
        table_and_schema = table_name.split(".")
        self.query_list.append("Querying Table name %s from Schema %s\n\n" %
                               (table_and_schema[1], table_and_schema[0]))
        return Table(table_and_schema[1], self.meta, autoload=True,
                     autoload_with=self.engine, schema=table_and_schema[0])

    @staticmethod
    def _get_driver_string(driver_string='ODBC Driver 17 for SQL Server'):
        """
        Fetches odbc driver string to connect to the database. Searches for ODBC Driver 17,
        followed by ODBC Driver another version. Followed by SQL Server Native.
        :returns: Driver string to connect to the odbc database
        """
        drivers = pyodbc.drivers()
        driver_found = False
        if driver_string not in drivers:
            for driver in pyodbc.drivers():
                if driver.startswith("ODBC Driver") or driver.startswith("SQL Server Native"):
                    driver_string = driver
                    driver_found = True
                    break
            if not driver_found:
                driver_string = drivers[-1]
        logger.info("Utilizing odbc string: %s" % driver_string)
        driver_string = driver_string.replace(" ", "+")
        return driver_string

    def _return_list_of_all_tables_in_database(self):
        """
        Uses Inspector to reflect all tables from engine
        Scans all schemas and databases
        :return: list of table objects
        """
        insp = reflection.Inspector.from_engine(self.engine)
        list_of_tables = []
        for schema in insp.get_schema_names():
            for table_name in insp.get_table_names(schema=schema, order_by=None):
                table = Table(table_name, self.meta, autoload=True,
                              autoload_with=self.engine, schema=schema)
                list_of_tables.append(table)
        return list_of_tables

    def return_column_descriptions_from_table(self, table_name, schema):
        """
        Uses Inspector to reflect all tables from engine
        Scans all schemas and databases
        :type schema: string schema name; if omitted, uses the default
                schema of the database connection
        For special quoting, use quoted_name
        :type table_name: string name of the table
        :return: list of dictionaries, each representing the definition of a database column
        """
        insp = reflection.Inspector.from_engine(self.engine)
        self.query_list.append(str(insp.get_columns(table_name, schema)))
        return insp.get_columns(table_name, schema)

    def return_count_of_table_with_conditions(self, table_name, condition):
        """
        Returns a count of record in a table based on a condition
        :param table_name: table name passed from robot keyword #NB
                Must be in the format SCHEMA_NAME.TABLE_NAME
        :param condition: condition passed from robot keyword i.e. column_name = value
        :return: Count of query object (int)
        """
        self.table_model = self._set_table(table_name)
        self.query_list.append(str(self.session.query(
            self.table_model).filter(text(condition)).count()))
        return self.session.query(self.table_model).filter(text(condition)).count()

    def return_count_of_table(self, table_name):
        """
        Returns a count of records in a table
        :param table_name:  table name passed from robot keyword #NB Must be in
                    the format SCHEMA_NAME.TABLE_NAME
        :return:  Count of query objects (int)
        """
        self.table_model = self._set_table(table_name)
        self.query_list.append(str(self.session.query(self.table_model).count()))
        return self.session.query(self.table_model).count()

    def return_multiple_columns_from_table(self, table_name, column_names, condition, amount):
        """
        :param condition:  condition passed from robot keyword
                    i.e. col1 >= value1 and col2 < value2
        :param amount: amount of records returned from query
        :type column_names: list of columns that are returned from query
        :param table_name:  table name passed from robot keyword #NB Must be in
                    the format SCHEMA_NAME.TABLE_NAME
        :return:  Column of a query result
        """
        list_of_columns = self._return_list_of_column_names(column_names)
        self.query_list.append(str(select(list_of_columns).select_from(text(table_name)).
                                   where(text(condition)).limit(amount)))
        self.query_list.append(self.convert_to_df(
            self.session.execute(select(list_of_columns).select_from(
                text(table_name)).where(text(condition)).limit(amount))))
        return self.session.execute(select(list_of_columns).select_from(
            text(table_name)).where(text(condition)).limit(amount))

    def join_2_tables_based_on_a_condition(self, table1, table2, column_names,
                                           clause, condition, amount):
        """
        Joins 2 tables and returns an amount of columns
        :param amount: amount of records returned
        :type column_names: list of columns that are returned from query
        :param clause: clause to join the columns
        :param table1: table to select from
        :param table2: table to join
        :param condition: where condition for join
        :return: list of query results
        """
        join_table_1 = self._set_table(table1)
        join_table_2 = self._set_table(table2)
        list_of_columns = self._return_list_of_column_names(column_names)
        self.query_list.append(str(select(list_of_columns).select_from(
            join(join_table_1, join_table_2, text(clause))).where(
                text(condition)).distinct().limit(amount)))
        self.query_list.append(self.convert_to_df(self.session.execute(
            select(list_of_columns).select_from(join(
                join_table_1, join_table_2, text(clause))).where(
                    text(condition)).distinct().limit(amount))))
        return self.session.execute(select(list_of_columns).select_from(
            join(join_table_1, join_table_2, text(clause))).where(
                text(condition)).distinct().limit(amount))

    def count_join_2_tables_based_on_a_condition(self, table1, table2, clause, condition):
        """
        Joins 2 tables and returns count based on a condition
        Joins 2 tables and returns count based on a condition
        :param clause: clause to join the columns
        :param table1: table to select from
        :param table2: table to join
        :param condition: where condition for join
        :return: count of query results
        """
        join_table_1 = self._set_table(table1)
        join_table_2 = self._set_table(table2)
        self.query_list.append(str(self.session.query(join_table_1).select_from(
            join(join_table_1, join_table_2, text(clause))).filter(
                text(condition)).distinct().count()))
        return self.session.query(join_table_1).select_from(join(
            join_table_1, join_table_2, text(clause))).filter(
                text(condition)).distinct().count()

    def check_columns_match_values_in_a_list_or_subquery(
            self, table, list_of_values, select_columns, column_name):
        """
        Checks query contains a list or subquery
        :param list_of_values: list or subquery to compare
        :type select_columns: columns returned from query
        :type column_name: column to compare
        :param table: table to select from
        :return: column values that match list or subquery
        """
        select_columns = self._return_list_of_column_names(select_columns)
        self.query_list.append("List of values used for query: %s\n" % (str(list_of_values)))
        self.query_list.append(str(select(select_columns).select_from(text(
            table)).where(literal_column(column_name).in_(ast.literal_eval(
                list_of_values))).distinct()))
        query = self.session.execute(select(select_columns).select_from(
            text(table)).where(literal_column(column_name).in_(
                ast.literal_eval(list_of_values))).distinct())
        self.query_list.append(self.convert_to_df(query))
        return query

    @staticmethod
    def _return_list_of_column_names(column_names):
        """
        Returns a list of columns for an amount of records in a table
        :type column_names: list of columns that are returned from query
        :return: list of column names cast to text object
        """
        list_of_columns = column_names.split(",")
        list_cast_to_text = []
        for column_name in list_of_columns:
            column = column_name.strip("")   # remove whitespaces
            list_cast_to_text.append(text(column))  # columns in list must be cast to text object
            print(column)
        return list_cast_to_text

    def write_to_file(self, robot_test_tag):
        """
        Create report that prints queries used for a robot test in respective order of execution
        Regular expression checks the integrity of the robot tag i.e (4characters-4digits)
        :param robot_test_tag:  the tag of the robot test you wish to create a file for
        """
        if re.search("^[\\w]{4}-[\\d]{4}", robot_test_tag):  # pattern match check
            if len(robot_test_tag) >= 9:
                story_num = robot_test_tag[:9]
                # slice first 9 characters i.e. the story number of robot tag
            else:
                story_num = robot_test_tag
            filename = "Tests\\Reports\\"+story_num+"\\report-"+robot_test_tag+"-"+str(
                datetime.now().strftime("%d-%m-%Y-%H-%M-%S"))+".txt"
            os.makedirs(os.path.dirname(filename), exist_ok=True)
            # check if directory exists and create it if not
            with open(filename, "w", encoding='utf-8') as file_object:
                file_object.write("Robot Test: %s\n\n" % robot_test_tag)
                count = 0
                for query_string in self.query_list:
                    count = count + 1   # increment step number for report
                    file_object.write("\nStep "+str(count)+": "+str(query_string))

            self.query_list = []
        else:
            raise ValueError("Must provide valid Robot Tag for report")

    def add_result_to_list(self, result, label):
        """
        Keyword used to add a result to the list for the report
        :param label: label of result for report
        :param result: ${result} from query passed in from robot keyword
        """
        self.query_list.append("%s Result: \n%s\n\n" % (label, result))

    @staticmethod
    def convert_to_df(result):
        "Converts to dataframe"
        pd.set_option('display.max_columns', None)
        pd.set_option('display.max_rows', 20)
        return pd.DataFrame(result, columns=result.keys())

    @staticmethod   # Not tested
    def compare_column_in_2_dfs(result1, result2, column1, column2):
        "Compares columns in two dataframes"
        df1 = pd.DataFrame(result1, columns=result1.keys())
        df2 = pd.DataFrame(result2, columns=result2.keys())
        print("df1: " + str(df1))
        print("df2: " + str(df2))
        result = df1[[column1]].equals(df2[[column2]])
        print("COMPARING 2 DATAFRAME COLUMNS: " + str(result))
        return result

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
        if description is None:
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
