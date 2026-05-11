import board
import neopixel
import time

NUM_LEDS = 64
PIN = board.D18
pixels = neopixel.NeoPixel(PIN, NUM_LEDS, brightness=0.1, auto_write=False)

print("Lighting FIRST LED only (LED 0) in RED...")
pixels.fill((0,0,0))
pixels[0] = (255, 0, 0)
pixels.show()
time.sleep(3)

print("Lighting LAST LED only (LED 63) in BLUE...")
pixels.fill((0,0,0))
pixels[63] = (0, 0, 255)
pixels.show()
time.sleep(3)

print("Lighting LEFT HALF in GREEN...")
pixels.fill((0,0,0))
for i in range(32):
    pixels[i] = (0, 255, 0)
pixels.show()
time.sleep(3)

print("Lighting RIGHT HALF in BLUE...")
pixels.fill((0,0,0))
for i in range(32, 64):
    pixels[i] = (0, 0, 255)
pixels.show()
time.sleep(3)

pixels.fill((0,0,0))
pixels.show()
print("Done!")
