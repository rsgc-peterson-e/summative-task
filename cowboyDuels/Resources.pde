class Resource {
  public PImage bg; // background image
  public PImage leftCowBoy;
  public PImage rightCowBoy;
  public PFont title;
  public PFont score;
  public int gameState = 1; // will determine what menu the game should be at
  public int leftScore = 0; // score variables for left and right players
  public int rightScore = 0;


  public void load() { // loads assets for the game called once in setup
    bg = loadImage("assets/img/testBg.png");
    leftCowBoy = loadImage("assets/img/leftCowboy.png");
    rightCowBoy = loadImage("assets/img/rightCowboy.png");
    title = createFont("assets/fonts/title.ttf", 32);
    score = createFont("assets/fonts/score.ttf", 28);
  }
}
