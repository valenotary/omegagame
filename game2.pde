//libraries for physics
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

//libraries for interacting with arduino
import processing.serial.*;
import cc.arduino.*;

//Declaring stuff for box2d
Box2DProcessing box2d;
Box box;

//Declaring lists to keep track of Box2D stuff I put
//into the environment
ArrayList<Boundary> boundaries;
ArrayList<Projectile> projectiles;

//stuff for the arduino 
Arduino arduino;

int sensor = 0;
float read;

float r, g, b;

float value;
color bColor;
color test;

int buttonPin = 3;
int ledPin = 13;
int buttonState;

float buttonTime;
boolean canPress;

//general declarations pertaining to the game
PFont font;
int score;
float time;

//game controller booleans
boolean menu, gameRunning;

void setup() {
  size(500, 500);
  background(255);
  smooth();
  //box2d setup
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  box2d.setGravity(0, -30);

  //Arduino setup
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  //potentiometer stuff
  test = color(0);
  r = random(255);
  g = random(255);
  b = random(255);
  background(r, g, b);
  //read = arduino.analogRead(sensor);


  //trgger stuff
  arduino.pinMode(buttonPin, Arduino.INPUT);
  arduino.pinMode(ledPin, Arduino.OUTPUT);
  buttonState = 1;
  //time = millis();
  canPress = true;
  arduino.digitalWrite(ledPin, arduino.HIGH);

  //initializing general stuff
  box = new Box(50, 50, 10, 10);
  boundaries = new ArrayList<Boundary>();


  font = createFont("font/8bit_wonder/8-BIT WONDER.TTF", 16);

  boundaries.add(new Boundary(width/4, height-5, width/2-50, 10));
  boundaries.add(new Boundary(3*width/4, height-50, width/2-50, 10));

  projectiles = new ArrayList<Projectile>();

  score = 0;
  textFont(font);
  time = millis();
}

void draw() {
  if (menu) {
    //show menu stuff
  } else if (gameRunning) {
    //FOR PONTENTIOMETER
    buttonState = arduino.digitalRead(buttonPin);

    //FOR LED AND BUTTON
    //just outputting button state
    if (canPress) {
      arduino.digitalWrite(ledPin, arduino.HIGH);
      if (buttonState == arduino.LOW) {
        //SHOOT
        for (int i = 0; i < 5; i++) {
          projectiles.add(new Projectile(random(width), 0, random(4, 8)));
        }
        buttonTime = millis();
        print("STARTING TIMER");
        canPress = false;
      }
    } else {
      arduino.digitalWrite(ledPin, arduino.LOW);
    }
    if (millis() > buttonTime + 5000 && canPress == false) {
      print("RELOADED");
      canPress = true;
    }

    read = arduino.analogRead(sensor);
    test = (int)map(read, 0, 1023, 0, 255);
    if (r > 255) {
      r = r - ((r + test)%255);
    } else {
      r = test;
    }
    background(r, g, b);

    box2d.step();
    box.move();
    box.display();
    for (Boundary wall : boundaries) {
      wall.display();
    }

    for (int i = projectiles.size() - 1; i >= 0; i--) {
      Projectile p = projectiles.get(i);
      p.display();
      if (p.done()) {
        projectiles.remove(i);
      }
    }

    if (!box.done()) {
      if (millis() > time + 1000) {
        score += 1;
        time = millis();
      }
    } 
    {
      fill(0);
      text("Time alive: " + score, 10, 50);
    }
  }
}

void beginContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  //checking for jump for the box
  if (o1.getClass() == Box.class && o2.getClass() == Boundary.class) {
    Box merp = (Box) o1;
    merp.canJump = true;
  } else if (o2.getClass() == Box.class && o1.getClass() == Boundary.class) {
    Box merp = (Box) o1;
    merp.canJump = true;
  }
  //need collision check for bullets
  if (o1.getClass() == Box.class && o2.getClass() == Projectile.class) {
    Box merp = (Box) o1;
    gameRunning = false;
  } else if (o2.getClass() == Projectile.class && o1.getClass() == Box.class) {
    Box merp = (Box) o1;
    gameRunning = false;
  }
}

void endContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Body b1 = f1.getBody();
  Object o1 = b1.getUserData();
  Box merp = (Box) o1;
  merp.canJump = false;
}

void keyPressed() {
  box.setMove(keyCode, true);
}

void keyReleased() {
  box.setMove(keyCode, false);
}

void reset() {
}
