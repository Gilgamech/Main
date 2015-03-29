/*
  Button
 
 Turns on and off a light emitting diode(LED) connected to digital  
 pin 13, when pressing a pushbutton attached to pin 2. 
 
 
 The circuit:
 * LED attached from pin 13 to ground 
 * pushbutton attached to pin 2 from +5V
 * 10K resistor attached to pin 2 from ground
 
 * Note: on most Arduinos there is already an LED on the board
 attached to pin 13.
 
 
 created 2005
 by DojoDave <http://www.0j0.org>
 modified 30 Aug 2011
 by Tom Igoe
 
 This example code is in the public domain.
 
 http://www.arduino.cc/en/Tutorial/Button
 */

// constants won't change. They're used here to 
// set pin numbers:
const int analogInPin = A0;  // Analog input pin that the potentiometer is attached to
const int buttonPin = 2;     // the number of the pushbutton pin

// variables will change:
int sensorValue = 0;        // value read from the pot
int outputValue = 0;        // value output to the PWM (analog out)
int buttonState = 0;         // variable for reading the pushbutton status
int analogOutPin = 7;

void setup() {
    Serial.begin(9600); 
  // initialize the LED pin as an output:
//  pinMode(ledRED, OUTPUT);      
//  pinMode(ledBLUE, OUTPUT);      
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);     
}

void loop(){
    // read the analog in value:
  //sensorValue = analogRead(analogInPin);  
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);
  sensorValue = analogRead(analogInPin);        
  
  if (buttonState == LOW) {     
    analogOutPin = 8;
  outputValue = map(sensorValue, 0, 1023, 0, 255);  
  analogWrite(analogOutPin, outputValue);   
  // print the results to the serial monitor:
  Serial.print("BTN=" );
  Serial.print(buttonState);
  Serial.print("\t sensor=" );
  Serial.print(sensorValue);
  Serial.print("\t output=");      
  Serial.println(outputValue);   
  Serial.print("\t LED=");      
  Serial.println(analogOutPin);   
    //  outputValue = 0 ;  
     delay(2);
  } else {
analogOutPin = 6;
  outputValue = map(sensorValue, 0, 1023, 0, 255);  
  analogWrite(analogOutPin, outputValue);   
  // print the results to the serial monitor:
  Serial.print("BTN=" );
  Serial.print(buttonState);
  Serial.print("\t sensor=" );
  Serial.print(sensorValue);
  Serial.print("\t output=");      
  Serial.println(outputValue);   
  Serial.print("\t LED=");      
  Serial.println(analogOutPin);   
   delay(2);
  }

  // wait 2 milliseconds before the next loop
  // for the analog-to-digital converter to settle
  // after the last reading:
 
}
