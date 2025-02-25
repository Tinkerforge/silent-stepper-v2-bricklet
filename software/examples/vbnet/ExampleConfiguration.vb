Imports System
Imports System.Threading
Imports Tinkerforge

Module ExampleConfiguration
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change XYZ to the UID of your Silent Stepper Bricklet 2.0

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim ss As New BrickletSilentStepperV2(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ss.SetMotorCurrent(800) ' 800 mA
        ss.SetStepConfiguration(BrickletSilentStepperV2.STEP_RESOLUTION_8, _
                                True) ' 1/8 steps (interpolated)
        ss.SetMaxVelocity(2000) ' Velocity 2000 steps/s

        ' Slow acceleration (500 steps/s^2),
        ' Fast deacceleration (5000 steps/s^2)
        ss.SetSpeedRamping(500, 5000)

        ss.SetEnabled(True) ' Enable motor power
        ss.SetSteps(60000) ' Drive 60000 steps forward

        Console.WriteLine("Press key to exit")
        Console.ReadLine()

        ' Stop motor before disabling motor power
        ss.Stop() ' Request motor stop
        ss.SetSpeedRamping(500, _
                           5000) ' Fast deacceleration (5000 steps/s^2) for stopping
        Thread.Sleep(400) ' Wait for motor to actually stop: max velocity (2000 steps/s) / decceleration (5000 steps/s^2) = 0.4 s
        ss.SetEnabled(False) ' Disable motor power

        ipcon.Disconnect()
    End Sub
End Module
