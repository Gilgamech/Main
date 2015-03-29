const int motorApwm = 3; // Motor A output pin (hardwired on motor shield)
const int pingPin = 7;     // pin used by the PING sensor
const int motorBbrk = 8; // Motor A output pin (hardwired on motor shield)
const int motorAbrk = 9; // Motor A output pin (hardwired on motor shield)
const int buttonPin = 10;     // the number of the pushbutton pin
const int motorBpwm = 11; // Motor A output pin (hardwired on motor shield)
const int motorAdir = 12; // Motor A output pin (hardwired on motor shield)
const int motorBdir = 13; // Motor A output pin (hardwired on motor shield)
const int motorAsns = A0; // Motor A output pin (hardwired on motor shield)
const int motorBsns = A1; // Motor A output pin (hardwired on motor shield)

void setup() {
  //Set up the motors for the correct outputs
  pinMode(motorAdir, OUTPUT);
  pinMode(motorApwm, OUTPUT);
  pinMode(motorAbrk, OUTPUT);
  pinMode(motorAsns, INPUT);
  pinMode(motorBdir, OUTPUT);
  pinMode(motorBpwm, OUTPUT);
  pinMode(motorBbrk, OUTPUT);
  pinMode(motorBsns, INPUT);
  pinMode(buttonPin, INPUT);
   
}

void loop() {
long duration, inches, cm;
int brakeAHigh = LOW;
int pwmAspeed = 255;
int dirALowForward = LOW;

int brakeBHigh = LOW;
int pwmBturn = 0;
int dirBLowLeft = LOW;

long lastCm = 14;
long carSpeed = 0;

  digitalWrite(motorAdir, dirALowForward);
  digitalWrite(motorAbrk, brakeAHigh);
  digitalWrite(motorBdir, dirBLowLeft);
  digitalWrite(motorBbrk, brakeBHigh);
  

  analogWrite(motorApwm, pwmAspeed);
  digitalWrite(motorAbrk, brakeAHigh);
  
    delay(100);
}
