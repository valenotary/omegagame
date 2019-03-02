class Player {
  boolean[] states = new boolean[4];
  PVector pos;
  int d, v;
  float gravity = 1;
  float time;
  
  Player(int x, int y, int d, int v) {
   pos = new PVector(x, y);
   this.d = d;
   this.v = v;
   time = millis();
  }
  
  void display() {
    rect(pos.x, pos.y, d, d, d / 2);
  }
  
  void jump() {
    
  }
  
  void move() {
    pos.x = constrain(pos.x + v*(int(states[0]) - int(states[1])), d, width - d);
    if (states[2]) {
    } else {
      pos.y = constrain(pos.y + v*(gravity + int(states[3])), d, height - d);
    }
  }
  boolean setMove(int k, boolean b) {
    switch (k) {
    case 'W':
    case ' ':
    case UP:
      return states[2] = b;
 
    case 'S':
    case DOWN:
      return states[3] = b;
 
    case 'A':
    case LEFT:
      return states[1] = b;
 
    case 'D':
    case RIGHT:
      return states[0] = b;
      
      
 
    default:
      return b;
    }
  }
  
  float getX() {
    return pos.x;
  }
  
  float getY() {
   return pos.y; 
  }
}
