class Bullet {
  int x;
  int y;
  private int speed;
  private PImage bullet;
  Cowboy cowboy;
  public Hitbox[] cPoints = new Hitbox[3];

  public Bullet(Cowboy c, int bulletSpeed) {
    this.speed = bulletSpeed;
    this.cowboy = c; // assign cowboy object inputted into constructor to another cowboy object to be used throughout the program
    if (c.whatSide.equals("LEFT")) { // check what image to load depending on which side of the screen the cowboy is on
      this.bullet = loadImage("assets/img/left.png");
    }
    if (c.whatSide.equals("RIGHT")) {
      this.bullet = loadImage("assets/img/right.png");
    }
  }


  public void fire() { // called in a loop where the bullet image is moved across screen
    if (!cowboy.bulletFired) {
      this.y = cowboy.barrelY;
      this.x = cowboy.barrelX;
      image(this.bullet, this.x, this.y);
      fill(255);
      if (this.cowboy.whatSide.equals("LEFT")) {
        ellipse(this.x + 50, this.y + 23, 5, 5);
        ellipse(this.x + 35, this.y + 18, 5, 5);
        ellipse(this.x + 35, this.y + 30, 5, 5);
      } else {
        ellipse(this.x, this.y + 23, 5, 5);
        ellipse(this.x + 15, this.y + 18, 5, 5);
        ellipse(this.x + 15, this.y + 30, 5, 5);
      }
    } else if (this.cowboy.bulletFired) {
      this.cowboy.yOnFire = this.y;
      if (this.cowboy.whatSide.equals("LEFT")) {
        this.x += this.speed;
        if (this.x > 800) {
          this.cowboy.bulletFired = false;
        }
      }
      if (this.cowboy.whatSide.equals("RIGHT")) {
        this.x -= this.speed;
        if (this.x < -50) {
          this.cowboy.bulletFired = false;
        }
      }
      image(this.bullet, this.x, this.cowboy.yOnFire);
      fill(255);
      ellipse(this.x + 25, this.cowboy.yOnFire, 5, 5);
    }
  }
}
