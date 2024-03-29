<?php

require_once('Tinkerforge/IPConnection.php');
require_once('Tinkerforge/BrickletSilentStepperV2.php');

use Tinkerforge\IPConnection;
use Tinkerforge\BrickletSilentStepperV2;

const HOST = 'localhost';
const PORT = 4223;
const UID = 'XYZ'; // Change XYZ to the UID of your Silent Stepper Bricklet 2.0

$ipcon = new IPConnection(); // Create IP connection
$ss = new BrickletSilentStepperV2(UID, $ipcon); // Create device object

$ipcon->connect(HOST, PORT); // Connect to brickd
// Don't use device before ipcon is connected

$ss->setMotorCurrent(800); // 800 mA
$ss->setStepConfiguration(BrickletSilentStepperV2::STEP_RESOLUTION_8,
                          TRUE); // 1/8 steps (interpolated)
$ss->setMaxVelocity(2000); // Velocity 2000 steps/s

// Slow acceleration (500 steps/s^2),
// Fast deacceleration (5000 steps/s^2)
$ss->setSpeedRamping(500, 5000);

$ss->setEnabled(TRUE); // Enable motor power
$ss->setSteps(60000); // Drive 60000 steps forward

echo "Press key to exit\n";
fgetc(fopen('php://stdin', 'r'));

// Stop motor before disabling motor power
$ss->stop(); // Request motor stop
$ss->setSpeedRamping(500, 5000); // Fast deacceleration (5000 steps/s^2) for stopping
usleep(400*1000); // Wait for motor to actually stop: max velocity (2000 steps/s) / decceleration (5000 steps/s^2) = 0.4 s
$ss->setEnabled(FALSE); // Disable motor power

$ipcon->disconnect();

?>
