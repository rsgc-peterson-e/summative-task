class Resource {
  public PImage bg; // background image
  public PImage leftCowBoy;
  public PImage rightCowBoy;
  public PImage bullet[]; // bullet is a gif animation that will be stored in PImage array with each position being filled by a frame of the gif
  public int gameState; // will determine what menu the game should be at


  public void load() { // loads assets for the game called once in setup
    bg = loadImage("assets/img/testBg.png");
    leftCowBoy = loadImage("assets/img/leftCowboy.png");
    rightCowBoy = loadImage("assets/img/rightCowboy.png");
    for (int i = 0, i < 20; i++) {

    }
  }
}
