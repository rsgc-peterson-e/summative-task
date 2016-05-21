class Cowboy {
  private int x;
  private int y;
  private int speed = -1;
  
  public Cowboy(int startX, int startY, int scrollSpeed, char u, char d) { // take chars for up and down cowboy motion and speed and start coordinates
    this.x = startX;
    this.y = startY;
    this.speed = scrollSpeed;
  }
  
  public Cowboy() {
    this.x = 5;
    this.y = 400;
  }
  
  public void move(PImage cowboy) { // take cowboy image as input
    cowboy.resize(256/2, 336/2);
    image(cowboy, this.x, this.y);
    this.y += this.speed;
  }
  
  public void input() { // function will be called in a loop taking of user input to the cowboy characters
    if (keyPressed) {
      if (key == 'w') {
        this.speed = -1;  
      }
      if (key == 's') {
        this.speed = 1;
      }
    }
  }
}