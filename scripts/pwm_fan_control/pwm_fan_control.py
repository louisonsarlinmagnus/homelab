import RPi.GPIO as GPIO # type: ignore
import time
import subprocess

# Configuration constants
GPIO_PIN = 14
TEMP_THRESHOLD = 50.0
PWM_FREQUENCY = 100

# GPIO pin setup
GPIO.setmode(GPIO.BCM)
# Set to false, other processes occupying the pin will be ignored
GPIO.setwarnings(False)
GPIO.setup(GPIO_PIN, GPIO.OUT)
pwm = GPIO.PWM(GPIO_PIN,PWM_FREQUENCY)

# Initialize PWM
dc = 0
pwm.start(dc)

def get_cpu_temperature():
    """Retrieves the CPU temperature using vcgencmd."""
    try:
        temp_str = subprocess.getoutput("vcgencmd measure_temp | sed 's/[^0-9.]//g'")
        return float(temp_str)
    except Exception as e:
        print(f"Error retrieving temperature: {e}")
        return 0.0

try:
    while True:
        temp = get_cpu_temperature()
        time.sleep(1)

        # Adjust duty cycle based on temperature
        if temp >= TEMP_THRESHOLD:
            new_dc = 100
        else:
            new_dc = 0

        # Update duty cycle if necessary
        if new_dc != dc:
            dc = new_dc
            pwm.ChangeDutyCycle(dc)

except KeyboardInterrupt:
    print("Stopping the script.")
finally:
    pwm.stop()
    GPIO.cleanup()