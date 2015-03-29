const int motorApwm = 3; // Motor A output pin (hardwired on motor shield)
const int pingPin = 7;     // pin used by the PING sensor
const int motorBbrk = 8; // Motor B brake pin (hardwired on motor shield)
const int motorAbrk = 9; // Motor A brake pin (hardwired on motor shield)
const int motorBpwm = 11; // Motor B output pin (hardwired on motor shield)
const int motorAdir = 12; // Motor A direction pin (hardwired on motor shield)
const int motorBdir = 13; // Motor B direction pin (hardwired on motor shield)
const int motorAsns = A0; // Motor A sensor pin (hardwired on motor shield)
const int motorBsns = A1; // Motor B sensor pin (hardwired on motor shield)

int brakeAHigh = LOW; // turn off the parking brake
int pwmAspeed = 0; // set motor speed to 0/255
int dirALowForward = LOW; // Which direction the motor should spin
                          //LOW = forward, HIGH = reverse
int pingDelay = 100; // how long the processor should idle before continuing,
                    // needed for ultrasonic ping to work

int brakeBHigh = LOW; // turn off the steering lock
int pwmBturn = 0;    // set steering motor speed to 0
int dirBLowLeft = LOW; // Which direction the motor should spin
                      //LOW = left?, HIGH = right?

long lastCm = 14;  // Used for speedometer
long carSpeed = 0; // Used for speedometer


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
  // pinMode(buttonPin, INPUT);
   
  Serial.begin(9600); // To see the values on the PC
}

void loop() {
long duration, inches, cm; // These 3 variables are used for the 
                            // Distance sensor's math functions below

  // copied from ultrasonic_range
  pinMode(pingPin, OUTPUT);   // Set the Ping pin to Send
  digitalWrite(pingPin, LOW); // Clear the line to the sensor
  delayMicroseconds(2);       // wait 0.002 seconds
  digitalWrite(pingPin, HIGH); // send the ping
  delayMicroseconds(5);        // wait 0.005 seconds
  digitalWrite(pingPin, LOW); // Clear the line to the sensor
                              // We sent that ping 0.007 seconds ago
  pinMode(pingPin, INPUT);    // Set the Ping pin to Receive
  duration = pulseIn(pingPin, HIGH); // set the variable named Duration to
                              // be the number of microseconds until the 
                              // ultrasonic ping comes back

  inches = microsecondsToInches(duration); // Calls the function that converts microseconds to inches
  cm = microsecondsToCentimeters(duration);// Calls the function that converts microseconds to centimeters
  carSpeed = lastCm - cm; //Speedometer. Sets carSpeed to be the previous distance minus the current distance to the wall. 
  lastCm = cm; // Replaces the previous distance to wall with current distance to wall.
  
  // Depending on the distance and car speed, speed up or slow down
 if (cm<30) { // if we're closer than 30cm
    if (carSpeed<3){ // if speed is less than 3
     dirALowForward = HIGH; // Direction: reverse
     brakeAHigh = LOW;  // Brake: off
     if  (pwmAspeed < 128) { // if PWM output is less than 128 (about 50%)
       pwmAspeed += 5; // increase PWM output by 5 (about 2%)
     }
   }else if (carSpeed>3){ // if speed is more than 3
     dirALowForward = HIGH; // Direction: reverse
     brakeAHigh = HIGH;  // Brakes on
     if  (pwmAspeed < 128) { //if PWM output is more than 128 (about 50%)
       pwmAspeed += 5; // increase PWM output by 5 (about 2%)
   }
  } 
} else { // at less than 30cm
     dirALowForward = LOW; // Direction: forward
     brakeAHigh = LOW;  // Brake: off
pwmAspeed = map(cm,30,300,20,255);

  }

// } else if (cm<1000){ // at less than 1 meter
//     dirALowForward = LOW; // Direction: forward
//     brakeAHigh = LOW;  // Brake: off
//    if (carSpeed<3){ // if carspeed is less than 20
//     if  (pwmAspeed < 200) { // if PWM is less than 245 (about 96%)
//       pwmAspeed += 20; // increase PWM by 20 (about 7.8%)
//   }
//   }else if (carSpeed>3){ // if carspeed is more than 20 (about 7.8%)
//     if  (pwmAspeed > 5) { // if PWM output is more than 5 (about 2%)
//       pwmAspeed -= 20; // reduce PWM output by 20 (about 7.8%)
//   } 
//  }
// } else { // at more than 1 meter
//     dirALowForward = LOW; // Direction: forward
//     brakeAHigh = LOW;  // Brake: off
//    if (carSpeed<3){ // if carspeed is less than 20
//     if  (pwmAspeed < 255) { // if PWM is less than 245 (about 96%)
//       pwmAspeed += 20; // increase PWM by 20 (about 7.8%)
//   }
//   }else if (carSpeed>3){ // if carspeed is more than 20 (about 7.8%)
//     if  (pwmAspeed > 5) { // if PWM output is more than 5 (about 2%)
//       pwmAspeed -= 20; // reduce PWM output by 20 (about 7.8%)
//   } 
//  }
// }

  if (pwmAspeed > 255) {
  pwmAspeed = 255; // Makes sure we never give more than 100%
}
  if (pwmAspeed < 0) {
  pwmAspeed = 0; // Makes sure we never give less than 0%
}

  Serial.print(inches);
  Serial.print(" in, ");
  Serial.print(cm);
  Serial.print(" cm, ");
  Serial.print(lastCm);
  Serial.print(" lastcm, ");
  Serial.print(carSpeed);
  Serial.print(" car speed, ");
  Serial.print(pwmAspeed);
  Serial.print(" pwmAspeed, ");
  Serial.print(dirALowForward);
  Serial.println(); 
  
  digitalWrite(motorAdir, dirALowForward); // Tell Motor A to go forward or reverse
  digitalWrite(motorAbrk, brakeAHigh);     // Apply or release Motor A's brakes
  digitalWrite(motorBdir, dirBLowLeft);   // Tell Motor B to turn left or right
  digitalWrite(motorBbrk, brakeBHigh);    // Apply or release Motor B's steering brakes
  analogWrite(motorApwm, pwmAspeed); // Apply PWM output to Motor A as set above
  
    delay(pingDelay); // Wait 0.1s, which is necessary for ultrasonic ping operation. Depending on the amount of code, 
                // this should be reduced.
}


// copied from ultrasonic ping
// Sound moves 1 inch every 74 microseconds. Divide by 2 to remove the sound's return distance
long microsecondsToInches(long microseconds) 
{                                            
  return microseconds / 74 / 2;
}

// Sound moves 1 centimeter every 29 microseconds. Divide by 2 to remove the sound's return distance
long microsecondsToCentimeters(long microseconds) 
{                                            
  return microseconds / 29 / 2;
}
