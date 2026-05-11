import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_UP)

for i in range(20):
    print(f'Reading {i}: {GPIO.input(23)}')
    time.sleep(0.2)

GPIO.cleanup()
