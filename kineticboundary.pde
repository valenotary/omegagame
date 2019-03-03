class kBound {
  float w;
  float h;
  Body b;

  kBound(float x, float y, float w, float h) {
    this.w = w;
    this.h = h;
    makeBody(new Vec2(x, y), w, h);
  }

  void killBody() {
    box2d.destroyBody(b);
  }

  void randomMove() {
    b.setLinearVelocity(new Vec2(random(-10, 10), random(-10, 10)));
  }

  boolean done() {
    Vec2 pos = box2d.getBodyPixelCoord(b);
    if (pos.y > height + w * h) {
      killBody();
      return true;
    }
    return false;
  }


  void makeBody(Vec2 center, float w, float h) {
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    BodyDef bd = new BodyDef();
    bd.type = BodyType.KINEMATIC;
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
