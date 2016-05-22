class Hitbox {
  public int x; // make ints public for easy access in hit detection
  public int y;
  public int width;
  public int height;

  public Hitbox() {/*Nothing to Construct*/}

  public void update(int bx, int by, int bw, int bh) { // take boxes x, y, width and height for assignment to variables with values unique to the particular object
    this.x = bx;
    this.y = by;
    this.width = bw;
    this.height = bh;
  }
}
