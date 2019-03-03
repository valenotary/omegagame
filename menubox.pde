class Button {
  float x, y, w, h;
  
  Button(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void display() {
    rect(x, y, w, h, w / 2);
  }
  
 boolean contains(float ox, float oy) {
  return ox >= x && ox <= x + w && oy >= y && oy <= y + h;
 }
}
