class Projectile {
  Body body;
  float r;

  color col;

  Projectile(float x, float y, float r) {
    this.r = r;
    makeProjectile(new Vec2(x, y), r);
  }

  void killBody() {
    box2d.destroyBody(body);
  }

  boolean done() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if (pos.y > height + r * 2) {
      killBody();
      return true;
    }
    return false;
  }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(a);
    fill(col);
    stroke(0);
    strokeWeight(1);
    ellipse(0, 0, r * 2, r * 2);
    popMatrix();
  }

  void makeProjectile(Vec2 center, float r) {
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.density = 2;

    BodyDef bd = new BodyDef();
    bd.type = BodyType.KINEMATIC;
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
    body.setUserData(this);

    body.setLinearVelocity(new Vec2(0, -20));
  }
}
