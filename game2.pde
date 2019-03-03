//libraries for physics
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import processing.sound.*;

//libraries for interacting with arduino
import processing.serial.*;
import cc.arduino.*;

SoundFile file;
SoundFile jump;
SoundFile shoot;
SoundFile land;
SoundFile dead;

boolean playOnce;
//Declaring stuff for box2d
Box2DProcessing box2d;
Box box;

//Declaring lists to keep track of Box2D stuff I put
//into the environment
ArrayList<Boundary> boundaries;
ArrayList<Projectile> projectiles;
ArrayList<kBound> kinPlats;

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
float kTime;
boolean canPress;

//joystick
int joyX = 1;
int joyY = 2;
int xValue, yValue;

//pause stuff
int gButton = 2;
int ledPin2 = 12;
int gButtonState;

float gButtonTime;
boolean canPress2;
boolean pause;

//general declarations pertaining to the game
PFont font;
int score;
float time;
Button menuButton, resetButton;

//game controller booleans
boolean menu, gameRunning;


void setup() {
  size(600, 600);
  background(255);
  smooth();
  //box2d setup
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.listenForCollisions();
  box2d.setGravity(0, -30);

  file = new SoundFile(this, "omegarip.wav");
  jump = new SoundFile(this, "jump.wav");
  shoot = new SoundFile(this, "shoot.wav");
  land = new SoundFile(this, "land.wav");
  dead = new SoundFile(this, "dead.wav");
  playOnce = true;

  //Arduino setup
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  //potentiometer stuff
  test = color(0);
  r = random(255);
  g = random(255);
  b = random(255);
  background(r, g, b);
  //read = arduino.analogRead(sensor);


  //trigger stuff
  arduino.pinMode(buttonPin, Arduino.INPUT);
  arduino.pinMode(ledPin, Arduino.OUTPUT);
  buttonState = 1;
  //time = millis();
  canPress = true;
  arduino.digitalWrite(ledPin, arduino.HIGH);

  //gBUTTON STUFF
  arduino.pinMode(gButton, Arduino.INPUT);
  arduino.pinMode(ledPin2, Arduino.OUTPUT);
  canPress2 = true;
  gButtonState = 1;
  gButtonTime = millis();

  //initializing general stuff
  box = new Box(50, 50, 10, 10);
  boundaries = new ArrayList<Boundary>();


  font = createFont("font/8bit_wonder/8-BIT WONDER.TTF", 16);

  boundaries.add(new Boundary(width/4, height-5, width/2-50, 10));
  boundaries.add(new Boundary(3*width/4, height-50, width/2-50, 10));

  projectiles = new ArrayList<Projectile>();
  kinPlats = new ArrayList<kBound>();

  //MENU BUTTON
  menuButton = new Button(width / 2 - 25, height / 2 + 10, 250, 50);
  resetButton = new Button(width / 2 + 100, height / 2 + 10, 200, 50);

  for (int i = 0; i < 5; i++) {
    kinPlats.add(new kBound(random(width), random(height), random(width / 2), 50));
  }
  kTime = millis();

  score = 0;
  textFont(font);
  menu = true;
  gameRunning = false;
  time = millis();
}

void draw() {
  if (menu) {
    //show menu stuff
    fill(0);
    text("DON'T SHROOT", width / 2, height / 2);
    //start text here
    fill(0);
    menuButton.display();
    fill(255);
    text("PRESS TO START", width / 2, height / 2 + 30);
    if (mousePressed && mouseButton == LEFT && menuButton.contains(mouseX, mouseY)) {
      print("CLICK");
      pause = false;
      gameRunning = true;
      menu = false;
    }
  } else if (gameRunning) {
    //FOR PONTENTIOMETER
    buttonState = arduino.digitalRead(buttonPin);
    gButtonState = arduino.digitalRead(gButton);

    //FOR LED AND BUTTON(2)
    if (canPress2) {
      arduino.digitalWrite(ledPin2, arduino.HIGH);
      if (gButtonState == arduino.LOW) {
        //PAUSE
        pause = true;
        gButtonTime = millis();
        print("STARTING G TIMER");
        canPress2 = false;
      }
    } else {
      arduino.digitalWrite(ledPin2, arduino.LOW);
    }
    if (millis() > gButtonTime + 10000 && canPress2 == false) {
      print(" G RELOADED");
      canPress2 = true;
    }
    if (millis() > gButtonTime + 3000) {
      pause = false;
    }

    //FOR LED AND BUTTON
    //just outputting button state
    if (canPress) {
      arduino.digitalWrite(ledPin, arduino.HIGH);
      if (buttonState == arduino.LOW) {
        //SHOOT
        for (int i = 0; i < 5; i++) {
          projectiles.add(new Projectile(random(width), 0, random(4, 8)));
        }
        shoot.play();
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

    //POTENTIOMETER
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

    for (int i = kinPlats.size() - 1; i >= 0; i--) {
      kBound k = kinPlats.get(i);
      k.display();
      if (pause) k.b.setLinearVelocity(new Vec2(0, 0));
      if (k.done()) {
        kinPlats.remove(i);
      }
    }

    if (millis() > kTime + 2000) {
      //print("SPAWNING");
      kinPlats.add(new kBound(random(width), random(height), random(width / 2), random(10, 20)));

      for (int i =kinPlats.size() - 1; i >= 0; i--) {
        kBound k = kinPlats.get(i);
        if (!pause)
          k.randomMove();
      }


      kTime = millis();
    }


    xValue = arduino.analogRead(joyX);
    yValue = arduino.analogRead(joyY);
    float xMap = map(xValue, 0, 1023, 0, width);
    float yMap = map(yValue, 0, 1023, 0, height);
    
    ellipse(xMap - 20, yMap - 20, 20, 20); 

    if (box.done()) {
      gameRunning = false;
    }

    if (!box.done()) {
      if (millis() > time + 1000) {
        score += 1;
        time = millis();
      }
    } 
    {
      fill(255);
      text("Time alive: " + score, 10, 50);
    }
  } else if (!gameRunning && !menu) {
    if (playOnce) {
      dead.play();
      file.play();
      playOnce = false;
    }
    fill(255);
    text("GAME OVER", width / 2, height / 2);
  }
}

void beginContact(Contact cp) {
  land.play();
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  

  //checking for jump for the box
  if (o1.getClass() == Box.class && (o2.getClass() == Boundary.class || o2.getClass() == kBound.class)) {
    Box merp = (Box) o1;
    merp.canJump = true;
  } else if (o2.getClass() == Box.class && (o1.getClass() == Boundary.class || o1.getClass() == kBound.class)) {
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
  if (keyCode == ' ' && box.canJump) {
   jump.play(); 
  }
  box.setMove(keyCode, true);
}

void keyReleased() {
  box.setMove(keyCode, false);
}
