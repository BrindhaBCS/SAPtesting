from DatabaseLibrary import DatabaseLibrary
import traceback


class RedShiftDBLib(DatabaseLibrary):
    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'
    
    def __init__(self):
        self.connected = False
    
    def connect_to_redshiftDB(self, db_module_name, database, username,
                              password, host, port):
        """
        Connects to Redshift Database.
        
        :param db_module_name: Database api module name e.g. pyscopg2
        :param database: Database connection string
        :param username: Username to connect to Redshift DB
        :param password: Password to connect to Redshift DB
        :param host: Host name of the Redhsift DB
        :param port: Port Number of the Redhsift DB
        :type db_module_name: String
        :type database: String
        :type username: String
        :type password: String
        :type host: String
        :type port: int
        """
        try:
            conn_string = "database='" + database + "',"
            conn_string += "user='" + username + "',"
            conn_string += "password='" + password + "',"
            conn_string += "host='" + host + "',"
            conn_string += "port=" + str(port)
            self.connect_to_database_using_custom_params(
                dbapiModuleName=db_module_name,
                db_connect_string=conn_string)
            self.connected = True
        except (TypeError, NameError):
            print(traceback.format_exc())
            print("Failed to connect to RedshiftDB Server")
    
    def disconnect_from_redshiftDB(self):
        "Disconnects from Redshift Database"
        try:
            if self.connected:
                self.disconnect_from_database()
                self.connected = False
        except (TypeError, NameError):
            print(traceback.format_exc())
            print("Failed to disconnect from RedshiftDB Server")
        

if __name__ == "__main__":
    testobj = RedShiftDBLib()
    testobj.connect_to_redshiftDB()
    testobj.disconnect_from_redshiftDB()
