from datetime import datetime

import os
import glob

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

def calculate_time_difference(start_time_str, end_time_str):
    start_time = datetime.strptime(start_time_str, "%Y-%m-%d %H:%M:%S.%f")
    end_time = datetime.strptime(end_time_str, "%Y-%m-%d %H:%M:%S.%f")

    time_diff = abs(start_time - end_time)
    total_seconds = time_diff.total_seconds()
    minutes = int(total_seconds // 60)
    seconds = total_seconds % 60
    return f"{minutes:02}:{seconds:.6f}"


def file_remove(directory, extensions):
    try:
        extensions = [extensions] if isinstance(extensions, str) else extensions
        for ext in extensions:
            files = glob.glob(os.path.join(directory, f'*{ext}'))
            for file_path in files:
                os.remove(file_path)
        return f"Removed files with extension(s): {extensions} in directory: {directory}"
    except Exception as e:
        return f"An error occurred: {e}"

def send_mail(from_email, password, to_mail, subject, content, file_paths=None):
    HOST = "smtp-mail.outlook.com"
    PORT = 587
    message = MIMEMultipart()
    message['From'] = from_email
    message['To'] = ", ".join(to_mail)
    message['Subject'] = subject
    message.attach(MIMEText(content, 'plain'))
    if file_paths:
        for file_path in file_paths:
            if os.path.isfile(file_path):
                with open(file_path, "rb") as file:
                    file_data = file.read()
                    file_name = os.path.basename(file_path)
                    part = MIMEBase("application", "octet-stream")
                    part.set_payload(file_data)
                    encoders.encode_base64(part)
                    part.add_header("Content-Disposition", f"attachment; filename={file_name}")
                    message.attach(part)
    try:
        smtp = smtplib.SMTP(HOST, PORT)
        smtp.ehlo()
        smtp.starttls()
        smtp.login(from_email, password)
        smtp.sendmail(from_email, to_mail, message.as_string())
        print("[*] Email sent successfully!")
    except smtplib.SMTPAuthenticationError:
        print("[!] Authentication error: Please check your email or password.")
    except Exception as e:
        print(f"[!] An error occurred: {e}")
    finally:
        smtp.quit()



