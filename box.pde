class Box {
  Body body;
  float w, h;
  boolean moveRight, moveLeft, moveStop, canJump;
  Box() {
    w = h = 2;
  }
  Box(float x, float y, float w, float h) {
    this.w = w;
    this.h = h;
    makeBody(new Vec2(x, y), w, h);
  }

  void killBody() {
    box2d.destroyBody(body);
  }

  boolean done() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if (pos.y > height + w * h) {
      killBody();
      return true;
    }
    return false;
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    fill(175);
    stroke(0);
    rect(0, 0, w, h, w + h / 2);
    popMatrix();
  }

  void move() {
    Vec2 vel = body.getLinearVelocity();
    float desiredVel = 0;
    if (moveRight) desiredVel = min (vel.x + 0.2f, 10.0f);
    if (moveLeft) desiredVel = max(vel.x - 0.2f, -10.0f);
    if (!moveRight && !moveLeft) desiredVel = vel.x * 0.98f;
    float velChange = desiredVel - vel.x;
    float impulse = body.getMass() * velChange;
    body.applyLinearImpulse(new Vec2(impulse, 0), body.getWorldCenter(), true);
  }

  boolean setMove(int k, boolean b) {
    switch (k) {
    case 'A':
    case LEFT:
      return moveLeft = b;

    case 'D':
    case RIGHT:
      return moveRight = b;

    case ' ':
    case 'W':
    case UP:
      if (canJump) {
        float impulse = body.getMass() * 20;
        body.applyLinearImpulse(new Vec2(0f, impulse), body.getWorldCenter(), true);
      }



    default:
      return b;
    }
  }

  void makeBody(Vec2 center, float w, float h) {
    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    fd.density = 1;
    fd.friction = 0.1;
    fd.restitution = .2;

    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    bd.fixedRotation = true;

    body = box2d.createBody(bd);
    body.createFixture(fd);
    body.setUserData(this);

    //DELETE THIS IF ANYTHING IS FUCKED UP
    //sd.setAsBox(0, -box2dH);
    //fd.isSensor = true;
    //foot.setUserData(this);
  }
}
