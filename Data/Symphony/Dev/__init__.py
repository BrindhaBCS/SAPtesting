# This init files loads data values available within each of the data files up at
# the environment level. It overrides the values defined in Dev environment.
# Warning: Any variable with conflicting names will be overwritten with 
#          values as they are imported through each file.

from .Data import *
from .urls import *
from .xpaths import *
from .Variable_BIS import *

