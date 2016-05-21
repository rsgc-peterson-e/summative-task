class Cowboy {
  private int x;
  private int y;
  private int speed = 1;
  private char downButton;
  private char upButton;


  public Cowboy(int startX, int startY, char u, char d) { // take chars for up and down cowboy motion and speed and start coordinates
    this.x = startX; // set starting coordinates of the cowboy unique to any particular instance of the class using this
    this.y = startY;
    this.downButton = d; // map up and down buttons to specified characters in the constructor
    this.upButton = u;
  }
  

  public void move(PImage cowboy) { // take cowboy image as input
    cowboy.resize(256/2, 336/2);
    image(cowboy, this.x, this.y);
    this.y += this.speed;
    //ellipse(this.x + 60, this.y + 30, 10, 10);
    changeDir();
  }

  public void input() { // function will be called in a loop taking of user input to the cowboy characters
    if (keyPressed) {
      if (key == this.upButton) {
        this.speed = -1;
      }
      if (key == this.downButton && !(this.y + 157 >= 550)) {
        this.speed = 1;
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