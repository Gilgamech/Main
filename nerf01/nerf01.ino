const int triggerPin = 1; // pin used for the trigger
const int motorApwm = 3; // Motor A output pin (hardwired on motor shield)
const int pingPin = 7;     // pin used by the PING sensor
const int motorBbrk = 8; // Motor A output pin (hardwired on motor shield)
const int motorAbrk = 9; // Motor A output pin (hardwired on motor shield)
const int motorBpwm = 11; // Motor A output pin (hardwired on motor shield)
const int motorAdir = 12; // Motor A output pin (hardwired on motor shield)
const int motorBdir = 13; // Motor A output pin (hardwired on motor shield)
const int motorAsns = A0; // Motor A output pin (hardwired on motor shield)
const int motorBsns = A1; // Motor A output pin (hardwired on motor shield)

int brakeAHigh = LOW;
int pwmAout = 0;
int dirALowForward = HIGH;

int brakeBHigh = LOW;
int pwmBout = 0;
int dirBLowLeft = LOW;

int fireDist = 1800;



void setup() {
  pinMode(triggerPin, OUTPUT);
//Set up the motors for the correct outputs
  pinMode(motorAdir, OUTPUT);
  pinMode(motorApwm, OUTPUT);
  pinMode(motorAbrk, OUTPUT);
  pinMode(motorAsns, INPUT);
  pinMode(motorBdir, OUTPUT);
  pinMode(motorBpwm, OUTPUT);
  pinMode(motorBbrk, OUTPUT);
  pinMode(motorBsns, INPUT);
  
}

void loop()
{
  // establish variables for duration of the ping, 
  // and the distance result in inches and centimeters:
  long duration, inches, cm;

  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);

  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH);

  
if (duration<fireDist){
  pwmAout = map(duration,0,1800,250,0);
}else{
  pwmAout = 0;
}  
  analogWrite(motorApwm, pwmAout);

  delay(100);
}

