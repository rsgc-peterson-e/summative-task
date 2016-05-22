class HitBox { // simple class combining hitbox coordinates into one object to access the coordinates for hit detection
  int x;
  int y;
  int w;
  int h;

  void setBox(int hx, int hy, int hw, int hh) { // takes hitbox's coordinates so they can be used for hit detection later
    this.x = hx;
    this.y = hy;
    this.w = hw;
    this.h = hh;
  }
}
