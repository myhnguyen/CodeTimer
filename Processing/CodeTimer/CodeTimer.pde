/*
  CodeTimer
  by My Nguyen
  Expects a string of comma-delimted Serial data from Arduino:
  ** field is 0 or 1 as a string (switch) — not used
  ** second fied is 0-4095 (potentiometer)
  ** third field is 0-4095 (LDR) — not used, we only check for 2 data fields  
  
 */
 
// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      

// Data coming in from the data fields
// data[0] = "1" or "0"                  -- BUTTON
// data[1] = 0-4095, e.g "2049"          -- POT VALUE
// data[2] = 0-4095, e.g. "1023"        -- LDR value
String [] data;

int switchValue = 0;
int potValue = 0;
int ldrValue = 0;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 2;

//color array 
color [] colors = {#ffff97, #CD5C5C, #f38997, #aae9e1, #eead81};
int currentColor = 2;

//timing for colors
Timer displayTimer;
Timer anotherTimer; 
float timePerColor = 0; 
float minTimePerColor = 100; 
float maxTimePerColor = 5000; 
int defaultTimerPerColor = 1500; 

// mapping pot values
float minPotValue = 0;
float maxPotValue = 4095;

// mapping pot values
float minldrValue = 0;
float maxldrValue = 3000;



PFont displayFont; 




void setup  () {
  size (1000,  600);    
  
  // List all the available serial ports
  printArray(Serial.list());
    
  // Set the com port and the baud rate according to the Arduino IDE
  //-- use your port name
  myPort  =  new Serial (this, "/dev/cu.SLAB_USBtoUART",  115200); 
  
  // Allocate the timer
  displayTimer = new Timer(defaultTimerPerColor);
  anotherTimer = new Timer(1000); 

  
  // start the timer. Every 1/2 second, it will do something
  displayTimer.start();
  anotherTimer.start(); 
  

 // eye = loadImage("img/eye.gif"); 
  
  
  textAlign(CENTER); 
  displayFont = createFont("Georgia", 32); 

} 

// We call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  
    
    print(inBuffer);
    
    // This removes the end-of-line from the string 
    inBuffer = (trim(inBuffer));
    
    // This function will make an array of TWO items, 1st item = switch value, 2nd item = potValue
    data = split(inBuffer, ',');
   
   // we have THREE items — ERROR-CHECK HERE
   if( data.length >= 2 ) {
      switchValue = int(data[0]);           // first index = switch value 
      potValue = int(data[1]);               // second index = pot value
      ldrValue = int(data[2]);               // third index = LDR value
      
      // change the display timer
      timePerColor = map( potValue,maxPotValue , minPotValue, minTimePerColor, maxTimePerColor );
      displayTimer.setTimer( int(timePerColor));
   }
  }
} 

//-- change background to red if we have a button
void draw () {  
  
  checkSerial(); 
  drawBackground();
  checkTimer();  
  drawFlower(); 
  

  
}
void drawBackground() {
    background(colors[currentColor]);
      
        if (ldrValue<300)
  {
      noStroke();
  
  for (int x = 0; x <= width; x += 50){ // ------------------
    for(int y = 0; y <=height; y += 50){ //------------------
    fill(random(255), 0, random(255));
    ellipse(x, y ,potValue ,ldrValue);
    }
  
  }  
    
  }
  if (ldrValue==minldrValue || potValue ==maxPotValue)
  {
    fill(255); 
      textSize(20); 
      text("ARE YOU READY TO PARTYYY!?? ", width/2, 80); 
    
  }
    else {
    fill(255); 
      textSize(100); 
      text("RAVE TIME!!! ", width/2, 80); 
    
  }
  
  

}




void drawFlower() {
  
   // set centre point
  translate(width/2, height/2);
  // rotate canvas using frame count
  rotate(radians(frameCount));
  // draw 5 petals, rotating after each one
  fill(#fe7481); // pink
  for (int i = 0; i < 5; i++) {
    ellipse(0, -40, ldrValue, ldrValue);
    rotate(radians(72));
  }
  // centre circle
  fill(#f0d581); // light yellow
  ellipse(0, 0, ldrValue, ldrValue);
  

  
}
     
  







void checkTimer() {
  
 // check to see if timer is expired, do something and then restart timer
  if( displayTimer.expired() ) {
    currentColor++;
    
    if (currentColor == colors.length ) 
      currentColor = 0; 
    
    
    displayTimer.start();
  }
  
  if ( anotherTimer.expired() ) {
    
    anotherTimer.start();   
  }
  
}
