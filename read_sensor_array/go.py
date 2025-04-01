from gpiozero import MCP3008
import gpiozero.pins.lgpio
from datetime import datetime
from time import sleep
import RPi.GPIO




RPi.GPIO.setmode(RPi.GPIO.BCM)
pin=26
RPi.GPIO.setup(pin,RPi.GPIO.IN,pull_up_down=RPi.GPIO.PUD_UP)

print("Timestamp, Sensor0, Transistor0");
while True:
    print(datetime.now(),",",MCP3008(0).value,",")#,RPi.GPIO.input(pin))
    sleep(1)

