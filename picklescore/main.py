import bluetooth
import time
from machine import Pin
from neopixel import NeoPixel

# LED matrix setup — XIAO D10 = GPIO 10
NUM_LEDS = 64
pixels = NeoPixel(Pin(10), NUM_LEDS)

# Digit font 5x3
DIGITS = {
    '0': [[1,1,1],[1,0,1],[1,0,1],[1,0,1],[1,1,1]],
    '1': [[0,1,0],[1,1,0],[0,1,0],[0,1,0],[1,1,1]],
    '2': [[1,1,1],[0,0,1],[1,1,1],[1,0,0],[1,1,1]],
    '3': [[1,1,1],[0,0,1],[1,1,1],[0,0,1],[1,1,1]],
    '4': [[1,0,1],[1,0,1],[1,1,1],[0,0,1],[0,0,1]],
    '5': [[1,1,1],[1,0,0],[1,1,1],[0,0,1],[1,1,1]],
    '6': [[1,1,1],[1,0,0],[1,1,1],[1,0,1],[1,1,1]],
    '7': [[1,1,1],[0,0,1],[0,1,0],[0,1,0],[0,1,0]],
    '8': [[1,1,1],[1,0,1],[1,1,1],[1,0,1],[1,1,1]],
    '9': [[1,1,1],[1,0,1],[1,1,1],[0,0,1],[1,1,1]],
}

def get_pixel(row, col):
    if col % 2 == 0:
        return col * 8 + row
    else:
        return col * 8 + (7 - row)

def draw_digit(digit, start_col, color):
    pattern = DIGITS[str(digit % 10)]
    for row in range(5):
        for col in range(3):
            if pattern[row][col]:
                idx = get_pixel(row + 1, start_col + col)
                pixels[idx] = color

def show_score(score_a, score_b, serving, server):
    pixels.fill((0, 0, 0))
    
    # Team colors — bright if serving, dim if not
    color_a = (0, 150, 0) if serving == 'A' else (0, 40, 0)
    color_b = (0, 0, 150) if serving == 'B' else (0, 0, 40)
    
    # Draw scores
    draw_digit(score_a, 0, color_a)  # Green on left
    draw_digit(score_b, 4, color_b)  # Blue on right
    
    # Center divider
    for row in range(8):
        idx = get_pixel(row, 3)
        pixels[idx] = (20, 20, 20)
    
    # Serving indicator — bright dot on row 7 under serving team
    if serving == 'A':
        # Dot under Team A (left side — columns 0,1,2)
        pixels[get_pixel(7, 1)] = (255, 255, 0)  # Yellow dot
    else:
        # Dot under Team B (right side — columns 4,5,6)
        pixels[get_pixel(7, 5)] = (255, 255, 0)  # Yellow dot
    
    # Server number — 1 or 2 dots on row 0
    pixels[get_pixel(0, 1)] = (255, 255, 255)  # Always show dot 1
    if server == 2:
        pixels[get_pixel(0, 5)] = (255, 255, 255)  # Show dot 2 if server 2
    
    pixels.write()

# BLE setup
time.sleep(3)  # boot delay
ble = bluetooth.BLE()
ble.active(True)
sa, sb, sv, sn = 0, 0, 'A', 2
show_score(sa, sb, sv, sn)
print("PickleScore Ready - Scanning...")

def bt_irq(event, data):
    global sa, sb, sv, sn
    if event == 5:
        addr_type, addr, adv_type, rssi, adv_data = data
        try:
            b = bytes(adv_data)
            marker = b'PS:'
            i = b.find(marker)
            if i >= 0:
                t = b[i+3:].decode("ascii")
                p = t.split(",")
                sa = int(p[0].split(":")[1])
                sb = int(p[1].split(":")[1])
                sv = p[2].split(":")[1]
                sn = int(p[3].split(":")[1])
                show_score(sa, sb, sv, sn)
                print("SCORE:", sa, "-", sb, "Serving:", sv, "Server:", sn)
        except:
            pass

ble.irq(bt_irq)
ble.gap_scan(0, 30000, 30000)
print("Scanning...")
while True:
    time.sleep(1)
