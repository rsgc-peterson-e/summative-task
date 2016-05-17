class Cowboy {
  private int x;
  private int y;
  private int speed = -1;
  private boolean whatSide;
  
  public Cowboy(int startX, int startY, int scrollSpeed, boolean whatKeys) {
    this.x = startX;
    this.y = startY;
    this.speed = scrollSpeed;
    this.whatSide = whatKeys;
  }
  
  public Cowboy() { // true is right side false is left side
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
      if (key == 'a') {
        this.speed = 1;
      }
    }
  }
}