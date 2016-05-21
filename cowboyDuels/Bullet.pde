class Bullet {
  int x;
  int y;
  private int speed = 2;
  private PImage bullet;
  Cowboy cowboy;

  public Bullet(Cowboy c) {
    this.cowboy = c; // assign cowboy object inputted into constructor to another cowboy object to be used throughout the program
    if (c.whatSide.equals("LEFT")) { // check what image to load depending on which side of the screen the cowboy is on
      this.bullet = loadImage("assets/img/left.png");
    }
    if (c.whatSide.equals("RIGHT")) {
      this.bullet = loadImage("assets/img/right.png");
    }
  }


  public void fire() { // called in a loop where the bullet image is moved across screen
    this.x = cowboy.barrelX;
    this.y = cowboy.barrelY;
    image(this.bullet, this.x, this.y);
  }
}
