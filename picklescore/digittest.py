import board
import neopixel
import time

NUM_LEDS = 64
PIN = board.D18
pixels = neopixel.NeoPixel(PIN, NUM_LEDS, brightness=0.1, auto_write=False)

def get_pixel(row, col):
    if col % 2 == 0:
        return col * 8 + row
    else:
        return col * 8 + (7 - row)

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

def draw_digit(digit, start_col, color):
    pattern = DIGITS[str(digit % 10)]
    for row in range(5):
        for col in range(3):
            if pattern[row][col]:
                idx = get_pixel(row + 1, start_col + col)
                pixels[idx] = color

print("Testing all digits 0-9...")
for i in range(10):
    pixels.fill((0, 0, 0))
    draw_digit(i, 0, (0, 150, 0))
    pixels.show()
    print(f"Showing digit: {i}")
    time.sleep(3)

pixels.fill((0, 0, 0))
pixels.show()
print("Done!")
