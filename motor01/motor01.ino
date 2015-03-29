#include <LiquidCrystal.h>

const int pingPin = 7;
//const int buttonPin = 7;     // the number of the pushbutton pin
const int analogInPin = A5;  // Analog input pin that the potentiometer is attached to

//int ledPin =  10;      // the number of the LED pin
int analogOutPin = 10; // Analog output pin that the LED is attached to
int sensorValue = 0;        // value read from the pot
int outputValue = 0;        // value output to the PWM (analog out)
int buttonState = 0;
int btnPressed = 1;
int lastButtonState = 0;
int buttonPushCounter = 0;

LiquidCrystal lcd(0, 6, 1, 2, 4, 5); // LCD input pins 4, 6, 11, 12, 13, 14

void setup() {
  
   lcd.begin(16, 2);
  // Print a message to the LCD.
  lcd.setCursor(0, 0);
  lcd.print("inch  out  microsec");
 
  // On the Ethernet Shield, CS is pin 4. It's set as an output by default.
  // Note that even if it's not used as the CS pin, the hardware SS pin 
  // (10 on most Arduino boards, 53 on the Mega) must be left as an output 
  // or the SD library functions will not work. 
  pinMode(10, OUTPUT);     // change this to 53 on a mega

}

void loop()
{
  // establish variables for duration of the ping, 
  // and the distance result in inches and centimeters:
  long duration, inches;

  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH);

  // convert the time into a distance
  inches = microsecondsToInches(duration);
  
  
  lcd.setCursor(0, 1);
  lcd.print("               ");
  lcd.setCursor(0, 1);
  lcd.print(inches);
  lcd.setCursor(4, 1);
  lcd.print(out);
  lcd.setCursor(8, 1);
  lcd.print(duration);
  
  delay(10);
}

long microsecondsToInches(long microseconds)
{
  // According to Parallax's datasheet for the PING))), there are
  // 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
  // second).  This gives the distance travelled by the ping, outbound
  // and return, so we divide by 2 to get the distance of the obstacle.
  // See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf
  return microseconds / 74 / 2;
}
