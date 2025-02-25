import qrcode
from io import BytesIO
import base64
import json

def generate_qr_json(file_path):
    with open(file_path, "r", encoding="utf-8") as file:
        lines = file.read().strip().split("\n")
    deliveries = {}
    current_delivery = None
    for line in lines:
        key, value = line.split(":", 1)
        key, value = key.strip(), value.strip()
        if key == "Inbounddelivery":
            current_delivery = value
            if current_delivery not in deliveries:
                deliveries[current_delivery] = []
        else:
            if deliveries and current_delivery:
                if key == "Material":
                    deliveries[current_delivery].append({
                        "Material": value,
                        "DeliveryQuantity": None,
                        "WarehousetaskNumber": None,
                        "Sourcebin": None,
                        "Destbin": None
                    })
                elif deliveries[current_delivery] and key in ["DeliveryQuantity", "WarehousetaskNumber", "Sourcebin", "Destbin"]:
                    deliveries[current_delivery][-1][key] = int(value) if key in ["DeliveryQuantity", "WarehousetaskNumber"] else value
    structured_data = {
        "InboundDelivery": list(deliveries.keys())[0],  
        "Details": deliveries[list(deliveries.keys())[0]]
    }
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=5,
        border=2,
    )
    qr_data = json.dumps(structured_data, indent=4)
    qr.add_data(qr_data)
    qr.make(fit=True)
    img = qr.make_image(fill="black", back_color="white")
    buffered = BytesIO()
    img.save(buffered, format="PNG")
    img_base64 = base64.b64encode(buffered.getvalue()).decode()
    qr_json = json.dumps({
        "qr_code": img_base64,
        "format": "png",
        "data": structured_data
    }, indent=4)
    print(qr_json)
    # return qr_json
