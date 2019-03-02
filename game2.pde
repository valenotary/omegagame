import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;
Box box;
ArrayList<Boundary> boundaries;

void setup() {
  size(500, 500);
  background(255);
  smooth();
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  //box2d.setGravity(0, -10);
  
  box = new Box(50, 50, 10, 10);
  boundaries = new ArrayList<Boundary>();
  
  boundaries.add(new Boundary(width/4,height-5,width/2-50,10));
  boundaries.add(new Boundary(3*width/4,height-50,width/2-50,10));
}

void draw() {
  background(255);
  box2d.step();
  box.move();
  box.display();
  for (Boundary wall: boundaries) {
   wall.display(); 
  }
}

void keyPressed() {
  box.setMove(keyCode, true);
  
}

void keyReleased() {
 box.setMove(keyCode, false); 
}
