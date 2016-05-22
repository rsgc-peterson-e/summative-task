class Hitbox {
  public int x; // make ints public for easy access in hit detection
  public int y;
  public int w;
  public int h;


  public Hitbox() {/*Nothing to Construct*/}

  public void update(int bx, int by, int bw, int bh) { // take boxes x, y, width and height for assignment to variables with values unique to the particular object
    this.x = bx;
    this.y = by;
    this.w = bw;
    this.h = bh;
  }

  public void setPoint(int px, int py) { // save a collision point to the objecta as oppose to a full hitbox
    this.x = px;
    this.y = py;
  }
}
