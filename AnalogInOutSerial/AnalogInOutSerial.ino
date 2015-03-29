#include <LiquidCrystal.h>


const int buttonPin = 0;     // the number of the pushbutton pin
const int analogInPin = A5;  // Analog input pin that the potentiometer is attached to

int ledPin =  10;      // the number of the LED pin
int analogOutPin = 10; // Analog output pin that the LED is attached to
int sensorValue = 0;        // value read from the pot
int outputValue = 0;        // value output to the PWM (analog out)
int buttonState = 0;
int btnPressed = 1;
int lastButtonState = 0;
int buttonPushCounter = 0;

LiquidCrystal lcd(1, 6, 5, 4, 3, 2); // LCD input pins 4, 6, 11, 12, 13, 14

void setup() {
  pinMode(ledPin, OUTPUT);      
  pinMode(buttonPin, INPUT);     

  // set up the LCD's number of columns and rows: 
  lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.setCursor(0, 0);
  lcd.print("LED:");
  lcd.setCursor(0, 1);
  lcd.print("out:");
  lcd.setCursor(8, 0);
  lcd.print("tim:");
  lcd.setCursor(8, 1);
  lcd.print("cnt:");
}

void loop() {

  buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH) {     
    analogOutPin = 10;
    sensorValue = analogRead(analogInPin); 
    outputValue = map(sensorValue, 0, 700, 0, 255);  
    analogWrite(analogOutPin, outputValue); 
    // set the cursor to column 0, line 1
    // (note: line 1 is the second row, since counting begins with 0):
    lcd.setCursor(4, 0);
    lcd.print("HIGH");
    lcd.setCursor(4, 1);
    lcd.print("    ");
    lcd.setCursor(4, 1);
    lcd.print(outputValue);
    lcd.setCursor(12, 0);
    lcd.print(millis()/1000);
    lcd.setCursor(12, 1);
    lcd.print(buttonPushCounter);
    lastButtonState = buttonState;
    delay(2); 
  } else {
    analogOutPin = 11;
    sensorValue = analogRead(analogInPin); 
    outputValue = map(sensorValue, 0, 700, 0, 255);  
    analogWrite(analogOutPin, outputValue); 
    if (buttonState != lastButtonState) {
    buttonPushCounter++;
    }
    // set the cursor to column 0, line 1
    // (note: line 1 is the second row, since counting begins with 0):
    lcd.setCursor(4, 0);
    lcd.print("LOW ");
    lcd.setCursor(4, 1);
    lcd.print("    ");
    lcd.setCursor(4, 1);
    lcd.print(outputValue);
    lcd.setCursor(12, 0);
    lcd.print(millis()/1000);
    lcd.setCursor(12, 1);
    lcd.print(buttonPushCounter);
    lastButtonState = buttonState;
    delay(2); 
  }  

}

