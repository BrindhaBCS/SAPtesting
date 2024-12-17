import pythoncom
import win32com.client
import time
from datetime import datetime
import _strptime
from pythoncom import com_error
import robot.libraries.Screenshot as screenshot
import os
from robot.api import logger
import sys
import ast
import re
import pandas as pd
import openpyxl
import re
import json


class SAP_Tcode_Library:
    """The SapGuiLibrary is a library that enables users to create tests for the Sap Gui application

    The library uses the Sap Scripting Engine, therefore Scripting must be enabled in Sap in order for this library to work.

    = Opening a connection / Before running tests =

    First of all, you have to *make sure the Sap Logon Pad is started*. You can automate this process by using the
    AutoIT library or the Process Library.

    After the Sap Login Pad is started, you can connect to the Sap Session using the keyword `connect to session`.

    If you have a successful connection you can use `Open Connection` to open a new connection from the Sap Logon Pad
    or `Connect To Existing Connection` to connect to a connection that is already open.

    = Locating or specifying elements =

    You need to specify elements starting from the window ID, for example, wnd[0]/tbar[1]/btn[8]. In some cases the SAP
    ID contains backslashes. Make sure you escape these backslashes by adding another backslash in front of it.

    = Screenshots (on error) =

    The SapGUILibrary offers an option for automatic screenshots on error.
    Default this option is enabled, use keyword `disable screenshots on error` to skip the screenshot functionality.
    Alternatively, this option can be set at import.
    """
    __version__ = '1.1'
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self, screenshots_on_error=True, screenshot_directory=None):
        """Sets default variables for the library
        """
        self.explicit_wait = float(0.0)

        self.sapapp = -1
        self.session = -1
        self.connection = -1

        self.take_screenshots = screenshots_on_error
        self.screenshot = screenshot.Screenshot()

        if screenshot_directory is not None:
            if not os.path.exists(screenshot_directory):
                os.makedirs(screenshot_directory)
            self.screenshot.set_screenshot_directory(screenshot_directory)

    def click_element(self, element_id):
        """Performs a single click on a given element. Used only for buttons, tabs and menu items.

        In case you want to change a value of an element like checkboxes of selecting an option in dropdown lists,
        use `select checkbox` or `select from list by label` instead.
        """

        # Performing the correct method on an element, depending on the type of element
        element_type = self.get_element_type(element_id)
        if (element_type == "GuiTab"
                or element_type == "GuiMenu"):
            self.session.findById(element_id).select()
        elif element_type == "GuiButton":
            self.session.findById(element_id).press()
        else:
            self.take_screenshot()
            message = "You cannot use 'click_element' on element type '%s', maybe use 'select checkbox' instead?" % element_type
            raise Warning(message)
        time.sleep(self.explicit_wait)

    def click_toolbar_button(self, table_id, button_id):
        """Clicks a button of a toolbar within a GridView 'table_id' which is contained within a shell object.
        Use the Scripting tracker recorder to find the 'button_id' of the button to click
        """
        self.element_should_be_present(table_id)

        try:
            self.session.findById(table_id).pressToolbarButton(button_id)
        except AttributeError:
            self.take_screenshot()
            self.session.findById(table_id).pressButton(button_id)
        except com_error:
            self.take_screenshot()
            message = "Cannot find Button_id '%s'." % button_id
            raise ValueError(message)
        time.sleep(self.explicit_wait)

    def connect_to_existing_connection(self, connection_name):
        """Connects to an open connection. If the connection matches the given connection_name, the session is connected
        to this connection.
        """
        self.connection = self.sapapp.Children(0)
        if self.connection.Description == connection_name:
            self.session = self.connection.children(0)
        else:
            self.take_screenshot()
            message = "No existing connection for '%s' found." % connection_name
            raise ValueError(message)

    def connect_to_session(self, explicit_wait=0):
        """Connects to an open session SAP.

        See `Opening a connection / Before running tests` for details about requirements before connecting to a session.

        Optionally `set explicit wait` can be used to set the explicit wait time.

        *Examples*:
        | *Keyword*             | *Attributes*          |
        | connect to session    |                       |
        | connect to session    | 3                     |
        | connect to session    | explicit_wait=500ms   |

        """
        lenstr = len("SAPGUI")
        rot = pythoncom.GetRunningObjectTable()
        rotenum = rot.EnumRunning()
        while True:
            monikers = rotenum.Next()
            if not monikers:
                break
            ctx = pythoncom.CreateBindCtx(0)
            name = monikers[0].GetDisplayName(ctx, None);

            if name[-lenstr:] == "SAPGUI":
                obj = rot.GetObject(monikers[0])
                sapgui = win32com.client.Dispatch(obj.QueryInterface(pythoncom.IID_IDispatch))
                self.sapapp = sapgui.GetScriptingEngine
                # Set explicit_wait after connection succeed
                self.set_explicit_wait(explicit_wait)

        if hasattr(self.sapapp, "OpenConnection") == False:
            self.take_screenshot()
            message = "Could not connect to Session, is Sap Logon Pad open?"
            raise Warning(message)
        # run explicit wait last
        time.sleep(self.explicit_wait)

    def disable_screenshots_on_error(self):
        """Disables automatic screenshots on error.
        """
        self.take_screenshots = False

    def doubleclick_element(self, element_id, item_id, column_id):
        """Performs a double-click on a given element. Used only for shell objects.
        """

        # Performing the correct method on an element, depending on the type of element
        element_type = self.get_element_type(element_id)
        if element_type == "GuiShell":
            self.session.findById(element_id).doubleClickItem(item_id, column_id)
        else:
            self.take_screenshot()
            message = "You cannot use 'doubleclick element' on element type '%s', maybe use 'click element' instead?" % element_type
            raise Warning(message)
        time.sleep(self.explicit_wait)

    def element_should_be_present(self, element_id, message=None):
        """Checks whether an element is present on the screen.
        """
        try:
            self.session.findById(element_id)
        except com_error:
            self.take_screenshot()
            if message is None:
                message = "Cannot find Element '%s'." % element_id
            raise ValueError(message)

    def element_value_should_be(self, element_id, expected_value, message=None):
        """Checks whether the element value is the same as the expected value.
        The possible expected values depend on the type of element (see usage).

         Usage:
         | *Element type*   | *possible values*                 |
         | textfield        | text                              |
         | label            | text                              |
         | checkbox         | checked / unchecked               |
         | radiobutton      | checked / unchecked               |
         | combobox         | text of the option to be expected |
         """
        element_type = self.get_element_type(element_id)
        actual_value = self.get_value(element_id)

        # Breaking up the different element types so we can check the value the correct way
        if (element_type == "GuiTextField"
                or element_type == "GuiCTextField"
                or element_type == "GuiComboBox"
                or element_type == "GuiLabel"):
            self.session.findById(element_id).setfocus()
            time.sleep(self.explicit_wait)
            # In these cases we can simply check the text value against the value of the element
            if expected_value != actual_value:
                if message is None:
                    message = "Element value of '%s' should be '%s', but was '%s'" % (
                        element_id, expected_value, actual_value)
                self.take_screenshot()
                raise AssertionError(message)
        elif element_type == "GuiStatusPane":
            if expected_value != actual_value:
                if message is None:
                    message = "Element value of '%s' should be '%s', but was '%s'" % (
                        element_id, expected_value, actual_value)
                self.take_screenshot()
                raise AssertionError(message)
        elif (element_type == "GuiCheckBox"
              or element_type == "GuiRadioButton"):
            # First check if there is a correct value given, otherwise raise an assertion error
            self.session.findById(element_id).setfocus()
            if (expected_value.lower() != "checked"
                    and expected_value.lower() != "unchecked"):
                # Raise an AsertionError when no correct expected_value is given
                self.take_screenshot()
                if message is None:
                    message = "Incorrect value for element type '%s', provide checked or unchecked" % element_type
                raise AssertionError(message)

            # Check whether the expected value matches the actual value. If not, raise an assertion error
            if expected_value.lower() != actual_value:
                self.take_screenshot()
                if message is None:
                    message = "Element value of '%s' didn't match the expected value" % element_id
                raise AssertionError(message)
        else:
            # When the type of element can't be checked, raise an assertion error
            self.take_screenshot()
            message = "Cannot use keyword 'element value should be' for element type '%s'" % element_type
            raise Warning(message)
        # Run explicit wait as last
        time.sleep(self.explicit_wait)

    def element_value_should_contain(self, element_id, expected_value, message=None):
        """Checks whether the element value contains the expected value.
        The possible expected values depend on the type of element (see usage).

         Usage:
         | *Element type*   | *possible values*                 |
         | textfield        | text                              |
         | label            | text                              |
         | combobox         | text of the option to be expected |
         """
        element_type = self.get_element_type(element_id)

        # Breaking up the different element types so we can check the value the correct way
        if (element_type == "GuiTextField"
                or element_type == "GuiCTextField"
                or element_type == "GuiComboBox"
                or element_type == "GuiLabel"):
            self.session.findById(element_id).setfocus()
            actual_value = self.get_value(element_id)
            time.sleep(self.explicit_wait)
            # In these cases we can simply check the text value against the value of the element
            if expected_value not in actual_value:
                self.take_screenshot()
                if message is None:
                    message = "Element value '%s' does not contain '%s', (but was '%s')" % (
                        element_id, expected_value, actual_value)
                raise AssertionError(message)
        else:
            # When the element content can't be checked, raise an assertion error
            self.take_screenshot()
            message = "Cannot use keyword 'element value should contain' for element type '%s'" % element_type
            raise Warning(message)
        # Run explicit wait as last
        time.sleep(self.explicit_wait)

    def enable_screenshots_on_error(self):
        """Enables automatic screenshots on error.
        """
        self.take_screenshots = True

    def get_table_cell_text(self, table_id, row, column):
        """Returns the cell value for the specified cell.
        """               
  
        try:
            #Access the table control
            table_control = self.session.findById(table_id)
            # Use getCell to access the specific cell
            cell = table_control.getCell(row, column)
            # Get the text from the cell
            cell_text = cell.Text  # Or use other appropriate property or method
            return cell_text
        except com_error:
            self.take_screenshot()
            message = "Cannot find Column_id '%s'." % column
            raise ValueError(message)
        
    def find_all_rows_by_cell_content(self, table_id, column_index, content): 
        print(table_id)
        found_rows = []
        table_control = self.session.findById(table_id)
        try:
            for row_index in range(table_control.RowCount):
                print(row_index)
                cell = table_control.getCell(row_index, column_index)
                print(cell.Text)
                if content in cell.Text:
                    found_rows.append(row_index)
                    if len(found_rows) == 1:
                        found_row = found_rows[0]
                        return found_row
                    elif len(found_rows) > 1:
                        raise ValueError("Array contains more than one value")
                    else:
                        raise ValueError("Array is empty")
        except ValueError as e:
            print("Error while searching table: {e}")

    
    
    def get_cell_value(self, table_id, row_num, col_id):
        """Returns the cell value for the specified cell.
        """
        self.element_should_be_present(table_id)

        try:
            cellValue = self.session.findById(table_id).getCellValue(row_num, col_id)
            return cellValue
        except com_error:
            self.take_screenshot()
            message = "Cannot find Column_id '%s'." % col_id
            raise ValueError(message)

    def get_element_location(self, element_id):
        """Returns the Sap element location for the given element.
        """
        self.element_should_be_present(element_id)
        screenleft = self.session.findById(element_id).screenLeft
        screentop = self.session.findById(element_id).screenTop
        return screenleft, screentop

    def get_element_type(self, element_id):
        """Returns the Sap element type for the given element.
        """
        try:
            type = self.session.findById(element_id).type
            return type
        except com_error:
            self.take_screenshot()
            message = "Cannot find element with id '%s'" % element_id
            raise ValueError(message)

    def get_row_count(self, table_id):
        """Returns the number of rows found in the specified table.
        """
        self.element_should_be_present(table_id)
        rowCount = self.session.findById(table_id).rowCount
        return rowCount

    def get_scroll_position(self, element_id):
        """Returns the scroll position of the scrollbar of an element 'element_id' that is contained within a shell object.
        """
        self.element_should_be_present(element_id)
        currentPosition = self.session.findById(element_id).verticalScrollbar.position
        return currentPosition

    def get_value(self, element_id):
        """Gets the value of the given element. The possible return values depend on the type of element (see Return values).

        Return values:
        | *Element type*   | *Return values*                   |
        | textfield        | text                              |
        | label            | text                              |
        | checkbox         | checked / unchecked               |
        | radiobutton      | checked / unchecked               |
        | combobox         | text of the selected option       |
        | guibutton        | text                              |
        | guititlebar      | text                              |
        | guistatusbar     | text                              |
        | guitab           | text                              |
        """
        element_type = self.get_element_type(element_id)
        return_value = ""
        if (element_type == "GuiTextField"
                or element_type == "GuiCTextField"
                or element_type == "GuiLabel"
                or element_type == "GuiTitlebar"
                or element_type == "GuiStatusbar"
                or element_type == "GuiButton"
                or element_type == "GuiTab"
                or element_type == "GuiShell"):
            self.set_focus(element_id)
            return_value = self.session.findById(element_id).text
        elif element_type == "GuiStatusPane":
            return_value = self.session.findById(element_id).text
        elif (element_type == "GuiCheckBox"
              or element_type == "GuiRadioButton"):
            actual_value = self.session.findById(element_id).selected
            # In these situations we return check / unchecked, so we change these values here
            if actual_value == True:
                return_value = "checked"
            elif actual_value == False:
                return_value = "unchecked"
        elif element_type == "GuiComboBox":
            return_value = self.session.findById(element_id).text
            # In comboboxes there are many spaces after the value. In order to check the value, we strip them away.
            return_value = return_value.strip()
        else:
            # If we can't return the value for this element type, raise an assertion error
            self.take_screenshot()
            message = "Cannot get value for element type '%s'" % element_type
            raise Warning(message)
        return return_value

    def get_window_title(self, locator):
        """Retrieves the window title of the given window.
        """
        return_value = ""
        try:
            return_value = self.session.findById(locator).text
        except com_error:
            self.take_screenshot()
            message = "Cannot find window with locator '%s'" % locator
            raise ValueError(message)

        return return_value

    def input_password(self, element_id, password):
        """Inserts the given password into the text field identified by locator.
        The password is not recorded in the log.
        """
        element_type = self.get_element_type(element_id)
        if (element_type == "GuiTextField"
                or element_type == "GuiCTextField"
                or element_type == "GuiShell"
                or element_type == "GuiPasswordField"):
            self.session.findById(element_id).text = password
            logger.info("Typing password into text field '%s'." % element_id)
            time.sleep(self.explicit_wait)
        else:
            self.take_screenshot()
            message = "Cannot use keyword 'input password' for element type '%s'" % element_type
            raise ValueError(message)

    def input_text(self, element_id, text):
        """Inserts the given text into the text field identified by locator.
        Use keyword `input password` to insert a password in a text field.
        """
        element_type = self.get_element_type(element_id)
        if (element_type == "GuiTextField"
                or element_type == "GuiCTextField"
                or element_type == "GuiShell"
                or element_type == "GuiPasswordField"):
            self.session.findById(element_id).text = text
            logger.info("Typing text '%s' into text field '%s'." % (text, element_id))
            time.sleep(self.explicit_wait)
        else:
            self.take_screenshot()
            message = "Cannot use keyword 'input text' for element type '%s'" % element_type
            raise ValueError(message)

    def maximize_window(self, window=0):
        """Maximizes the SapGui window.
        """
        try:
            self.session.findById("wnd[%s]" % window).maximize()
            time.sleep(self.explicit_wait)
        except com_error:
            self.take_screenshot()
            message = "Cannot maximize window wnd[% s], is the window actually open?" % window
            raise ValueError(message)

        # run explicit wait last
        time.sleep(self.explicit_wait)

    def open_connection(self, connection_name):
        """Opens a connection to the given connection name. Be sure to provide the full connection name, including the bracket part.
        """
        # First check if the sapapp is set and OpenConnection method exists
        if hasattr(self.sapapp, "OpenConnection") == False:
            self.take_screenshot()
            message = "Cannot find an open Sap Login Pad, is Sap Logon Pad open?"
            raise Warning(message)

        try:
            self.connection = self.sapapp.OpenConnection(connection_name, True)
        except com_error:
            self.take_screenshot()
            message = "Cannot open connection '%s', please check connection name." % connection_name
            raise ValueError(message)
        self.session = self.connection.children(0)
        # run explicit wait last
        time.sleep(self.explicit_wait)

    def run_transaction(self, transaction):
        """Runs a Sap transaction. An error is given when an unknown transaction is specified.
        """
        self.session.findById("wnd[0]/tbar[0]/okcd").text = transaction
        time.sleep(self.explicit_wait)
        self.send_vkey(0)

        if transaction == '/nex':
            return

        pane_value = self.session.findById("wnd[0]/sbar/pane[0]").text
        if pane_value in ("Transactie %s bestaat niet" % transaction.upper(),
                          "Transaction %s does not exist" % transaction.upper(),
                          "Transaktion %s existiert nicht" % transaction.upper()):
            self.take_screenshot()
            message = "Unknown transaction: '%s'" % transaction
            raise ValueError(message)

    def scroll(self, element_id, position):
        """Scrolls the scrollbar of an element 'element_id' that is contained within a shell object.
        'Position' is the number of rows to scroll.
        """
        self.element_should_be_present(element_id)
        self.session.findById(element_id).verticalScrollbar.position = position
        time.sleep(self.explicit_wait)

    def select_checkbox(self, element_id):
        """Selects checkbox identified by locator.
        Does nothing if the checkbox is already selected.
        """
        element_type = self.get_element_type(element_id)
        if element_type == "GuiCheckBox":
            self.session.findById(element_id).selected = True
        else:
            self.take_screenshot()
            message = "Cannot use keyword 'select checkbox' for element type '%s'" % element_type
            raise ValueError(message)
        time.sleep(self.explicit_wait)

    def select_context_menu_item(self, element_id, menu_or_button_id, item_id):
        """Selects an item from the context menu by clicking a button or right-clicking in the node context menu.
        """
        self.element_should_be_present(element_id)

        # The function checks if the element has an attribute "nodeContextMenu" or "pressContextButton"
        if hasattr(self.session.findById(element_id), "nodeContextMenu"):
            self.session.findById(element_id).nodeContextMenu(menu_or_button_id)
        elif hasattr(self.session.findById(element_id), "pressContextButton"):
            self.session.findById(element_id).pressContextButton(menu_or_button_id)
        # The element has neither attributes, give an error message
        else:
            self.take_screenshot()
            element_type = self.get_element_type(element_id)
            message = "Cannot use keyword 'select context menu item' for element type '%s'" % element_type
            raise ValueError(message)
        self.session.findById(element_id).selectContextMenuItem(item_id)
        time.sleep(self.explicit_wait)

    def select_from_list_by_label(self, element_id, value):
        """Selects the specified option from the selection list.
        """
        element_type = self.get_element_type(element_id)
        if element_type == "GuiComboBox":
            self.session.findById(element_id).value = value
            time.sleep(self.explicit_wait)
        else:
            self.take_screenshot()
            message = "Cannot use keyword 'select from list by label' for element type '%s'" % element_type
            raise ValueError(message)

    def select_node(self, tree_id, node_id, expand=False):
        """Selects a node of a TableTreeControl 'tree_id' which is contained within a shell object.

        Use the Scripting tracker recorder to find the 'node_id' of the node.
        Expand can be set to True to expand the node. If the node cannot be expanded, no error is given.
        """
        self.element_should_be_present(tree_id)
        self.session.findById(tree_id).selectedNode = node_id
        if expand:
            #TODO: elegantere manier vinden om dit af te vangen
            try:
                self.session.findById(tree_id).expandNode(node_id)
            except com_error:
                pass
        time.sleep(self.explicit_wait)

    def select_node_link(self, tree_id, link_id1, link_id2):
        """Selects a link of a TableTreeControl 'tree_id' which is contained within a shell object.

        Use the Scripting tracker recorder to find the 'link_id1' and 'link_id2' of the link to select.
        """
        self.element_should_be_present(tree_id)
        self.session.findById(tree_id).selectItem(link_id1, link_id2)
        self.session.findById(tree_id).clickLink(link_id1, link_id2)
        time.sleep(self.explicit_wait)

    def select_radio_button(self, element_id):
        """Sets radio button to the specified value.
        """
        element_type = self.get_element_type(element_id)
        if element_type == "GuiRadioButton":
            self.session.findById(element_id).selected = True
        else:
            self.take_screenshot()
            message = "Cannot use keyword 'select radio button' for element type '%s'" % element_type
            raise ValueError(message)
        time.sleep(self.explicit_wait)

    def select_table_column(self, table_id, column_id):
        """Selects an entire column of a GridView 'table_id' which is contained within a shell object.

        Use the Scripting tracker recorder to find the 'column_id' of the column to select.
        """
        self.element_should_be_present(table_id)
        try:
            self.session.findById(table_id).selectColumn(column_id)
        except com_error:
            self.take_screenshot()
            message = "Cannot find Column_id '%s'." % column_id
            raise ValueError(message)
        time.sleep(self.explicit_wait)

    def select_table_row(self, table_id, row_num):
        """Selects an entire row of a table. This can either be a TableControl or a GridView 'table_id'
        which is contained within a shell object. The row is an index to select the row, starting from 0.
        """
        element_type = self.get_element_type(table_id)
        if (element_type == "GuiTableControl"):
            id = self.session.findById(table_id).getAbsoluteRow(row_num)
            id.selected = -1
        else:
            try:
                self.session.findById(table_id).selectedRows = row_num
            except com_error:
                self.take_screenshot()
                message = "Cannot use keyword 'select table row' for element type '%s'" % element_type
                raise ValueError(message)
        time.sleep(self.explicit_wait)

    def send_vkey(self, vkey_id, window=0):
        """Sends a SAP virtual key combination to the window, not into an element.
        If you want to send a value to a text field, use `input text` instead.

        To send a vkey, you can either use te *VKey ID* or the *Key combination*.

        Sap Virtual Keys (on Windows)
        | *VKey ID* | *Key combination*     | *VKey ID* | *Key combination*     | *VKey ID* | *Key combination*     |
        | *0*       | Enter                 | *26*      | Ctrl + F2             | *72*      | Ctrl + A              |
        | *1*       | F1                    | *27*      | Ctrl + F3             | *73*      | Ctrl + D              |
        | *2*       | F2                    | *28*      | Ctrl + F4             | *74*      | Ctrl + N              |
        | *3*       | F3                    | *29*      | Ctrl + F5             | *75*      | Ctrl + O              |
        | *4*       | F4                    | *30*      | Ctrl + F6             | *76*      | Shift + Del           |
        | *5*       | F5                    | *31*      | Ctrl + F7             | *77*      | Ctrl + Ins            |
        | *6*       | F6                    | *32*      | Ctrl + F8             | *78*      | Shift + Ins           |
        | *7*       | F7                    | *33*      | Ctrl + F9             | *79*      | Alt + Backspace       |
        | *8*       | F8                    | *34*      | Ctrl + F10            | *80*      | Ctrl + Page Up        |
        | *9*       | F9                    | *35*      | Ctrl + F11            | *81*      | Page Up               |
        | *10*      | F10                   | *36*      | Ctrl + F12            | *82*      | Page Down             |
        | *11*      | F11 or Ctrl + S       | *37*      | Ctrl + Shift + F1     | *83*      | Ctrl + Page Down      |
        | *12*      | F12 or ESC            | *38*      | Ctrl + Shift + F2     | *84*      | Ctrl + G              |
        | *14*      | Shift + F2            | *39*      | Ctrl + Shift + F3     | *85*      | Ctrl + R              |
        | *15*      | Shift + F3            | *40*      | Ctrl + Shift + F4     | *86*      | Ctrl + P              |
        | *16*      | Shift + F4            | *41*      | Ctrl + Shift + F5     | *87*      | Ctrl + B              |
        | *17*      | Shift + F5            | *42*      | Ctrl + Shift + F6     | *88*      | Ctrl + K              |
        | *18*      | Shift + F6            | *43*      | Ctrl + Shift + F7     | *89*      | Ctrl + T              |
        | *19*      | Shift + F7            | *44*      | Ctrl + Shift + F8     | *90*      | Ctrl + Y              |
        | *20*      | Shift + F8            | *45*      | Ctrl + Shift + F9     | *91*      | Ctrl + X              |
        | *21*      | Shift + F9            | *46*      | Ctrl + Shift + F10    | *92*      | Ctrl + C              |
        | *22*      | Ctrl + Shift + 0      | *47*      | Ctrl + Shift + F11    | *93*      | Ctrl + V              |
        | *23*      | Shift + F11           | *48*      | Ctrl + Shift + F12    | *94*      | Shift + F10           |
        | *24*      | Shift + F12           | *70*      | Ctrl + E              | *97*      | Ctrl + #              |
        | *25*      | Ctrl + F1             | *71*      | Ctrl + F              |           |                       |

        Examples:
        | *Keyword*     | *Attributes*      |           |
        | send_vkey     | 8                 |           |
        | send_vkey     | Ctrl + Shift + F1 |           |
        | send_vkey     | Ctrl + F7         | window=1  |
        """
        vkey_id = str(vkey_id)
        vkeys_array = ["ENTER", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
                       None, "SHIFT+F2", "SHIFT+F3", "SHIFT+F4", "SHIFT+F5", "SHIFT+F6", "SHIFT+F7", "SHIFT+F8",
                       "SHIFT+F9", "CTRL+SHIFT+0", "SHIFT+F11", "SHIFT+F12", "CTRL+F1", "CTRL+F2", "CTRL+F3", "CTRL+F4",
                       "CTRL+F5", "CTRL+F6", "CTRL+F7", "CTRL+F8", "CTRL+F9", "CTRL+F10", "CTRL+F11", "CTRL+F12",
                       "CTRL+SHIFT+F1", "CTRL+SHIFT+F2", "CTRL+SHIFT+F3", "CTRL+SHIFT+F4", "CTRL+SHIFT+F5",
                       "CTRL+SHIFT+F6", "CTRL+SHIFT+F7", "CTRL+SHIFT+F8", "CTRL+SHIFT+F9", "CTRL+SHIFT+F10",
                       "CTRL+SHIFT+F11", "CTRL+SHIFT+F12", None, None, None, None, None, None, None, None, None, None,
                       None, None, None, None, None, None, None, None, None, None, None, "CTRL+E", "CTRL+F", "CTRL+A",
                       "CTRL+D", "CTRL+N", "CTRL+O", "SHIFT+DEL", "CTRL+INS", "SHIFT+INS", "ALT+BACKSPACE",
                       "CTRL+PAGEUP", "PAGEUP",
                       "PAGEDOWN", "CTRL+PAGEDOWN", "CTRL+G", "CTRL+R", "CTRL+P", "CTRL+B", "CTRL+K", "CTRL+T",
                       "CTRL+Y",
                       "CTRL+X", "CTRL+C", "CTRL+V", "SHIFT+F10", None, None, "CTRL+#"]

        # If a key combi is given, replace vkey_id by correct id based on given combination
        if not vkey_id.isdigit():
            search_comb = vkey_id.upper()
            search_comb = search_comb.replace(" ", "")
            search_comb = search_comb.replace("CONTROL", "CTRL")
            search_comb = search_comb.replace("DELETE", "DEL")
            search_comb = search_comb.replace("INSERT", "INS")
            try:
                vkey_id = vkeys_array.index(search_comb)
            except ValueError:
                if search_comb == "CTRL+S":
                    vkey_id = 11
                elif search_comb == "ESC":
                    vkey_id = 12
                else:
                    message = "Cannot find given Vkey, provide a valid Vkey number or combination"
                    raise ValueError(message)

        try:
            self.session.findById("wnd[% s]" % window).sendVKey(vkey_id)
        except com_error:
            self.take_screenshot()
            message = "Cannot send Vkey to given window, is window wnd[% s] actually open?" % window
            raise ValueError(message)
        time.sleep(self.explicit_wait)

    def set_cell_value(self, table_id, row_num, col_id, text):
        """Sets the cell value for the specified cell of a GridView 'table_id' which is contained within a shell object.

        Use the Scripting tracker recorder to find the 'col_id' of the cell to set.
        """
        self.element_should_be_present(table_id)

        try:
            self.session.findById(table_id).modifyCell(row_num, col_id, text)
            logger.info("Typing text '%s' into cell '%s', '%s'" % (text, row_num, col_id))
            time.sleep(self.explicit_wait)
        except com_error:
            self.take_screenshot()
            message = "Cannot type text '%s' into cell '%s', '%s'" % (text, row_num, col_id)
            raise ValueError(message)

    def set_explicit_wait(self, speed):
        """Sets the delay time that is waited after each SapGui keyword.

        The value can be given as a number that is considered to be seconds or as a human-readable string like 1 second
        or 700 ms.

        This functionality is designed to be used for demonstration and debugging purposes. It is not advised to use
        this keyword to wait for an element to appear or function to finish.

         *Possible time formats:*
        | miliseconds       | milliseconds, millisecond, millis, ms |
        | seconds           | seconds, second, secs, sec, s         |
        | minutes           | minutes, minute, mins, min, m         |

         *Example:*
        | *Keyword*         | *Attributes*      |
        | Set explicit wait | 1                 |
        | Set explicit wait | 3 seconds         |
        | Set explicit wait | 500 ms            |
        """
        speed = str(speed)
        if not speed.isdigit():
            speed_elements = speed.split()
            if not speed_elements[0].isdigit():
                message = "The given speed %s doesn't begin with an numeric value, but it should" % speed
                raise ValueError(message)
            else:
                speed_elements[0] = float(speed_elements[0])
                speed_elements[1] = speed_elements[1].lower()
                if (speed_elements[1] == "seconds"
                        or speed_elements[1] == "second"
                        or speed_elements[1] == "s"
                        or speed_elements[1] == "secs"
                        or speed_elements[1] == "sec"):
                    self.explicit_wait = speed_elements[0]
                elif (speed_elements[1] == "minutes"
                      or speed_elements[1] == "minute"
                      or speed_elements[1] == "mins"
                      or speed_elements[1] == "min"
                      or speed_elements[1] == "m"):
                    self.explicit_wait = speed_elements[0] * 60
                elif (speed_elements[1] == "milliseconds"
                      or speed_elements[1] == "millisecond"
                      or speed_elements[1] == "millis"
                      or speed_elements[1] == "ms"):
                    self.explicit_wait = speed_elements[0] / 1000
                else:
                    self.take_screenshot()
                    message = "%s is a unknown time format" % speed_elements[1]
                    raise ValueError(message)
        else:
            # No timeformat given, so time is expected to be given in seconds
            self.explicit_wait = float(speed)

    def set_focus(self, element_id):

        """Sets the focus to the given element.
        """
        element_type = self.get_element_type(element_id)
        if element_type != "GuiStatusPane":
            self.session.findById(element_id).setFocus()
        time.sleep(self.explicit_wait)

    def take_screenshot(self, screenshot_name="sap-screenshot"):
        """Takes a screenshot, only if 'screenshots on error' has been enabled,
        either at import of with keyword `enable screenshots on error`.

        This keyword uses Robots' internal `Screenshot` library.
        """
        if self.take_screenshots == True:
            self.screenshot.take_screenshot(screenshot_name)

    def unselect_checkbox(self, element_id):
        """Removes selection of checkbox identified by locator.
        Does nothing if the checkbox is not selected.
        """
        element_type = self.get_element_type(element_id)
        if element_type == "GuiCheckBox":
            self.session.findById(element_id).selected = False
        else:
            self.take_screenshot()
            message = "Cannot use keyword 'unselect checkbox' for element type '%s'" % element_type
            raise ValueError(message)
        time.sleep(self.explicit_wait)
    
    #New scripts
        
    def is_imp_notes_existing(self, modal_window_id, modal_continue_id):   
        try:
            content = self.session.findById(modal_window_id).Text
            if content == "SAINT: Important SAP Notes":
                print("Modal window exists")
                self.session.findById(modal_continue_id).press()
                return content
            else:
                print("Modal window does not exist.")
            

        except Exception as e:
            print(f"Error: {str(e)}")
            return False
        
    def get_finish_cell_text(self, finish_str, button_id, status_line, refresh_id):
        try:
            while True:
                cell_text_1 = self.session.findById(status_line).Text
                cell_text_2 = cell_text_1[1:]

                if finish_str == cell_text_2:
                    self.session.findById(button_id).press()
                    print("Installation Successful")
                    break  # Exit the loop if the condition is met
                else:
                    self.session.findById(refresh_id).press()
                    #print("No Match")
                    time.sleep(60)

            return cell_text_2
            
        except Exception as e:
            return f"Error: {str(e)}"
            # return cell_text_2
             
    def get_finish_cell_text1(self, finish_str, button_id, status_line, refresh_id):
        try:
            while True:
                cell_text_1 = self.session.findById(status_line).Text
                # cell_text_2 = cell_text_1

                if finish_str == cell_text_1:
                    self.session.findById(button_id).select()
                    print("Installation Successful")
                    break  # Exit the loop if the condition is met
                else:
                    self.session.findById(refresh_id).press()
                    #print("No Match")
                    time.sleep(30)

            return cell_text_1

        except Exception as e:
            return f"Error: {str(e)}"
            # return cell_text_2
 
    def get_maintenance_certificate_text(self, certificate_id):
        try:
            found = False
            while not found:
                license_text = self.session.findById(certificate_id).Text
                license_split = license_text.split()
                license_text_1 = ' '.join(license_split[:-1])
                     
                if license_text_1 == "A valid maintenance certificate was found for system":
                    print("License available to proceed further")
                    found = True    
                else:
                    print("No Valid Maintenance Certificate is found in the System")
                    break
    
        except Exception as e:
            return f"Error: {str(e)}"
        
    def run_time_error_existing(self, runtimeerror_id, back_id):   
        try:
            content = self.session.findById(runtimeerror_id).Text
            if content == "Runtime Error - Description of Exception":
                print("Runtime error exists")
                self.session.findById(back_id).press()
                return content
            else:
                print("Runtime error does not exist.")
            

        except Exception as e:
            print(f"Error: {str(e)}")
            return False
        
    def no_queue_pending(self, no_Queue_id):   
        try:
            content = self.session.findById(no_Queue_id).Text
            if content == "No queue has been defined":
                print("No queue available")
                return content
            else:
                print("Queue is available")
            

        except Exception as e:
            print(f"Error: {str(e)}")
            return False
        
    def import_information(self, text_id, import_id, text1_id, continue_id):  
        try:
            found = False
            while not found:
                importstart_text = self.session.findById(text_id).Text
                importstart_split = importstart_text.split()
                importstart_text_1 = ' '.join(importstart_split[:3] + importstart_split[3:])

                importcomplete_text = self.session.findById(text1_id).Text
                importcomplete_split = importcomplete_text.split()
                importcomplete_text_1 = ' '.join(importcomplete_split[:2] + importcomplete_split[3:])

                if importstart_text_1 == "The SPAM/SAINT update is being imported.":
                    print("Import started")
                    found = True 
                    self.session.findById(import_id).press()
                    return importstart_text_1   
                elif importcomplete_text_1 == "SPAM/SAINT update has already been imported successfully":
                    print("Import completed")
                    found = True
                    self.session.findById(continue_id).press()
                    return importcomplete_text_1

        except Exception as e:
            print(f"Error: {str(e)}")
            return False
        

    def import_success(self, text_id, continue_id):  
        try:
            found = False
            while not found:
                importsuccess_text = self.session.findById(text_id).Text
                importsuccess_split = importsuccess_text.split()
                importsuccess_text_1 = ' '.join(importsuccess_split[:1] + importsuccess_split[2:])

                if importsuccess_text_1 == "Queue SAPK-74002INSTPI imported successfully":
                    print("Import success")
                    found = True 
                    self.session.findById(continue_id).press()
                    return importsuccess_text_1   
                else:
                    print("Import not completed")
                    
        except Exception as e:
            print(f"Error: {str(e)}")
            return False
    
    def epilogue_handling(self, epi_id, spam_id, window_1_id, import_id):   
        try:   
            content = self.session.findById(epi_id).Text
            if content == "EPILOGUE":
                print("patch in Epilogue")
                self.session.findById(spam_id).select()
                content1 = self.session.findById(window_1_id).Text
                if content1 == "phase EPILOGUE.":
                    self.session.findById(import_id).press()
                    return content1
                else:
                    print("phase is not EPILOGUE")
                return content
            
            else:
                print("Queue is not confirmed")

        except Exception as e:
            print(f"Error: {str(e)}")
            return False
        
    def version_print(self, version_id):   
        try:   
            content = self.session.findById(version_id).Text
            content_split = content.split()
            content1 = ' '.join(content_split[:-1])

            if content1 == "Support Package Manager - Version":
                print(content)
                return content
            else:
                print("check spam version manually")

        except Exception as e:
            print(f"Error: {str(e)}")
            return False
         
        
    def confirm(self, content, confirm_id, confirm_queue, refresh1_id):
        try:
            content = self.session.findById(confirm_id).Text

            if content == "Confirm queue":
                self.session.findById(confirm_queue).press()
                print("Confirm queue")
            else:
                self.session.findById(refresh1_id).press()
                #time.sleep(60)

            return content

        except Exception as e:
            print(f"Error: {str(e)}")
            return False

    def is_transaction_locked_by(self, window_id, button_id):
        try:
            lock_text = self.session.findById(window_id).Text
            lock_text_split = lock_text.split()
            lock_text1 = ' '.join(lock_text_split[:-1])
            if lock_text1 == "transaction SPAM is locked by":
                print(f"{lock_text}, so exiting the script")
                self.session.findById(button_id).press()
                self.run_transaction("/nex")
                return lock_text
            else:
                pass
        except Exception as e:
            print(f"Error: {str(e)}")
            return False
    
        
    def spam_search_and_select_label(self, user_area_id, search_text, max_scrolls=50):
        try:
            user_area = self.session.findById(user_area_id)
            scroll_count = 0
            found = False

            while scroll_count < max_scrolls and not found:
                for child in user_area.Children:
                    if child.Text == search_text:
                        print(f"Text Found: {child.Text}")
                        child.SetFocus()
                        self.session.findById("wnd[1]").sendVKey(2)  # Simulate Enter key press
                        found = True
                        break

                if not found:
                    # Scroll down and wait for the content to update
                    print(scroll_count)
                    self.session.findById("wnd[1]").sendVKey(82)  # 86 is the code for Page Down
                    time.sleep(1)  # Adjust as necessary for GUI response time
                    scroll_count += 1

            if not found:
                print("Text not found after scrolling through all pages.")

        except Exception as e:
            print(f"Error: {e}")

    def select_spam_based_on_text(self, control_id, search_text):
        try:
            control = self.session.findById(control_id)
            row_count = control.RowCount  # Assuming the control has a RowCount property
            print(row_count)
            for row in range(row_count):
                print(row)
                cell_value=control
                cell_value = control.GetCellValue(row,"COMPONENT")
                print(cell_value)
                if search_text in cell_value:
                    result = row
                    print("Text Found in ${row}")
                    return row
                else:
                    print("not found")
        except Exception as e:
            return f"Error: {e}"
    
    def spam_multiple_patch_version_select(self, comp_id, search_comp_1, search_patch_1):
        search_comp = ast.literal_eval(search_comp_1)
        search_patch = ast.literal_eval(search_patch_1)
        # print(search_comp, type(search_comp))
        # print(search_patch, type(search_patch))
        # if not len(search_comp) == len(search_patch):
        #     sys.exit() 
        
        comp_area = self.session.FindById(comp_id)
        row_count = comp_area.RowCount

        for i in range(len(search_comp)):
            comp = search_comp[i]
            patch = search_patch[i]
            print(comp, patch)
            
            try:
                for x in range(row_count + 1):
                    cell_value = comp_area.GetCellValue(x, "COMPONENT")
                    print(x, cell_value)
                    if cell_value == comp:
                        comp_area.modifyCell(x,"PATCH_REQ",patch)
                        cell_value_1 = comp_area.GetCellValue(x, "COMPONENT")
                        print("Cell Value 1", cell_value_1)
            except Exception as e:
                 return f"Error: {e}"
    
    def double_click_on_tree_item(self, tree_id, id):
        try:
            tree = self.session.findById(tree_id)
            tree.selectedNode = id
            tree.doubleClickNode(id)
        except Exception as e:
            print("Error: {e}")

    def set_caret_position(self, element_id, position):
        try:
            element = self.session.findById(element_id)
            element.caretposition = position

        except Exception as e:
            print("Error: {e}")
            
    def scot_tree(self, tree_id):
        try:
            tree = self.session.findById(tree_id)
            tree.DoubleClickNode("         23")
    
        except Exception as e:
            print("Error: {e}")

    def select_label(self, user_area_id, search_text, max_scrolls=50):
        try:
            user_area = self.session.findById(user_area_id)
            scroll_count = 0
            found = False

            while scroll_count < max_scrolls and not found:
                for child in user_area.Children:
                    if child.Text == search_text:
                        print(f"Text Found: {child.Text}")
                        child.SetFocus()
                        self.session.findById("wnd[0]").sendVKey(2)  # Simulate Enter key press
                        found = True
                        break

                if not found:
                    # Scroll down and wait for the content to update
                    print(scroll_count)
                    self.session.findById("wnd[0]").sendVKey(82)  # 86 is the code for Page Down
                    # time.sleep(1)  # Adjust as necessary for GUI response time
                    scroll_count += 1

            if not found:
                print("Text not found after scrolling through all pages.")

        except Exception as e:
            print(f"Error: {e}")    

    def selected_rows(self, tree_id, first_visible_row):
        try:
            tree = self.session.findById(tree_id)

            tree.firstVisibleRow = first_visible_row
                

        except Exception as e:
            print(f"Error: {e}")

    def scroll_pagedown(self, window_id):
        try:
            # session.findById("wnd[0]/usr/txtCERT-FPSHA1").setFocus()
            self.session.findById(window_id).setFocus()
            self.session.findById("wnd[0]").TabBackward()
        except Exception as e:
            print(f"Error: {e}")

    def get_grid_ids(self, grid_id):
        try:
            grid_control = self.session.findById(grid_id)

            # Get the number of rows and columns in the grid
            rows = grid_control.RowCount
            columns = grid_control.ColumnCount

            # Retrieve the item IDs and column IDs
            item_ids = [f"{grid_id}/shell[0]/shell[{i}]" for i in range(rows)]
            column_ids = [f"{grid_id}/shell[0]/shell[0]/shell[{i}]" for i in range(columns)]

            return item_ids, column_ids

        except Exception as e:
            print(f"Error: {e}")
            return None, None

    def select_item_from_guilabel(self, user_id, search_text):
        user_area = self.session.findById(user_id)
        labels = [child.Text for child in user_area.Children]
        item_count = user_area.Children.Count
        # print("User Area Labels:", labels, item_count)
        for i in range(item_count):
            element = user_area.Children.ElementAt(i)
            if element.Text.strip() == search_text.strip():
                print(f"Element found: {element.Text}")
                element.SetFocus()
                self.session.findById("wnd[0]").sendVKey(2)
                return
            
    def rows_from_stms(self, table_id): 
        print(table_id)
        row_count = self.session.findById(table_id).rowcount
        print(row_count)
        column_count = self.session.findbyId(table_id).columncount
        print(column_count)
        try:
            for row in range(row_count):
                print(row)
                cell_value_1= self.session.findById(table_id).GetCellValue(row, "SYSNAM")
                self.session.findById(table_id).DoubleClick(row, "SYSNAM")
                print(cell_value_1)
                return cell_value_1
        except Exception as e:
            return f"Error: {e}"  

    def get_cell_value_from_gridtable(self, table_id):
        try:
            control = self.session.findById(table_id)
            row_count = control.RowCount  # Assuming the control has a RowCount property
            col_count = control.ColumnCount
            print(row_count, col_count)
            for row in range(row_count):
                print(row)
                cell_value = control.GetCellValue(row, "DEST")
                print(cell_value)
                return cell_value
        except Exception as e:
            return f"Error: {e}"

    
    def get_no_entries_found_text(self, text_id):
        try:
            found = False
            while not found:
                entry_text = self.session.findById(text_id).Text
                                     
                if entry_text == "No entries found that match selection criteria":
                    print("No entries found that match selection criteria")
                    found = True    
                else:
                    print("Entries are displayed")
                    break
        except Exception as e:
            return f"Error: {e}"
    
    
    def multiple_logon_handling(self, logon_window_id, logon_id, continue_id):  
        try:
            content = self.session.findById(logon_window_id).Text
            if content == "License Information for Multiple Logons":
                print("Multiple logon exists")
                self.session.findById(logon_id).selected = True
                self.session.findById(continue_id).press()
                return content
            else:
                print("Multiple logon does not exist.")
        except Exception as e:
            return f"Error: {e}"      

    def table_scroll(self, table_id, first_visible_row):
        try:
            # tree = self.session.findById(table_id)
            # tree.firstVisibleRow = first_visible_row
            self.session.findById("wnd[0]/usr/cntlGRID1/shellcont/shell").currentCellRow = 29
            self.session.findById("wnd[0]/usr/cntlGRID1/shellcont/shell").firstVisibleRow = 6
            self.session.findById("wnd[0]/usr/cntlGRID1/shellcont/shell").selectedRows = "29"
        except Exception as e:
            print(f"Error: {e}")

    def double_click_on_inside_table(self, tree_id, row_number):
        try:
            tree = self.session.findById(tree_id)
            node = tree.GetNode(row_number)
            node.DoubleClick()
        except Exception as e:
            print(f"Error: {e}")
 
    def double_click_on_current_cell(self, table_id):
        try:
            table = self.session.findById(table_id)
            table.DoubleClickCurrentCell()  # Perform a double-click action on the current cell
 
        except Exception as e:
            print(f"Error: {e}")

    def expand_Element(self, tree_id, node_id):
        try:
            element = self.session.findById(tree_id)
            element.expandNode(f"{node_id}")
        except Exception as e:
            print(f"An error occurred while expanding node: {e}")  

    def select_top_node(self,tree_id, node_id,expand=False):
        self.element_should_be_present(tree_id)
        self.session.findById(tree_id).selectedNode = node_id
        if expand:
            #TODO: elegantere manier vinden om dit af te vangen
            try:
                self.session.findById(tree_id).topNode(node_id)
            except com_error:
                pass
        time.sleep(self.explicit_wait) 

    def expand_node(self, tree_id, node_id):
        element = self.session.findById(tree_id)
        element.expandNode(f"{node_id}")

    def select_item(self, tree_id, nodeid1, nodeid2):
        element=self.session.findById(tree_id)
        element.selectItem(f"{nodeid1}",nodeid2)

    def get_open_items(self, status_id):
        try:
            status = self.session.findById(status_id).Text
            pattern = r"(\d+)\s+items\s+displayed"
            match = re.search(pattern, status)
            if match:
                open_items = match.group(1)
                return open_items
            else:
                print("No match found")
                return None
        except Exception as e:
            return f"Error: {str(e)}"
        
    def set_key_value(self, element_id, key_value):
        self.session.FindById(element_id).key = key_value

    def double_click_table(self, table_id, row, column):
        self.session.FindById(table_id).doubleClickCurrentCell(row, column)

    def search_and_select_lock(self, table_id, lock):
        try:
            table = self.session.FindById(table_id)
            row_count = table.RowCount  # Assuming the control has a RowCount property
            print(row_count)
            for row in range(row_count):
                print(row)
                cell_value=table
                cell_value = table.GetCellValue(row,"GNAME")
                print(cell_value)
                if lock in cell_value:
                    result = row
                    self.session.findById(table_id).selectedRows = row
                    print("Text Found in ${row}")
                    return row
                else:
                    print("not found")
        except Exception as e:
            return f"Error: {e}"
    def window_handling(self, element_id, text, button_id):
        window = self.session.findById(element_id).Text
        if window == text :
            self.session.findById(button_id).press()
            
    def clear_field_text(self, field_id):
        try:
            field = self.session.findById(field_id)
            field.Text = ""
            print(f"Text cleared in field with ID: {field_id}")
        except Exception as e:
            print(f"Error: {e}")
    
    def Excel_Arrange(self, file_location, sheet_name, filename):
        try:
            file_path = f"{file_location}\\{filename}"
            df = pd.read_excel(file_path, sheet_name=sheet_name, header=None)
            df = df.applymap(lambda x: x.strip() if isinstance(x, str) else x)
            df = df.iloc[4:].reset_index(drop=True)
            df.columns = df.iloc[0]
            df = df[1:].reset_index(drop=True)
            df.dropna(how='all', inplace=True)
            df.dropna(axis=1, how='all', inplace=True)
            with pd.ExcelWriter(file_path, engine='openpyxl', mode='a', if_sheet_exists='replace') as writer:
                df.to_excel(writer, sheet_name=sheet_name, index=False)
        except Exception as e:
            pass

    def software_component_version(self, comp_id, search_comp):      
        comp_area = self.session.FindById(comp_id)
        row_count = comp_area.RowCount
        try:
            for x in range(row_count):
                print (x)   
                cell_value = comp_area.GetCellValue(x, "COMPONENT")
                print (cell_value)
                if cell_value == search_comp:
                    version = comp_area.GetCellValue(x, "RELEASE")
                    print(f"Found version for {search_comp}: {version}")
                    return version
                    break  
                else:
                    print(f"Component {search_comp} not found.")
        except Exception as e:
            print(f"Error while searching for {search_comp}: {e}")

    def software_support_package_version(self, comp_id, search_comp):      
        comp_area = self.session.FindById(comp_id)
        row_count = comp_area.RowCount
        try:
            for x in range(row_count):
                # print (x)   
                cell_value = comp_area.GetCellValue(x, "COMPONENT")
                # print (cell_value)
                if cell_value == search_comp:
                    patch = comp_area.GetCellValue(x, "HIGH_PATCH")
                    # print(f"Found version for {search_comp}: {patch}")
                    return patch
                    break  
                else:
                    print(f"Component {search_comp} not found.")
        except Exception as e:
            print(f"Error while searching for {search_comp}: {e}")

    def select_profile_label(self, user_area_id, search_text, max_scrolls=5):
        try:
            user_area = self.session.findById(user_area_id)
            scroll_count = 0
            found = False
 
            while scroll_count < max_scrolls and not found:
                for child in user_area.Children:
                    if child.Text == search_text:
                        print(f"Text Found: {child.Text}")
                        child.SetFocus()
                        # self.session.findById("wnd[1]").sendVKey(2)  # Simulate Enter key press
                        found = True
                        break
 
                if not found:
                    # Scroll down and wait for the content to update
                    print(scroll_count)
                    self.session.findById("wnd[1]").sendVKey(82)  # 86 is the code for Page Down
                    time.sleep(1)  # Adjust as necessary for GUI response time
                    scroll_count += 1
 
            if not found:
                print("Text not found after scrolling through all pages.")
 
        except Exception as e:
            print(f"Error: {e}")

    def check_parameter_found(self, lable_id, parameter):
        user_area = self.session.findById(lable_id)
        item_count = user_area.Children.Count
        for i in range(item_count):
            element = user_area.Children.ElementAt(i)
            if element.Text.strip() == parameter.strip():
                print(element.Text)
                return(element.Text)
        not_found_message = f"Search text {parameter} not found"
        print(f"Search text {parameter} not found")
        return not_found_message
    
    def get_parameter_value(self, lable_id, parameter):
        user_area = self.session.findById(lable_id)
        item_count = user_area.Children.Count
        for i in range(item_count):
            element = user_area.Children.ElementAt(i)
            if element.Text.strip() == parameter.strip():
                element.setFocus()
                self.session.findById("wnd[0]").sendVKey(2)
                return
    
    def manage_window(self, element_id, text, button_id):
        try:
            window_title = self.session.findById(element_id).Text
            window_title_split = window_title.split()
            window = " ".join(window_title_split[:-1])
            if window == text :
                self.session.findById(button_id).press()
            else:
                print(window_title)
        except Exception as e:
            print(f"Error: {e}")

    def double_click_current_cell_value(self, element_id, cell_value):
        try:
            element = self.session.findById(element_id)
            element.currentCellColumn = cell_value
            element.doubleClickCurrentCell()
        except Exception as e:
            print(f"Error: {e}")

    def get_file_content(Self, file_path, ):
        
        with open(file_path, 'r') as file:
            content = file.read()
        return content
    
    def select_org_label(self, user_area_id, search_text, max_scrolls=5):
        try:
            user_area = self.session.findById(user_area_id)
            scroll_count = 0
            found = False

            while scroll_count < max_scrolls and not found:
                for child in user_area.Children:
                    if child.Text == search_text:
                        print(f"Text Found: {child.Text}")
                        child.SetFocus()
                        # self.session.findById("wnd[1]").sendVKey(2)  # Simulate Enter key press
                        found = True
                        break

                if not found:
                    # Scroll down and wait for the content to update
                    print(scroll_count)
                    self.session.findById("wnd[1]").sendVKey(82)  # 86 is the code for Page Down
                    time.sleep(1)  # Adjust as necessary for GUI response time
                    scroll_count += 1

            if not found:
                print("Text not found after scrolling through all pages.")

        except Exception as e:
            print(f"Error: {e}")

    def window_handling(self, window_id, text, button_id):   
        try:   
            content = self.session.findById(window_id).Text
            if content == text:
                print(content)
                self.session.findById(button_id).press()
                return(content)                
            else:
                print(content)
        except Exception as e:
            print(f"Error: {e}")

    def quantity_handling(self, window_id, text, button_id1, button_id2):   
        try:   
            content = self.session.findById(window_id).Text
            if content == text:
                print(content)
                self.session.findById(button_id1).press()
                self.session.findById(button_id2).press()
                return(content)                
            else:
                print(content)
        except Exception as e:
            print(f"Error: {e}")

    def incomplete_log_handle(self, window_id, text1, button_id1, element_id, text2, button_id2):   
        try:   
            content = self.session.findById(window_id).Text
            if content == text1:
                print(content)
                self.session.findById(button_id1).press()
                self.session.findById(element_id).text = text2
                self.session.findById("wnd[0]").sendVKey(0)
                self.session.findById(button_id2).press()
                return(content)                
            else:
                print(content)
        except Exception as e:
            print(f"Error: {e}")
    
    def quantity_select(self, material, quantity, amount, window_id, text, button_id1, button_id2, error_id):
        mat_txt = "wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG/ctxtRV45A-MABNR"
        qty_txt = "wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG/txtRV45A-KWMENG"
        amt_txt = "wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG/txtKOMV-KBETR"
        try:
            for i in range(len(material)):
                mat_id = f"{mat_txt}[1,{i}]"
                print(mat_id)
                qty_id = f"{qty_txt}[3,{i}]"
                print(qty_id)
                amt_id = f"{amt_txt}[15,{i}]"
                print(amt_id)
                print(material[i])
                print(quantity[i])
                print(amount[i])
                self.session.findById(mat_id).text = material[i]
                self.session.findById(qty_id).text = quantity[i]
                self.session.findById(amt_id).text = amount[i]
                self.session.findById("wnd[0]").sendVKey(0)
                self.exceed_quantity_handling(error_id)
                time.sleep(2)
                self.quantity_handling(window_id, text, button_id1, button_id2)
                time.sleep(2)             

        except Exception as e:
            print(e)

    def picked_qty_select(self, picked_qty):
        picked_txt = "wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV50A:1102/tblSAPMV50ATC_LIPS_OVER/txtLIPSD-PIKMG"
        
        try:
            for i in range(len(picked_qty)):
                picked_id = f"{picked_txt}[18,{i}]"
                print(picked_id)
                print(picked_qty[i])
                
                self.session.findById(picked_id).text = picked_qty[i]
                
                self.session.findById("wnd[0]").sendVKey(0)                         

        except Exception as e:
            print(e)



    def exceed_quantity_handling(self, error_id):
        try:
            status = self.session.findById(error_id).text
            print(status)
            status_split = status.split()
            status_splits = status_split[:-1]
            status_text = [status_split for status_split in status_splits if not status_split.isnumeric()]  # Fix the index here
            status1 = ' '.join(status_text)
            print(status1)
            if status1 == "Reorder point for item has been exceeded:":
                found = True
                self.session.findById("wnd[0]").sendVKey(0)
                time.sleep(5)
                return status
            else:
                print(status)  # Fix the variable name here
        except Exception as e:
            print(f"Error: {e}")

    def sales_order_number(self, status_id):
        try:
            status = self.session.findById(status_id).text
            print(status)
            pattern = r'\b\d+\b'
            print(pattern)
            order_numbers = re.findall(pattern, status)
            print(order_numbers)
            if order_numbers:
                order_number = order_numbers[0]
                print("Order Number:", order_number)
                return order_number
            else:
                print("No order number found.")
        except Exception as e:
            print(f"Error: {e}")

    def Outbound_number(self, status_id):
        try:
            # Retrieve the status text
            status = self.session.findById(status_id).text
            print(status)

            # Updated pattern to specifically match the number after "Outbound delivery"
            pattern = r'Outbound delivery (\d+) saved'
            
            # Find all matching numbers
            order_numbers = re.findall(pattern, status)
            print(order_numbers)
            
            if order_numbers:
                # The first match is the order number we're interested in
                order_number = order_numbers[0]
                print("Order Number:", order_number)
                return order_number
            else:
                print("No order number found.")
        except Exception as e:
            print(f"Error: {e}")

    def output_handling(self, window_id, text, label_id, button_id):   
        try:   
            content = self.session.findById(window_id).Text
            if content == text:
                print(content)
                status = self.session.findById(label_id).text
                print(status)
                status_split = status.split()
                status_splits = status_split[:-1]
                status_text = [status_split for status_split in status_splits if not status_split.isnumeric()]  # Fix the index here
                status1 = ' '.join(status_text)
                print(status1)
                if status1 == "IDoc was added and passed for output":
                    found = True
                    self.session.findById(button_id).press()
                    time.sleep(5)
                    return status
                else:
                    print(status)  # Fix the variable name here
            else:
                print(status)
        except Exception as e:
            print(f"Error: {e}")

    def verify_the_idoc_jobs(self, table_id, search_text, process_log_btn, max_attempts=20):
        try:
            control = self.session.findById(table_id)
            row = control.RowCount
            # print(row)
            for i in range(row):
                job_id = f"{table_id}/ctxtDNAST-KSCHL[1,{i}]"
                # print(job_id)
                cell_value = self.session.findById(job_id).Text
                # print(cell_value)
                if cell_value == search_text:
                    status_id = f"{table_id}/lblDV70A-STATUSICON[0,{i}]"
                    status = self.session.findById(status_id).tooltip
                    print(status)
                    if status == "Successfully processed":
                        control.getAbsoluteRow(i).selected = -1
                        self.session.findById(process_log_btn).press()
                        time.sleep(5)
                        self.session.findById("wnd[1]").close()
                        break
                    else:
                        return(status)
                        time.sleep(10)                 
        except Exception as e:
            return f"Error: {e}"
        
    def quantity_select(self, material, quantity, amount):
        mat_txt = "wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG/ctxtRV45A-MABNR"
        qty_txt = "wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG/txtRV45A-KWMENG"
        amt_txt = "wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\01/ssubSUBSCREEN_BODY:SAPMV45A:4400/subSUBSCREEN_TC:SAPMV45A:4900/tblSAPMV45ATCTRL_U_ERF_AUFTRAG/txtKOMV-KBETR"
        
        try:
            for i in range(len(material)):
                mat_id = f"{mat_txt}[1,{i}]"
                qty_id = f"{qty_txt}[3,{i}]"
                amt_id = f"{amt_txt}[15,{i}]"
                
                print(f"Material ID: {mat_id}")
                print(f"Quantity ID: {qty_id}")
                print(f"Amount ID: {amt_id}")
                
                print(f"Material: {material[i]}")
                print(f"Quantity: {quantity[i]}")
                print(f"Amount: {amount[i]}")

                # Check if element exists before interacting
                if self.session.findById(mat_id) is not None:
                    self.session.findById(mat_id).text = material[i]
                else:
                    print(f"Material field not found: {mat_id}")
                    continue  # Skip to the next iteration

                if self.session.findById(qty_id) is not None:
                    self.session.findById(qty_id).text = quantity[i]
                else:
                    print(f"Quantity field not found: {qty_id}")
                    continue  # Skip to the next iteration

                if self.session.findById(amt_id) is not None:
                    self.session.findById(amt_id).text = amount[i]
                else:
                    print(f"Amount field not found: {amt_id}")
                    continue  # Skip to the next iteration

                # Process the entry
                self.session.findById("wnd[0]").sendVKey(0)
                # self.exceed_quantity_handling(error_id)
                # time.sleep(2)  # Ensure there is enough time between interactions
                # self.quantity_handling(window_id, text, button_id1, button_id2)
                # time.sleep(2)

        except Exception as e:
            print(f"An error occurred: {e}")

    def picked_qty_loc_select(self, picked_qty, location):
        picked_txt = "wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV50A:1104/tblSAPMV50ATC_LIPS_PICK/txtLIPSD-PIKMG"
        location_txt ="wnd[0]/usr/tabsTAXI_TABSTRIP_OVERVIEW/tabpT\\02/ssubSUBSCREEN_BODY:SAPMV50A:1104/tblSAPMV50ATC_LIPS_PICK/ctxtLIPS-LGORT"
        try:
            for i in range(len(picked_qty)):
                picked_id = f"{picked_txt}[7,{i}]"
                location_id =f"{location_txt}[3,{i}]"
                print(picked_id)
                print(location_id)
                print(picked_qty[i])
                print(location[i])
                self.session.findById(picked_id).text = picked_qty[i]
                self.session.findById(location_id).text = location[i]
                self.session.findById("wnd[0]").sendVKey(0)                         

        except Exception as e:
            print(e)

    def document_entry(self, doc_no):
        doc_txt = "wnd[0]/usr/tblSAPMV60ATCTRL_ERF_FAKT/ctxtKOMFK-VBELN"
        try:
            for i in range(len(doc_no)):
                picked_id = f"{doc_txt}[0,{i}]"
                print(picked_id)
                print(doc_no[i])
                self.session.findById(picked_id).text = doc_no[i]
                self.session.findById("wnd[0]").sendVKey(0)                         

        except Exception as e:
            print(e)


    def exceed_quantity_handling(self, error_id):
        try:
            status = self.session.findById(error_id).text
            print(status)
            status_split = status.split()
            status_splits = status_split[:-1]
            status_text = [status_split for status_split in status_splits if not status_split.isnumeric()]  # Fix the index here
            status1 = ' '.join(status_text)
            print(status1)
            if status1 == "Reorder point for item has been exceeded:":
                found = True
                self.session.findById("wnd[0]").sendVKey(0)
                time.sleep(5)
                return status
            else:
                print(status)  # Fix the variable name here
        except Exception as e:
            print(f"Error: {e}")

    def Extract_number(self, status_id):
        try:
            status = self.session.findById(status_id).text
            print(status)
            pattern = r'\b\d+\b'
            print(pattern)
            order_numbers = re.findall(pattern, status)
            print(order_numbers)
            if order_numbers:
                order_number = order_numbers[0]
                print("Order Number:", order_number)
                return order_number
            else:
                print("No order number found.")
        except Exception as e:
            print(f"Error: {e}")

    def close_window(self, window_id):
        self.session.findById(window_id).close()
        
    def to_upper(self, value):
        text = value.upper()
        print(text)
        return text
    def Delete_all_profile(self):
        try:
            self.session.findById("wnd[0]/usr/tabsTABSTRIP1/tabpPROF/ssubMAINAREA:SAPLSUID_MAINTENANCE:1103/cntlG_PROFILES_CONTAINER/shellcont/shell").setCurrentCell(-1, "")
            self.session.findById("wnd[0]/usr/tabsTABSTRIP1/tabpPROF/ssubMAINAREA:SAPLSUID_MAINTENANCE:1103/cntlG_PROFILES_CONTAINER/shellcont/shell").selectAll()
            self.session.findById("wnd[0]/usr/tabsTABSTRIP1/tabpPROF/ssubMAINAREA:SAPLSUID_MAINTENANCE:1103/cntlG_PROFILES_CONTAINER/shellcont/shell").pressToolbarButton("DEL_LINE")
        except:
            return  []
        
    def change_of_process(self, window_id, button_id):
        text = self.session.findById(window_id).text
        text_split = text.split()
        window = " ".join(text_split[:-1])
        if window == "Change processor of SAP Note":
            self.session.findById(button_id).press()

    def create_transport(self, window_id, create_button, text, finish_btn,):
        window = self.session.findById(window_id).Text
        if window == "Prompt for local Workbench request":
            transport = self.session.findById("wnd[1]/usr/ctxtKO008-TRKORR").Text
            if transport == "":
                self.session.findById(create_button).press()
                self.session.findById("wnd[2]/usr/txtKO013-AS4TEXT").Text = text
                self.session.findById(finish_btn).press()
                self.session.findById("wnd[1]/tbar[0]/btn[0]").press()
            else:
                self.session.findById("wnd[1]/tbar[0]/btn[0]").press()

    def get_license_product(self, element_id):
        license = self.session.findById(element_id).Text
        if license != "":
            license_split = license.split('_')
            product = license_split[0]
            return product
        else:
            return None
    def calculate_date_difference(self, given_date_str):
        given_date = datetime.strptime(given_date_str, '%d.%m.%Y').date()
        current_date = datetime.now().date()
        date_difference = (given_date - current_date).days
        return date_difference
    def Fbl1n_arrange(self):
        try:
            self.session.findById("wnd[1]/usr/tabsTS_LINES/tabpLI01/ssubSUB810:SAPLSKBH:0810/tblSAPLSKBHTC_WRITE_LIST").getAbsoluteRow(9).selected = True
            self.session.findById("wnd[1]/usr/tabsTS_LINES/tabpLI01/ssubSUB810:SAPLSKBH:0810/tblSAPLSKBHTC_WRITE_LIST").getAbsoluteRow(10).selected = True
            self.session.findById("wnd[1]/usr/tabsTS_LINES/tabpLI01/ssubSUB810:SAPLSKBH:0810/tblSAPLSKBHTC_WRITE_LIST/txtGT_WRITE_LIST-SELTEXT[0,9]").setFocus()
            self.session.findById("wnd[1]/usr/tabsTS_LINES/tabpLI01/ssubSUB810:SAPLSKBH:0810/tblSAPLSKBHTC_WRITE_LIST/txtGT_WRITE_LIST-SELTEXT[0,9]").caretPosition = 0
            self.session.findById("wnd[1]/usr/btnAPP_FL_SING").press()
            self.session.findById("wnd[1]/usr/tabsTS_LINES/tabpLI01/ssubSUB810:SAPLSKBH:0810/tblSAPLSKBHTC_WRITE_LIST").getAbsoluteRow(0).selected = True
            self.session.findById("wnd[1]/usr/btnAPP_FL_SING").press()
        except:
            return[]
    
    def count_GUI_Table_rows(self,table_path):
        """
        Counts the total number of rows in an SAP GUI table dynamically.
        Args:
            table_path (str): The path of the table like 'wnd[0]/usr/lbl'
        Returns:
            int: The total number of rows in the table
        """
        # SapGuiAuto = win32com.client.GetObject("SAPGUI")
        # application = SapGuiAuto.GetScriptingEngine
        # session = application.Children(0)  # Get first active session
        row_count = 4

        try:
            # Dynamically count rows
            while True:
                row_path = f"{table_path}[3,{row_count + 1}]"  # Check first column for each row
                try:
                    element = self.session.FindById(row_path)
                    if element:
                        row_count += 1
                except Exception as e:
                    break  # Exit the loop if the element is not found
        except Exception as e:
            print(f"Error: {str(e)}")

        print(f"Total rows counted: {row_count}")
        return row_count  
    
    def Get_table_Text(self, TXT, Row_count):
        TXT = "wnd[0]/usr/lbl"
        
        # Use lists to store the values
        MANDT_values = []
        ENTRY_TYPE_values = []
        PROTOCOL_values = []
        SORTKEY_values = []
        HOST_values = []
        
        try:
            # Loop through the rows starting from 5 to Row_count
            for i in range(5, Row_count + 1):
                MANDT_id = f"{TXT}[3,{i}]"
                ENTRY_TYPE = f"{TXT}[9,{i}]"
                SORTKEY = f"{TXT}[20,{i}]"
                PROTOCOL = f"{TXT}[29,{i}]"
                HOST = f"{TXT}[38,{i}]"
                
                # Print the identifiers for debugging
                print(f"MANDT ID: {MANDT_id}")
                print(f"ENTRY_TYPE: {ENTRY_TYPE}")
                print(f"SORTKEY: {SORTKEY}")
                print(f"PROTOCOL: {PROTOCOL}")
                print(f"HOST:{HOST}")
                
                # Check if element exists and extract text
                if self.session.findById(MANDT_id) is not None:
                    MANDT_value = self.session.findById(MANDT_id).text
                    MANDT_values.append(MANDT_value)  # Append the value to the list
                else:
                    print(f"MANDT_id field not found: {MANDT_id}")
                    MANDT_values.append(None)  # Append None if not found

                if self.session.findById(ENTRY_TYPE) is not None:
                    ENTRY_TYPE_value = self.session.findById(ENTRY_TYPE).text
                    ENTRY_TYPE_values.append(ENTRY_TYPE_value)  # Append the value to the list
                else:
                    print(f"ENTRY_TYPE field not found: {ENTRY_TYPE}")
                    ENTRY_TYPE_values.append(None)  # Append None if not found
                
                if self.session.findById(SORTKEY) is not None:
                    SORTKEY_value = self.session.findById(SORTKEY).text
                    SORTKEY_values.append(SORTKEY_value)  # Append the value to the list
                else:
                    print(f"SORTKEY field not found: {SORTKEY}")
                    SORTKEY_values.append(None)  # Append None if not found

                if self.session.findById(PROTOCOL) is not None:
                    PROTOCOL_value = self.session.findById(PROTOCOL).text
                    PROTOCOL_values.append(PROTOCOL_value)  # Append the value to the list
                else:
                    print(f"PROTOCOL field not found: {PROTOCOL}")
                    PROTOCOL_values.append(None)  # Append None if not found
                
                if self.session.findById(HOST) is not None:
                    HOST_value = self.session.findById(HOST).text
                    HOST_values.append(HOST_value)  # Append the value to the list
                else:
                    print(f"HOST field not found: {HOST}")
                    HOST_values.append(None)  # Append None if not found
            
            # Print the extracted values
            print(f"MANDT Values: {MANDT_values}")
            print(f"ENTRY_TYPE Values: {ENTRY_TYPE_values}")
            print(f"SORTKEY Values: {SORTKEY_values}")
            print(f"PROTOCOL Values: {PROTOCOL_values}")
            print(f"HOST Values: {HOST_values}")
            return MANDT_values, ENTRY_TYPE_values, SORTKEY_values, PROTOCOL_values, HOST_values
        except Exception as e:
            print(f"An error occurred: {e}")
    def get_Status_pane(self,paneid):
        try:
            element = self.session.findbyId(paneid)
            status_message = element.text
            return status_message
        except Exception as e:
            print(f"An error occurred: {e}")
    def process_excel(self, file_path, sheet_name, column_index=None):

        df = pd.read_excel(file_path, sheet_name=sheet_name, header=None)
        if column_index is not None:
            try:
                column_index = int(column_index)  # Ensure column_index is an integer
            except ValueError:
                print("Invalid column index provided. Please provide a valid integer.")
                return
            if 0 <= column_index < df.shape[1]:
                df.drop(df.columns[column_index], axis=1, inplace=True)
            else:
                print(f"Column index {column_index} is out of bounds.")
                return
        # df = df.applymap(lambda x: x.strip() if isinstance(x, str) else x)
        df = df.apply(lambda col: col.map(lambda x: x.strip() if isinstance(x, str) else x))
        df.dropna(how='all', inplace=True)
        df.dropna(axis=1, how='all', inplace=True)
        if df.iloc[0].isnull().all(): 
            new_header = df.iloc[1]  
            df = df[2:]  # Remove first two rows
        else:
            new_header = df.iloc[0]  # Use first row as header
            df = df[1:]  # Remove first row
        df.columns = new_header
        df.reset_index(drop=True, inplace=True)
        try:
            # Write the modified DataFrame back to the Excel file
            with pd.ExcelWriter(file_path, engine='openpyxl', mode='w') as writer:
                df.to_excel(writer, index=False, sheet_name=sheet_name)
            print(f"Processed Excel sheet '{sheet_name}' has been updated in: {file_path}")
        except Exception as e:
            print(f"Error writing to Excel: {e}")    

    def select_item(self, tree_id, nodeid1, nodeid2):
        element=self.session.findById(tree_id)
        element.selectItem(f"{nodeid1}",nodeid2) 
        
    def extract_numeric(self, data):
        match = re.search(r'\d+', data)
        if match:
            return match.group()
        else:
            return data
        
    def excel_to_json(self, excel_file, json_file):

        df = pd.read_excel(excel_file, engine='openpyxl')
        data = df.to_dict(orient='records')
        with open(json_file, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=4)
        return data
    
    def delete_specific_file(self, file_path):
        try:
            if os.path.exists(file_path):
                os.remove(file_path)
            else:
                print(f"The file '{file_path}' does not exist.")
        except Exception as e:
            print(f"An error occurred: {e}")



        

     