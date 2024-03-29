#!/bin/sh
# Connects to localhost:4223 by default, use --host and --port to change this

uid=XYZ # Change XYZ to the UID of your Silent Stepper Bricklet 2.0

# Use position reached callback to program random movement
tinkerforge dispatch silent-stepper-v2-bricklet $uid position-reached\
 --execute "echo Changing configuration;
            tinkerforge call silent-stepper-v2-bricklet $uid set-max-velocity $(((RANDOM%1800)+1200));
            tinkerforge call silent-stepper-v2-bricklet $uid set-speed-ramping $(((RANDOM%900)+100)) $(((RANDOM%900)+100));
            if [ $((RANDOM % 2)) -eq 1 ];
            then tinkerforge call silent-stepper-v2-bricklet $uid set-steps $(((RANDOM%4000)+1000));
            else tinkerforge call silent-stepper-v2-bricklet $uid set-steps $(((RANDOM%4000)-5000));
            fi" &

tinkerforge call silent-stepper-v2-bricklet $uid set-step-configuration step-resolution-8 true # 1/8 steps (interpolated)
tinkerforge call silent-stepper-v2-bricklet $uid set-enabled true # Enable motor power
tinkerforge call silent-stepper-v2-bricklet $uid set-steps 1 # Drive one step forward to get things going

echo "Press key to exit"; read dummy

# Stop motor before disabling motor power
tinkerforge call silent-stepper-v2-bricklet $uid stop # Request motor stop
tinkerforge call silent-stepper-v2-bricklet $uid set-speed-ramping 500 5000 # Fast deacceleration (5000 steps/s^2) for stopping
sleep 0.4 # Wait for motor to actually stop: max velocity (2000 steps/s) / decceleration (5000 steps/s^2) = 0.4 s
tinkerforge call silent-stepper-v2-bricklet $uid set-enabled false # Disable motor power

kill -- -$$ # Stop callback dispatch in background
