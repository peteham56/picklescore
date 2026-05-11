import board
import neopixel
import time

# LED matrix setup
NUM_LEDS = 64
PIN = board.D18
pixels = neopixel.NeoPixel(PIN, NUM_LEDS, brightness=0.1, auto_write=False)

# Column-by-column layout
# col 0 = LEDs 0-7, col 1 = LEDs 8-15, etc.
def get_pixel(row, col):
    return col * 8 + row

# 5x3 digit font (5 rows, 3 cols)
DIGITS = {
    '0': [
        [1,1,1],
        [1,0,1],
        [1,0,1],
        [1,0,1],
        [1,1,1],
    ],
    '1': [
        [0,1,0],
        [1,1,0],
        [0,1,0],
        [0,1,0],
        [1,1,1],
    ],
    '2': [
        [1,1,1],
        [0,0,1],
        [1,1,1],
        [1,0,0],
        [1,1,1],
    ],
    '3': [
        [1,1,1],
        [0,0,1],
        [1,1,1],
        [0,0,1],
        [1,1,1],
    ],
    '4': [
        [1,0,1],
        [1,0,1],
        [1,1,1],
        [0,0,1],
        [0,0,1],
    ],
    '5': [
        [1,1,1],
        [1,0,0],
        [1,1,1],
        [0,0,1],
        [1,1,1],
    ],
    '6': [
        [1,1,1],
        [1,0,0],
        [1,1,1],
        [1,0,1],
        [1,1,1],
    ],
    '7': [
        [1,1,1],
        [0,0,1],
        [0,1,0],
        [0,1,0],
        [0,1,0],
    ],
    '8': [
        [1,1,1],
        [1,0,1],
        [1,1,1],
        [1,0,1],
        [1,1,1],
    ],
    '9': [
        [1,1,1],
        [1,0,1],
        [1,1,1],
        [0,0,1],
        [1,1,1],
    ],
}

def draw_digit(digit, start_col, color):
    pattern = DIGITS[str(digit % 10)]
    for row in range(5):
        for col in range(3):
            if pattern[row][col]:
                idx = get_pixel(row + 1, start_col + col)
                pixels[idx] = color

def show_score(score_a, score_b):
    pixels.fill((0, 0, 0))
    # Team A score on left in green
    draw_digit(score_a, 0, (0, 150, 0))
    # Divider in white
    for row in range(8):
        idx = get_pixel(row, 3)
        pixels[idx] = (30, 30, 30)
    # Team B score on right in blue
    draw_digit(score_b, 4, (0, 0, 150))
    pixels.show()

# Test display
print("Testing score display...")
for a in range(0, 12):
    show_score(a, 11 - a)
    print(f"Score: A={a} B={11-a}")
    time.sleep(3)

pixels.fill((0, 0, 0))
pixels.show()
print("Done!")
