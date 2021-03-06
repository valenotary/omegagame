class Boundary {
  float x, y, w, h;
  Body b;

  Boundary (float x, float y, float w, float h) {
    this.w = w;
    this.h = h;
    makeBody(new Vec2(x, y), w, h);
  }

  void makeBody(Vec2 center, float w, float h) {
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(center.x, center.y));
    b = box2d.createBody(bd);
    b.createFixture(sd, 1);
    b.setUserData(this);
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(b);
    fill(0);
    stroke(0);
    rectMode(CENTER);
    rect(pos.x, pos.y, w, h);
  }
}
