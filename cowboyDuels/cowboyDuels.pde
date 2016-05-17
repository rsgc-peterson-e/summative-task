Resource r = new Resource();
Cowboy left = new Cowboy();
int gameState = 0;

void setup() {
  size(800, 600);
  r.load();
  r.bg.resize(800, 600);
}


void draw() {
  image(r.bg, 0, 0);
  left.move(r.leftCowBoy);
  left.input();
}