import processing.serial.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioOutput out;
float thickness;
PVector lightLoc;
float ambient_light_b;
ArrayList mydata;
Serial serialPort;
int timer; 
int wait;

void setup() {
  thickness = 50;
  lightLoc = new PVector(width/2, 50, -400);
  size(800, 600, P3D);
  ambient_light_b = 0.9;
  minim = new Minim(this);
  out  = minim.getLineOut();
  mydata = new ArrayList(200);
  printArray(Serial.list());
  serialPort = new Serial(this, Serial.list()[3], 9600);
  wait = 1000;
  timer = millis();
}

void draw() {

  background(30);

  getSensorData();
  drawLines();

  if (millis()-timer>wait) {
    ambient_light_b = map((Float)mydata.get(mydata.size()-1), 0, 200, 0.4, 0.9);
    timer = millis();
  }

  ambientLight(255*ambient_light_b, 255*ambient_light_b, 240*ambient_light_b, lightLoc.x, lightLoc.y, lightLoc.z);
  spotLight(255*ambient_light_b, 255*ambient_light_b, 255*ambient_light_b, lightLoc.x, lightLoc.y, lightLoc.z, width/2, height/2-200, -380, PI/4, 0.4);
  ambient_light_b  =  ambient_light_b-0.005;


  //for walls
  fill(255);
  noStroke();


  //left wall
  pushMatrix();
  translate(-80, 160, -400);
  box(thickness, 800, 800);
  popMatrix();

  //back wall
  pushMatrix();
  translate(width/2, 160, -800);
  box(1000, 800, thickness);
  popMatrix();

  //right wall
  pushMatrix();
  translate(900, 160, -400);
  box(thickness, 800, 800);
  popMatrix();

  //floor "wall"
  pushMatrix();
  translate(width/2, height-30, -400);
  box(940, thickness, 1100);
  popMatrix();

  //ceiling
  pushMatrix();
  translate(width/2, -180, -400);
  box(940, thickness, 1100);
  popMatrix();
}


void getSensorData() {
  if ( serialPort.available() > 0) {
    float temp = serialPort.read();

    mydata.add(temp);
    if (mydata.size() >= 2) {

      float a = 0;
      float b = 0;

      a = (Float)mydata.get(mydata.size()-1);
      b = (Float)mydata.get(mydata.size()-2);

      if (a < b) {
        out.playNote("A");
      } else if ( a == b ) {
        out.playNote("4");
      } else {
        out.playNote("6");
      }
    }
    if (mydata.size() > 80) {
      mydata.remove(0);
    };
  }
}



void drawLines() {
  pushMatrix();
  translate(-50, -350, -500);
  if (mydata.size() >= 3) {
    int counter = 1;
    for (int i=0; i<(mydata.size()-1)*10; i += 10) {
      float data1 = (Float)mydata.get(counter-1);
      float data2 = (Float)mydata.get(counter);

      stroke(0);
      strokeWeight(0.8);

      line(i, height-data1, i+10, height-data2); 
      println("i= " + i + "/ counter= " + counter );
      strokeWeight(3);
      stroke(255);
      counter++;
    }
  }
  popMatrix();
}