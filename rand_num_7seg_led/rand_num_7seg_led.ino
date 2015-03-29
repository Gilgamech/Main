//random number generator
//set up 7-segment
int top = 5; // top LED of 7-segment
int upleft = 6; // upper left LED of 7-segment
int upright = 2; // upper right LED of 7-segment
int mid = 8; // upper right LED of 7-segment
int botleft = 9; // lower left LED of 7-segment
int botright = 12; // lower right LED of 7-segment
int bottom = 11; // bottom LED of 7-segment

int buttonPin = 1;

int randnum = 0;
int buttonState = 0;         // variable for reading the pushbutton status


void setup() {
pinMode(top, OUTPUT);
pinMode(upleft, OUTPUT);
pinMode(upright, OUTPUT);
pinMode(mid, OUTPUT);
pinMode(botleft, OUTPUT);
pinMode(botright, OUTPUT);
pinMode(bottom, OUTPUT);
pinMode(buttonPin, OUTPUT);

  pinMode(buttonPin, INPUT);
  
//  digitalWrite(top, LOW);
//  digitalWrite(upleft, LOW);
//  digitalWrite(upright, LOW);
//  digitalWrite(mid, LOW);
//  digitalWrite(botleft, LOW);
//  digitalWrite(botright, LOW);
//  digitalWrite(bottom, LOW);

}

void loop() {
//  
    buttonState = digitalRead(buttonPin);
    if (buttonState == LOW) { 
////randnum = random(0,10);
//randnum += 1;
digitalWrite(top, LOW);
    }
//
//if (randnum = 0) {
//  digitalWrite(top, HIGH);
//  digitalWrite(upleft, HIGH);
//  digitalWrite(upright, HIGH);
//  digitalWrite(mid, LOW);
//  digitalWrite(botleft, HIGH);
//  digitalWrite(botright, HIGH);
//  digitalWrite(bottom, HIGH);
//} else if (randnum = 1) {
//  digitalWrite(top, LOW);
//  digitalWrite(upleft, LOW);
//  digitalWrite(upright, HIGH);
//  digitalWrite(mid, LOW);
//  digitalWrite(botleft, LOW);
//  digitalWrite(botright, HIGH);
//  digitalWrite(bottom, LOW);
//} else if (randnum = 2) {
//  digitalWrite(top, HIGH);
//  digitalWrite(upleft, LOW);
//  digitalWrite(upright, HIGH);
//  digitalWrite(mid, HIGH);
//  digitalWrite(botleft, HIGH);
//  digitalWrite(botright, LOW);
//  digitalWrite(bottom, HIGH);
//} else if (randnum = 3) {
//  digitalWrite(top, HIGH);
//  digitalWrite(upleft, LOW);
//  digitalWrite(upright, HIGH);
//  digitalWrite(mid, HIGH);
//  digitalWrite(botleft, LOW);
//  digitalWrite(botright, HIGH);
//  digitalWrite(bottom, HIGH);
//} else if (randnum = 4) {
//  digitalWrite(top, LOW);
//  digitalWrite(upleft, HIGH);
//  digitalWrite(upright, HIGH);
//  digitalWrite(mid, HIGH);
//  digitalWrite(botleft, HIGH);
//  digitalWrite(botright, LOW);
//  digitalWrite(bottom, LOW);
//} else if (randnum = 5) {
//  digitalWrite(top, HIGH);
//  digitalWrite(upleft, HIGH);
//  digitalWrite(upright, LOW);
//  digitalWrite(mid, HIGH);
//  digitalWrite(botleft, LOW);
//  digitalWrite(botright, HIGH);
//  digitalWrite(bottom, HIGH);
//} else if (randnum = 6) {
//  digitalWrite(top, HIGH);
//  digitalWrite(upleft, HIGH);
//  digitalWrite(upright, LOW);
//  digitalWrite(mid, HIGH);
//  digitalWrite(botleft, HIGH);
//  digitalWrite(botright, HIGH);
//  digitalWrite(bottom, HIGH);
//} else if (randnum = 7) {
//  digitalWrite(top, HIGH);
//  digitalWrite(upleft, LOW);
//  digitalWrite(upright, HIGH);
//  digitalWrite(mid, LOW);
//  digitalWrite(botleft, LOW);
//  digitalWrite(botright, HIGH);
//  digitalWrite(bottom, LOW);
//} else if (randnum = 8) {
  digitalWrite(top, HIGH);
  digitalWrite(upleft, HIGH);
  digitalWrite(upright, HIGH);
  digitalWrite(mid, HIGH);
  digitalWrite(botleft, HIGH);
  digitalWrite(botright, HIGH);
  digitalWrite(bottom, HIGH);
//} else if (randnum = 9) {
//  digitalWrite(top, HIGH);
//  digitalWrite(upleft, HIGH);
//  digitalWrite(upright, HIGH);
//  digitalWrite(mid, HIGH);
//  digitalWrite(botleft, LOW);
//  digitalWrite(botright, HIGH);
//  digitalWrite(bottom, HIGH);
//} else {
//  digitalWrite(top, LOW);
//  digitalWrite(upleft, LOW);
//  digitalWrite(upright, LOW);
//  digitalWrite(mid, LOW);
//  digitalWrite(botleft, LOW);
//  digitalWrite(botright, LOW);
//  digitalWrite(bottom, LOW);
//};
}

