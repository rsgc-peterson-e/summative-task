class Cowboy {
  private int x;
  private int y;
  private int speed = 1;
  private int up;
  private int down;
  int barrelX; // will be mapped to the barrel coordinates of the cowboy character's gun to ensure the bullet fires from the right place
  int barrelY;
  private char downButton;
  private char upButton;
  private String whatSide; // stores what side the cowboy is on for the class


  public Cowboy(int startX, int startY, int scrollSpeed, char u, char d, String side) { // take chars for up and down cowboy motion and speed and start coordinates take string to see what side the cowboy is on
    this.x = startX; // set starting coordinates of the cowboy unique to any particular instance of the class using this
    this.y = startY;
    this.downButton = d; // map up and down buttons to specified characters in the constructor
    this.upButton = u;
    this.whatSide = side;
    this.up = 0 - scrollSpeed;
    this.down = scrollSpeed;
  }


  public void move(PImage cowboy) { // take cowboy image as input will also needs to run in a loop
    cowboy.resize(256/2, 336/2);
    image(cowboy, this.x, this.y);
    this.y += this.speed;
    if (this.whatSide.equals("LEFT")) {
      this.barrelX = this.x + 105;
      this.barrelY = this.y + 109;
    }
    if (this.whatSide.equals("RIGHT")) {
      this.barrelX = this.x + 23;
      this.barrelY = this.y + 109;
    }
    changeDir();
  }

  public void input() { // function will be called in a loop taking of user input to the cowboy characters
    if (keyPressed) {
      if (key == this.upButton) {
        this.speed = this.up;
      }
      if (key == this.downButton && !(this.y + 157 >= 550)) {
        this.speed = this.down;
      }
    }
  }


  private void changeDir() { // function will invert direction of cowboy to keeping it off screen
    if (this.y + 157 >= 575) {
      this.speed = -1;
    }
    if (this.y + 30 <= 25) {
      this.speed = 1;
    }
  }
}
