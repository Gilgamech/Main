#include <LiquidCrystal.h>


const int buttonPin = 12;     // the number of the pushbutton pin
const int ledPin =  10;      // the number of the LED pin
const int analogInPin = A5;  // Analog input pin that the potentiometer is attached to

int analogOutPin = 10; // Analog output pin that the LED is attached to
int sensorValue = 0;        // value read from the pot
int outputValue = 0;        // value output to the PWM (analog out)
int buttonState = 0;
int buttonPress = 0;
int lastButtonState = 0;

LiquidCrystal lcd(1, 6, 5, 4, 3, 2);

void setup() {
  //Serial.begin(9600); 
  pinMode(ledPin, OUTPUT);      
  pinMode(buttonPin, INPUT);     
    // set up the LCD's number of columns and rows: 
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.print("PIN ");
  lcd.setCursor(0, 1);
  lcd.print("Out ");
}

void loop() {

  buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH) {     
  analogOutPin = 10;
  } else {
  analogOutPin = 11;
  if (buttonState != lastButtonState) {
    buttonPress++;
     }
  }
  sensorValue = analogRead(analogInPin); 
  outputValue = map(sensorValue, 0, 700, 0, 255);  
  analogWrite(analogOutPin, outputValue); 
    
  // set the cursor to column 0, line 1
  // (note: line 1 is the second row, since counting begins with 0):
  lcd.setCursor(4, 0);
  lcd.print("    ");
  lcd.setCursor(4, 0);
  lcd.print(analogOutPin);
  lcd.setCursor(4, 1);
  lcd.print("    ");
  lcd.setCursor(4, 1);
  lcd.print(outputValue);
  // print the number of seconds since reset:
  lcd.setCursor(13, 0);
  lcd.print(millis()/1000);
  lcd.setCursor(13, 1);
  lcd.print(buttonPress);
  lastButtonState = buttonState;
  
  delay(2); 
}
