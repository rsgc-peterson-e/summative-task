class Bullet {
  int x;
  int y;
  private int speed;
  PImage bullet;
  Cowboy cowboy;
  public Hitbox[] points = new Hitbox[3];
  public Hitbox hitbox;

  public Bullet(Cowboy c, int bulletSpeed) {
    this.speed = bulletSpeed;
    this.cowboy = c; // assign cowboy object inputted into constructor to another cowboy object to be used throughout the program
    if (c.whatSide.equals("LEFT")) { // check what image to load depending on which side of the screen the cowboy is on
      this.bullet = loadImage("assets/img/left.png");
    }
    if (c.whatSide.equals("RIGHT")) {
      this.bullet = loadImage("assets/img/right.png");
    }
    // initialize Hitbox arrays
    for (int i = 0; i < points.length; i++) {
      points[i] = new Hitbox();
    }
    this.hitbox = new Hitbox();
  }


  public void fire() { // called in a loop where the bullet image is moved across screen
    if (!cowboy.bulletFired) {
      this.y = cowboy.barrelY;
      this.x = cowboy.barrelX;
    } else if (this.cowboy.bulletFired) {
      this.cowboy.yOnFire = this.y;
      if (this.cowboy.whatSide.equals("LEFT")) {
        points[0].setPoint(this.x + 50, this.y + 23);
        points[1].setPoint(this.x + 35, this.y + 18);
        points[2].setPoint(this.x + 35, this.y + 30);
        image(this.bullet, this.x, this.y);
        fill(255, 0, 0, 100);
        rect(this.x + 35, this.y + 15, this.bullet.width - 35, this.bullet.height - 35);
        this.hitbox.update(this.x + 35, this.y + 15, this.bullet.width - 35, this.bullet.height - 35);
        this.x += this.speed;
        if (this.x > 800) { // reset bullet to non fired state after it leaves the screen
          this.cowboy.bulletFired = false;
        }
      }
      if (this.cowboy.whatSide.equals("RIGHT")) {
        points[0].setPoint(this.x, this.y + 23);
        points[1].setPoint(this.x + 15, this.y + 18);
        points[2].setPoint(this.x + 15, this.y + 30);
        image(this.bullet, this.x, this.y);
        fill(255, 0, 0, 100);
        rect(this.x, this.y + 15, this.bullet.width - 35, this.bullet.height - 35);
        this.hitbox.update(this.x, this.y + 15, this.bullet.width - 35, this.bullet.height - 35);
        this.x -= this.speed;
        if (this.x < -50) {
          this.cowboy.bulletFired = false;
        }
      }
    }
  }
}