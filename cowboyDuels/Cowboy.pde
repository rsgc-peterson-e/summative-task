class Cowboy {
  private int x;
  private int y;
  private int speed = 1;
  private int up;
  private int down;
  int barrelX; // will be mapped to the barrel coordinates of the cowboy character's gun to ensure the bullet fires from the right place
  int barrelY;
  int yOnFire; // will store the y coordinate of the barrel when the fire button was pressed so the bullet does not move upwards or downwards with the cowboy
  public int[] leftHitbox = new int[4];
  public int[] rightHitbox = new int[4];
  // HitBox leftHitbox = new HitBox();
  // HitBox rightHitbox = new HitBox();
  private char downButton;
  private char upButton;
  private char fireButton;
  String whatSide; // stores what side the cowboy is on for the class
  boolean bulletFired; // true if the fire button specified in constructor has been pressed
  PImage cowboy;


  public Cowboy(int startX, int startY, int scrollSpeed, char u, char d, char f, String side) { // take chars for up and down cowboy motion and fire button and speed and start coordinates take string to see what side the cowboy is on
    this.x = startX; // set starting coordinates of the cowboy unique to any particular instance of the class using this
    this.y = startY;
    this.downButton = d; // map up and down buttons to specified characters in the constructor
    this.upButton = u;
    this.fireButton = f;
    if (side.equals("LEFT")) {
      cowboy = loadImage("assets/img/leftCowboy.png");
    }
    if (side.equals("RIGHT")) {
      cowboy = loadImage("assets/img/rightCowboy.png");
    }
    this.whatSide = side;
    this.up = 0 - scrollSpeed;
    this.down = scrollSpeed;
  }


  public void move() { // take cowboy image as input will also needs to run in a loop
    cowboy.resize(256/2, 336/2);
    image(cowboy, this.x, this.y);
    rightHitbox[0] = this.x + 20; // index and update respective cowboy hitbox | x coordinate
    rightHitbox[1] = this.y + 27; // y coordinate
    rightHitbox[2] = cowboy.width - 45; // width
    rightHitbox[3] = cowboy.height - 35; // height
    leftHitbox[0] = this.x + 25;
    leftHitbox[1] = this.y + 27;
    leftHitbox[2] = cowboy.width - 45;
    leftHitbox[3] = cowboy.height - 35;
    this.y += this.speed;
    if (this.whatSide.equals("LEFT")) { // set barrel coordinates for barrel for instance of cowboy on the left side of the screen
      this.barrelX = this.x + 80;
      this.barrelY = this.y + 86;
    }
    if (this.whatSide.equals("RIGHT")) {
      this.barrelX = this.x;
      this.barrelY = this.y + 86;
    }
    fill(255, 0, 0, 60);
    if (this.whatSide.equals("LEFT")) {
      //leftHitbox.setBox(this.x + 25, this.y + 27, cowboy.width - 45, cowboy.height - 35);
      rect(this.x + 25, this.y + 27, cowboy.width - 45, cowboy.height - 35);
    }
    if (this.whatSide.equals("RIGHT")) {
      //rightHitbox.setBox(this.x + 20, this.y + 27, cowboy.width - 45, cowboy.height - 35);
      rect(this.x + 20, this.y + 27, cowboy.width - 45, cowboy.height - 35);
    }
    changeDir();
  }

  public void input() { // function will be called in a loop taking of user input to the cowboy characters
    if (keyPressed) {
      if (key == this.upButton && !(this.y + 30 <= 25)) {
        this.speed = this.up;
      }
      if (key == this.downButton && !(this.y + 157 >= 550)) {
        this.speed = this.down;
      }
      if (key == this.fireButton && !bulletFired) {
        this.bulletFired = true;
        this.yOnFire = this.barrelY;
      }
    }
  }


  private void changeDir() { // function will invert direction of cowboy to keeping it off screen
    if (this.y + 157 >= 575) {
      this.speed = this.up;
    }
    if (this.y + 30 <= 25) {
      this.speed = this.down;
    }
  }
}
