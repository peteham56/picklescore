import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
GPIO.setup(17, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(27, GPIO.IN, pull_up_down=GPIO.PUD_UP)

print("Press buttons to test - CTRL+C to quit")

try:
    while True:
        if GPIO.input(17) == GPIO.LOW:
            print("Button 1 pressed - Team A!")
            time.sleep(0.3)
        if GPIO.input(27) == GPIO.LOW:
            print("Button 2 pressed - Team B!")
            time.sleep(0.3)

except KeyboardInterrupt:
    print("Done")
    GPIO.cleanup()
