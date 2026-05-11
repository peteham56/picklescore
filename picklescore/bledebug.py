import bluetooth
import time

ble = bluetooth.BLE()
ble.active(True)

def bt_irq(event, data):
    if event == 5:
        addr_type, addr, adv_type, rssi, adv_data = data
        print(f"RSSI:{rssi} data:{bytes(adv_data)}")

ble.irq(bt_irq)
ble.gap_scan(15000, 30000, 30000)
print("Scanning for 15 seconds...")
time.sleep(15)
print("Done")
