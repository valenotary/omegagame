PFont font;
int score;
int time;
Player player;

void setup() {
  size(600, 600);
  background(255);
  font = createFont("font/8bit_wonder/8-BIT WONDER.TTF", 16);
  textFont(font);
  score = 0;
  time = millis();
  player = new Player(width / 2, height / 2, 10, 4);
}

void draw() {
  background(255);
  fill(0);
  if (millis() > time + 1000) {
    score += 1;
    time = millis();
    print(time);
  }
  String merp = "Current time alive: " + score;
  text(merp, 0, 50);
  player.move();
  player.display();
}

void keyPressed() {
 //if (key == 'a') {
 //  player.move('a'); 
 //}
 player.setMove(keyCode, true);
}

void keyReleased() {
  if (keyCode != 'W')
  player.setMove(keyCode, false);
}
