import bluetooth
import time
from machine import Pin, SoftI2C
import ssd1306

# ── OLED setup ──────────────────────────────────────────────
i2c = SoftI2C(scl=Pin(7), sda=Pin(6))
oled = ssd1306.SSD1306_I2C(128, 64, i2c)

def show_score(a, b, sv, sn):
    oled.fill(0)
    oled.text("PickleScore", 0, 0)
    oled.text("A:{:<2} B:{:<2}".format(a, b), 0, 16)
    oled.text("Srv: {}".format(sv), 0, 32)
    oled.text("Num: #{}".format(sn), 0, 48)
    oled.show()

# Show startup immediately
sa, sb, sv, sn = 0, 0, 'A', 2
show_score(sa, sb, sv, sn)

# Boot delay
time.sleep(3)

# BLE setup
def start_ble():
    global ble
    try:
        ble = bluetooth.BLE()
        ble.active(True)
        ble.irq(bt_irq)
        ble.gap_scan(0, 10000, 10000)
    except:
        pass

start_ble()

while True:
    time.sleep(5)
    try:
        if not ble.active():
            start_ble()
        else:
            ble.gap_scan(0, 10000, 10000)
    except:
        start_ble()
