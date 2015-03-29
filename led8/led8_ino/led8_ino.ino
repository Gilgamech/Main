#include <LiquidCrystal.h>
int ledPin = 8; // the 7-seg output pin. 
int buttonState = 0;
int lastButtonState = 0;
int buttonPushCounter = 0;

LiquidCrystal lcd(1, 6, 5, 4, 3, 2); // LCD input pins 4, 6, 11, 12, 13, 14

void setup() {
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(13, OUTPUT);
  pinMode(0, INPUT);     

  // set up the LCD's number of columns and rows: 
//  lcd.begin(16, 2);
//  // Print a message to the LCD.
//  lcd.setCursor(0, 0);
//  lcd.print("LED:");
//  lcd.setCursor(0, 1);
//  lcd.print("out:");
//  lcd.setCursor(8, 0);
//  lcd.print("tim:");
//  lcd.setCursor(8, 1);
//  lcd.print("cnt:");
}

void loop() {
  buttonState = digitalRead(0);
  if (buttonState == LOW) {     
    // set the cursor to column 0, line 1
    // (note: line 1 is the second row, since counting begins with 0):
//    lcd.setCursor(4, 0);
//    lcd.print("HIGH");
//    lcd.setCursor(12, 0);
//    lcd.print(500-millis()/1000);
//    lcd.setCursor(12, 1);
//    lcd.print(buttonPushCounter);
//    lastButtonState = buttonState;
//    delay(2); 
  } else {
    //if (buttonState != lastButtonState) {
    buttonPushCounter = random(0,10);
    }
    if (buttonPushCounter == 1){
digitalWrite(1, LOW); // Top Bar
digitalWrite(2, LOW); // Up Left
digitalWrite(3, HIGH); // Up Right
digitalWrite(4, LOW); // Middle bar
digitalWrite(5, HIGH); // Bottom Right
digitalWrite(6, LOW); // Bottom Left
digitalWrite(7, LOW); // Bottom bar
} 
if (buttonPushCounter == 2){
digitalWrite(1, HIGH); // Top Bar
digitalWrite(2, LOW); // Up Left
digitalWrite(3, HIGH); // Up Right
digitalWrite(4, HIGH); // Middle bar
digitalWrite(5, LOW); // Bottom Right
digitalWrite(6, HIGH); // Bottom Left
digitalWrite(7, HIGH); // Bottom bar
} 
if (buttonPushCounter == 3){
digitalWrite(1, HIGH); // Top Bar
digitalWrite(2, LOW); // Up Left
digitalWrite(3, HIGH); // Up Right
digitalWrite(4, HIGH); // Middle bar
digitalWrite(5, HIGH); // Bottom Right
digitalWrite(6, LOW); // Bottom Left
digitalWrite(7, HIGH); // Bottom bar
} 
if (buttonPushCounter == 4){
digitalWrite(1, LOW); // Top Bar
digitalWrite(2, HIGH); // Up Left
digitalWrite(3, HIGH); // Up Right
digitalWrite(4, HIGH); // Middle bar
digitalWrite(5, HIGH); // Bottom Right
digitalWrite(6, LOW); // Bottom Left
digitalWrite(7, LOW); // Bottom bar
} 
if (buttonPushCounter == 5){
digitalWrite(1, HIGH); // Top Bar
digitalWrite(2, HIGH); // Up Left
digitalWrite(3, LOW); // Up Right
digitalWrite(4, HIGH); // Middle bar
digitalWrite(5, HIGH); // Bottom Right
digitalWrite(6, LOW); // Bottom Left
digitalWrite(7, HIGH); // Bottom bar
} 
if (buttonPushCounter == 6){
digitalWrite(1, HIGH); // Top Bar
digitalWrite(2, HIGH); // Up Left
digitalWrite(3, LOW); // Up Right
digitalWrite(4, HIGH); // Middle bar
digitalWrite(5, HIGH); // Bottom Right
digitalWrite(6, HIGH); // Bottom Left
digitalWrite(7, HIGH); // Bottom bar
} 
if (buttonPushCounter == 7){
digitalWrite(1, HIGH); // Top Bar
digitalWrite(2, LOW); // Up Left
digitalWrite(3, HIGH); // Up Right
digitalWrite(4, LOW); // Middle bar
digitalWrite(5, HIGH); // Bottom Right
digitalWrite(6, LOW); // Bottom Left
digitalWrite(7, LOW); // Bottom bar
} 
if (buttonPushCounter == 8){
digitalWrite(1, HIGH); // Top Bar
digitalWrite(2, HIGH); // Up Left
digitalWrite(3, HIGH); // Up Right
digitalWrite(4, HIGH); // Middle bar
digitalWrite(5, HIGH); // Bottom Right
digitalWrite(6, HIGH); // Bottom Left
digitalWrite(7, HIGH); // Bottom bar
} 
if (buttonPushCounter == 9){
digitalWrite(1, HIGH); // Top Bar
digitalWrite(2, HIGH); // Up Left
digitalWrite(3, HIGH); // Up Right
digitalWrite(4, HIGH); // Middle bar
digitalWrite(5, HIGH); // Bottom Right
digitalWrite(6, LOW); // Bottom Left
digitalWrite(7, HIGH); // Bottom bar
}
if (buttonPushCounter == 10){
buttonPushCounter = 0;
digitalWrite(1, HIGH); // Top Bar
digitalWrite(2, HIGH); // Up Left
digitalWrite(3, HIGH); // Up Right
digitalWrite(4, LOW); // Middle bar
digitalWrite(5, HIGH); // Bottom Right
digitalWrite(6, HIGH); // Bottom Left
digitalWrite(7, HIGH); // Bottom bar
}


    // set the cursor to column 0, line 1
    // (note: line 1 is the second row, since counting begins with 0):
//    lcd.setCursor(4, 0);
//    lcd.print("LOW ");
//    lcd.setCursor(12, 0);
//    lcd.print(500-millis()/1000);
//    lcd.setCursor(12, 1);
//    lcd.print(buttonPushCounter);
//    lastButtonState = buttonState;
    delay(50); 
  }  



//}

