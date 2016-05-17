class Cowboy {
  int x;
  int y;
  private PImage character;
  private int speed = -1;
  
  public Cowboy(int startX, int startY, int scrollSpeed, PImage img) {
    this.x = startX;
    this.y = startY;
    this.character = img;
    this.speed = scrollSpeed;
  }
  
  public Cowboy() {
    this.x = 5;
    this.y = 400;
  }
  
  public void move(PImage img) { // take cowboy image as input
    img.resize(256/2, 336/2);
    image(img, this.x, this.y);
    this.y += this.speed;
  }
  
  public void input() { // function will be called in a loop taking of user input to the cowboy characters
    
  }
}