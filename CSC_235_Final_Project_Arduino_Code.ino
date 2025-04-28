#include <Adafruit_NeoPixel.h>
// sketch that connects to processing application
// and controls a tanks game

// neopixel strip
Adafruit_NeoPixel strip(20, 2);
int numPixels = 20;

// color variables
uint32_t red = strip.Color(255, 0, 0);
uint32_t green = strip.Color(0, 255, 0);
uint32_t off = strip.Color(0, 0, 0);

// joystick variables
int xPin = 0;
int yPin = 1;
int xVal;
int yVal;
int xIdle = 511; // x value of the joystick if the joystick is idle
int yIdle = 511; // y value of the joystick id the joystick is idle

// button variables
int shootButton = 5;
int startButton = 6;

// deadzone threshold for joystick
int deadzone = 100;

// center value joystick when it is at rest
int center = 512;

// represents the previous direction of the joystick
char prevDirection = 'S';  

// setup
void setup(){
  Serial.begin(9600);
  strip.begin();
  strip.show();

  // setting pin modes
  pinMode(xPin, INPUT);
  pinMode(yPin, INPUT);

  pinMode(shootButton, INPUT);
  pinMode(startButton, INPUT);
}

// loop
void loop(){
  neopixelState();
  movementMapping();
  buttonMapping();
}

// reads the serial port and writes the appropriate values 
// for the neopixels
void neopixelState() {
  // wait for a single‐char command from Processing
  if (Serial.available()) {
    char command = Serial.read();
    switch(command) {
      case 'W':  // win
        fillStrip(green);    // green
        break;
      case 'D':  // death
        fillStrip(red);    // red
        break;
      case 'C':  // clear
        fillStrip(off); // off
        break;
    }
  }
}

// reads the joystick values
void movementMapping() {
  int x = analogRead(xPin);
  int y = analogRead(yPin);

  // determine direction
  char direction;
  if (y > center + deadzone) {
    direction = 'D';
  }
  else if (y < center - deadzone) { 
    direction = 'U';
  }
  else if (x > center + deadzone) {
     direction = 'R';
  }
  else if (x < center - deadzone) { 
    direction = 'L';
  }
  else {
    direction = 'S';
  }

  // only send when it direction changes
  if (direction != prevDirection) {
    // print new line character to act as delimeter
    Serial.print('/');
    Serial.println(direction);
    prevDirection = direction;
  }
}

// reads the buttons and writes the correct information across the serial port
void buttonMapping() {
  // shoot button
  if (digitalRead(shootButton) == HIGH) {
    Serial.println("/s");
    delay(300);
  }

  // start button
  if (digitalRead(startButton) == HIGH) {
    Serial.println("/r");
    delay(300);
  }
}

////////////////////////////
// NEOPIXEL STRIP FUNCTIONS
////////////////////////////

// fills the strip with one solid color
void fillStrip(uint32_t aColor) {
  for (int i = 0; i <= numPixels; i++) {
    strip.setPixelColor(i, aColor);
  }
  strip.show();
}