# # from datetime import datetime, timedelta
# # import calendar
# # import os
# # import sys
# # now = datetime.now()
# # current_month1 = now.strftime("%B")
# # current_month = now.month
# # current_year = now.year

# # current_date = now.strftime("%Y.%m.%d")
# # current_time = now.strftime("%H:%M")
# # # str_time = now.strftime("%Y.%m.%dT%H:%M")

# # current_time_str = now.replace(microsecond=0).isoformat()
# # isotime = datetime.fromisoformat(current_time_str)
# # time_change = timedelta(minutes=1)
# # new_time = isotime + time_change

# # days_in_month = calendar.monthrange(current_year, current_month)[1]
# # date = "31.12.2024"
# # date_obj = datetime.strptime(date, "%d.%m.%Y")
# # converted_date = date_obj.strftime("%Y.%m.%d")
# # # print(f"conevrted date is: {converted_date}")


# # # folder_path = os.path.join(sys.argv[1], current_month, str(current_year))
# # # if not os.path.exists(folder_path):
# # #     os.makedirs(folder_path)

# # # Print the results
# # print(f"ISO format: {now.isoformat()}")
# # # print(f"current date and time is: {now}")
# # # print(f"Current Month: {current_month}")
# # # print(f"Current Year: {current_year}")
# # # print(f"no of days in the month {current_month1} is: {days_in_month}")
# # print(f"current date is: {current_date}")
# # print(f"current time is: {current_time}")
# # print(f"New time is: {new_time}")
# # # print(f"folder path is: {folder_path}")
# # # print(f"formated ISO time: {current_date}T{current_time}")



# # from datetime import datetime, timedelta
# # import pytz
# # kolkata_tz = pytz.timezone('Asia/Kolkata')
# # utc_time = datetime.now(pytz.utc)
# # now = utc_time.astimezone(kolkata_tz)
# # # now = datetime.now()
# # current_time_str = now.replace(second=0).replace(microsecond=0).isoformat()
# # isotime = datetime.fromisoformat(current_time_str)
# # time_change = timedelta(minutes=3)
# # new_time1 = isotime + time_change
# # # input_format = "%Y-%m-%d %H:%M:%S"
# # # input_date = datetime.strptime(new_time1, input_format)
# # new_time = new_time1.strftime('%Y-%m-%dT%H:%M')
# # # new_time = new_time1.isoformat()
# # print(new_time)
# # print(f"##gbStart##run_time##splitKeyValue##{new_time}##splitKeyValue##object##gbEnd##")


# # from datetime import datetime
# # from dateutil.relativedelta import relativedelta

# # # Get the current date
# # current_date = datetime.now()

# # # Calculate the date 6 months ago
# # six_months_ago = current_date - relativedelta(months=-7)

# # # Print both dates
# # print("Current Date:", current_date.strftime("%B"))
# # print("Date 6 months ago:", six_months_ago.strftime("%B"))


from datetime import datetime
from dateutil.relativedelta import relativedelta
# import json
current_date = datetime.now()
month_date = current_date + relativedelta(months=1)
month_name= month_date.strftime("%B")
year = month_date.strftime("%Y")
print(f"the subject of the month {month_name} {year}")
# last_6_months = []
# for i in range(0, 6):
#     month_date = current_date - relativedelta(months=i)
#     month_name= month_date.strftime("%B")
#     year = month_date.strftime("%Y")
#     last_6_months.append({"Month": month_name,"Year": year})
# response = {
#     "StatusCode": 200,
#     "ResponseBody": {
#         "content":last_6_months
        
#     },
#     "status": 200,
#     "content_type": "application/json"
# }

# response_json = json.dumps(response, indent=4)
# print(f"##gbStart##month1##splitKeyValue##{response_json}##splitKeyValue##object##gbEnd##")

# import calendar
# from datetime import datetime

# def get_first_and_last_date_of_month(month_json):
#     month_name = month_json[0]["Month"]
#     year = int(month_json[0]["Year"])
#     month_number = datetime.strptime(month_name, "%B").month
#     first_date = datetime(year, month_number, 1).date()
#     last_day = calendar.monthrange(year, month_number)[1]
#     last_date = datetime(year, month_number, last_day).date()
#     first_date_str = first_date.strftime("%Y.%m.%d")
#     last_date_str = last_date.strftime("%Y.%m.%d")

#     return first_date_str, last_date_str

# def compare_dates(date, start_date, end_date):
#     date = datetime.strptime(date, "%Y.%m.%d")
#     first_date = datetime.strptime(start_date, "%Y.%m.%d")
#     last_date = datetime.strptime(end_date, "%Y.%m.%d")
#     if date.month == first_date.month:
#         if date.year == first_date.year:
#             if first_date.day <= date.day <= last_date.day:
#                 return True
#     #         if date.day == first_date.day or date.day == last_date.day:
#     #             return True
#     #         elif date.day >= first_date.day and date.day <= last_date.day:
#     #             return True
#     #         else:
#     #             return False
#     #     else:
#     #         return False
#     # else:
#     return False

# month_json = [{"Month": "December", "Year": "2024"}]
# # first_date, last_date = get_first_and_last_date_of_month(month_json)

# # print("First date:", first_date)
# # print("Last date:", last_date)
# date = "2024.12.31"
# start_date = "2024.12.01"
# end_date = "2024.12.30"
# result = compare_dates(date, start_date, end_date)
# print(f"The result of comparing dates are: {result}")




# import json
# data = '{"contract_number": "40000079"}'

# json_data = json.loads(data)
# contract_number = json_data.get("contract_number")
# return contract_number
# # Print the extracted contract number
# # print(contract_number)


# import sys

# file = sys.argv[1]
# invoice = file.split('_')[0]
# print(f"##gbStart##Invoice_number##splitKeyValue##{invoice}##gbEnd##")

import sys
import json

data = '[{"Month":"January","Year":"2025"}]'
json_data = json.loads(data)

month = json_data[0]["Month"]
year = json_data[0]["Year"]

formatted_date = f"{month} {year}."
print(formatted_date)

# from datetime import datetime
# from dateutil.relativedelta import relativedelta

# # Input Date
# input_date = "January 2025"

# # Convert input string to datetime object
# date_obj = datetime.strptime(input_date, "%B %Y")

# # Get the next month by adding 1 month using relativedelta
# next_month = date_obj + relativedelta(months=1)

# # Print next month's date in the format 'Month YYYY'
# print(next_month.strftime("%B %Y"))
