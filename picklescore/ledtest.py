import board
import neopixel
import time

# LED matrix setup
NUM_LEDS = 64
PIN = board.D18

pixels = neopixel.NeoPixel(PIN, NUM_LEDS, brightness=0.2, auto_write=False)

print("LED Test Starting...")

# Test 1 - Light all LEDs red
print("All RED...")
pixels.fill((255, 0, 0))
pixels.show()
time.sleep(2)

# Test 2 - Light all LEDs green
print("All GREEN...")
pixels.fill((0, 255, 0))
pixels.show()
time.sleep(2)

# Test 3 - Light all LEDs blue
print("All BLUE...")
pixels.fill((0, 0, 255))
pixels.show()
time.sleep(2)

# Turn off
pixels.fill((0, 0, 0))
pixels.show()
print("LED Test Complete!")
