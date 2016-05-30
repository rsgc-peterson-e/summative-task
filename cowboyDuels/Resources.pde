class Resource {
  public PImage bg; // background image
  public PImage leftCowBoy;
  public PImage rightCowBoy;
  public PImage bullet;
  public PFont title;
  public PFont score;
  public int gameState = 0; // will determine what menu the game should be at
  public int leftScore = 0; // score variables for left and right players
  public int rightScore = 0;
  public int maxScore = 5;
  public int titleY = -30;
  public int opacity = 0; // opacity stores % for main menu animation having text fade in

  public void load() { // loads assets for the game called once in setup
    bg = loadImage("assets/img/testBg.png");
    leftCowBoy = loadImage("assets/img/leftCowboy.png");
    rightCowBoy = loadImage("assets/img/rightCowboy.png");
    title = createFont("assets/fonts/title.ttf", 32);
    score = createFont("assets/fonts/score.ttf", 64);
    bullet = loadImage("assets/img/bullet.png");
  }
}