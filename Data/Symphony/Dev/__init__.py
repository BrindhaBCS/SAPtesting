# This init files loads data values available within each of the data files up at
# the environment level. 
# Warning: Any variable with conflicting names will be overwritten with 
#          values as they are imported through each file.

from .Data import *
# from .urls import *
# from .xpaths import *
from .Variable import *
from .invoice import *
from .Rental import *
from .Certificate import *
from .payments import *
from .closing_payment import *
from .Vendor_invoice import *
from .slicense import *
from .SM12 import *
from .SM37 import *
from .TS4 import *
from .sales_order import*
from .ABAP import *
from .Sales import *
from .Risk import *
from .Idoc import *


