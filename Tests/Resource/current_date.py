from datetime import datetime
import calendar
import os
import sys
now = datetime.now()
current_month1 = now.strftime("%B")
current_month = now.month
current_year = now.year
current_date = now.strftime("%Y.%m.%d")
days_in_month = calendar.monthrange(current_year, current_month)[1]
date = "31.12.2024"
date_obj = datetime.strptime(date, "%d.%m.%Y")
converted_date = date_obj.strftime("%Y.%m.%d")
print(f"conevrted date is: {converted_date}")

# folder_path = os.path.join(sys.argv[1], current_month, str(current_year))
# if not os.path.exists(folder_path):
#     os.makedirs(folder_path)

# Print the results
print(f"Current Month: {current_month}")
print(f"Current Year: {current_year}")
print(f"no of days in the month {current_month1} is: {days_in_month}")
print(f"current date is: {current_date}")
# print(f"folder path is: {folder_path}")
