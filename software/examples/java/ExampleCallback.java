import java.util.Random;

import com.tinkerforge.IPConnection;
import com.tinkerforge.BrickletSilentStepperV2;
import com.tinkerforge.TinkerforgeException;

public class ExampleCallback {
	private static final String HOST = "localhost";
	private static final int PORT = 4223;

	// Change XYZ to the UID of your Silent Stepper Bricklet 2.0
	private static final String UID = "XYZ";

	// Note: To make the example code cleaner we do not handle exceptions. Exceptions
	//       you might normally want to catch are described in the documentation
	public static void main(String args[]) throws Exception {
		IPConnection ipcon = new IPConnection(); // Create IP connection
		// Note: Declare stepper final, so the listener can access it
		final BrickletSilentStepperV2 ss = new BrickletSilentStepperV2(UID, ipcon); // Create device object

		ipcon.connect(HOST, PORT); // Connect to brickd
		// Don't use device before ipcon is connected

		// Use position reached callback to program random movement
		ss.addPositionReachedListener(new BrickletSilentStepperV2.PositionReachedListener() {
			Random random = new Random();

			public void positionReached(int position) {
				int steps = 0;

				if(random.nextInt(2) == 1) {
					steps = random.nextInt(4001) + 1000; // steps (forward)
				} else {
					steps = random.nextInt(5001) - 6000; // steps (backward)
				}

				int vel = random.nextInt(1801) + 200; // steps/s
				int acc = random.nextInt(901) + 100; // steps/s^2
				int dec = random.nextInt(901) + 100; // steps/s^2

				System.out.println("Configuration (vel, acc, dec): (" +
				                   vel + ", " + acc + ",  " + dec + ")");

				try {
					ss.setSpeedRamping(acc, dec);
					ss.setMaxVelocity(vel);
					ss.setSteps(steps);
				} catch(TinkerforgeException e) {
				}
			}
		});

		ss.setStepConfiguration(BrickletSilentStepperV2.STEP_RESOLUTION_8,
		                        true); // 1/8 steps (interpolated)
		ss.setEnabled(true); // Enable motor power
		ss.setSteps(1); // Drive one step forward to get things going

		System.out.println("Press key to exit"); System.in.read();

		// Stop motor before disabling motor power
		ss.stop(); // Request motor stop
		ss.setSpeedRamping(500, 5000); // Fast deacceleration (5000 steps/s^2) for stopping
		Thread.sleep(400); // Wait for motor to actually stop: max velocity (2000 steps/s) / decceleration (5000 steps/s^2) = 0.4 s
		ss.setEnabled(false); // Disable motor power

		ipcon.disconnect();
	}
}
