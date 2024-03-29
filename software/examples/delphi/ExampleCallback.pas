program ExampleCallback;

{$ifdef MSWINDOWS}{$apptype CONSOLE}{$endif}
{$ifdef FPC}{$mode OBJFPC}{$H+}{$endif}

uses
  SysUtils, IPConnection, BrickletSilentStepperV2;

type
  TExample = class
  private
    ipcon: TIPConnection;
    ss: TBrickletSilentStepperV2;
  public
    procedure PositionReachedCB(sender: TBrickletSilentStepperV2;
                                const position: longint);
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'XYZ'; { Change XYZ to the UID of your Silent Stepper Bricklet 2.0 }

var
  e: TExample;

{ Use position reached callback to program random movement }
procedure TExample.PositionReachedCB(sender: TBrickletSilentStepperV2;
                                     const position: longint);
var steps: longint; vel: smallint; acc, dec: word;
begin
  if (Random(2) = 0) then begin
    steps := Random(4000) + 1000; { steps (forward) }
    WriteLn(Format('Driving forward: %d steps', [steps]));
  end
  else begin
    steps := -(Random(4000) + 1000); { steps (backward) }
    WriteLn(Format('Driving backward: %d steps', [steps]));
  end;

  vel := Random(1800) + 200; { steps/s }
  acc := Random(900) + 100; { steps/s^2 }
  dec := Random(900) + 100; { steps/s^2 }
  WriteLn(Format('Configuration (vel, acc, dec): %d, %d %d', [vel, acc, dec]));

  sender.SetSpeedRamping(acc, dec);
  sender.SetMaxVelocity(vel);
  sender.SetSteps(steps);
end;

procedure TExample.Execute;
begin
  { Create IP connection }
  ipcon := TIPConnection.Create;

  { Create device object }
  ss := TBrickletSilentStepperV2.Create(UID, ipcon);

  { Connect to brickd }
  ipcon.Connect(HOST, PORT);
  { Don't use device before ipcon is connected }

  { Register position reached callback to procedure PositionReachedCB }
  ss.OnPositionReached := {$ifdef FPC}@{$endif}PositionReachedCB;

  ss.SetStepConfiguration(BRICKLET_SILENT_STEPPER_V2_STEP_RESOLUTION_8,
                          true); { 1/8 steps (interpolated) }
  ss.SetEnabled(true); { Enable motor power }
  ss.SetSteps(1); { Drive one step forward to get things going }

  WriteLn('Press key to exit');
  ReadLn;

  { Stop motor before disabling motor power }
  ss.Stop; { Request motor stop }
  ss.SetSpeedRamping(500, 5000); { Fast deacceleration (5000 steps/s^2) for stopping }
  Sleep(400); { Wait for motor to actually stop: max velocity (2000 steps/s) / decceleration (5000 steps/s^2) = 0.4 s }
  ss.SetEnabled(false); { Disable motor power }

  ipcon.Destroy; { Calls ipcon.Disconnect internally }
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
