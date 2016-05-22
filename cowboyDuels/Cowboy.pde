class Cowboy {
  private int x;
  private int y;
  private int speed = 1;
  private int up;
  private int down;
  int barrelX; // will be mapped to the barrel coordinates of the cowboy character's gun to ensure the bullet fires from the right place
  int barrelY;
  int yOnFire; // will store the y coordinate of the barrel when the fire button was pressed so the bullet does not move upwards or downwards with the cowboy
  public Hitbox[] hitbox = new Hitbox[5];
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
    for (int i = 0; i < hitbox.length; i++) { // for loop to construct array of Hitbox objects
      this.hitbox[i] = new Hitbox();
    }
  }


  public void move() { // take cowboy image as input will also needs to run in a loop
    this.cowboy.resize(256/2, 336/2);
    image(cowboy, this.x, this.y);
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
      this.hitbox[0].update(this.x + 45, this.y + 27, this.cowboy.width - 95, this.cowboy.height - 130); // index hit box coordinates into unique objects in the array
      this.hitbox[1].update(this.x + 20, this.y + 45, this.cowboy.width - 50, this.cowboy.height - 135);
      this.hitbox[2].update(this.x + 35, this.y + 77, this.cowboy.width - 80, this.cowboy.height - 115);
      this.hitbox[3].update(this.x + 87, this.y + 130, this.cowboy.width - 155, this.cowboy.height - 140);
      this.hitbox[4].update(this.x + 60, this.y + 130, this.cowboy.width - 155, this.cowboy.height - 140);
      rect(this.x + 45, this.y + 27, cowboy.width - 95, cowboy.height - 130); // hat hitbox
      rect(this.x + 20, this.y + 45, cowboy.width - 50, cowboy.height - 135); // hat tip hitbox
      rect(this.x + 35, this.y + 77, cowboy.width - 80, cowboy.height - 115); // main  torso hitbox
      rect(this.x + 87, this.y + 130, cowboy.width - 155, cowboy.height - 140); // right leg
      rect(this.x + 60, this.y + 130, cowboy.width - 155, cowboy.height - 140); // left leg
    }
    if (this.whatSide.equals("RIGHT")) {
      this.hitbox[0].update(this.x + 50, this.y + 27, this.cowboy.width - 95, this.cowboy.height - 130);
      this.hitbox[1].update(this.x + 25, this.y + 45, this.cowboy.width - 50, this.cowboy.height - 135);
      this.hitbox[2].update(this.x + 45, this.y + 77, this.cowboy.width - 80, this.cowboy.height - 115);
      // this.hitbox[3].update(this.x + 67, this.y + 130, this.cowboy.width - 155, this.cowboy.height - 140);
      // this.hitbox[4].update(this.x + 95, this.y + 130, this.cowboy.width - 155, this.cowboy.height - 140);
      rect(this.x + 50, this.y + 27, cowboy.width - 95, cowboy.height - 130); // hat hitbox
      rect(this.x + 25, this.y + 45, cowboy.width - 50, cowboy.height - 135); // hat tip hitbox
      rect(this.x + 45, this.y + 77, cowboy.width - 80, cowboy.height - 115); // main  torso hitbox
      // rect(this.x + 67, this.y + 130, cowboy.width - 155, cowboy.height - 140); // right leg
      // rect(this.x + 95, this.y + 130, cowboy.width - 155, cowboy.height - 140); // left leg
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
