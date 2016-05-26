import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class cowboyDuels extends PApplet {

/*
Cowboy Duels
 Author: Ethan Peterson
 Revision Date: May 25, 2016
 Description: The Cowboy Duels game is a 2 player game where cowboy characters scroll up and down the left and right
 sides of the screen automatically the player can change the direction of their respective player and attempt to shoot the other cowboy.
 The game's challenge comes from timing and firing your shot at the correct moment because if you have already shot will not gain another bullet until
 your fired bullet leaves the screen or hits you enemy. The game also has difficulty settings which will determine the speed of the bullet making  aiming easier or harder.
 */

 // 3rd party audio library downloaded from processing via library wizard

Resource r = new Resource();
Cowboy left;
Cowboy right;
Bullet rightBullet;
Bullet leftBullet;
int leftBulletX;
int leftBulletY;
Minim minim = new Minim(this);
AudioSnippet background; // background western 8 bit music
AudioSnippet hit; // wounded sound
AudioSnippet shot; // gun fire sound
AudioSnippet gameOver; // sound that plays at the game over screen


public void setup() {
  left = new Cowboy(5, 300, 1, 'w', 's', 'e', "LEFT");
  right = new Cowboy(665, 300, 1, 'i', 'j', 'o', "RIGHT");
  leftBullet = new Bullet(left, 5);
  rightBullet = new Bullet(right, 5);
  
  r.load();
  r.bg.resize(800, 600);
  background = minim.loadSnippet("assets/audio/background.mp3");
  hit = minim.loadSnippet("assets/audio/hit.mp3");
  gameOver = minim.loadSnippet("assets/audio/gameOver.mp3");
}


public void draw() {
  image(r.bg, 0, 0);
  audio();
  drawGame(r.gameState);
}


public void keyTyped() { // for testing between modes
  if (r.gameState == 2) { // if the game is over
    if (key == ' ') {
      restartGame();
      r.gameState = 1;
    }
    if (key == ENTER) {
      gameOver.pause();
      r.gameState = 0;
    }
  }
}

public void restartGame() { // cleans up objects and gets them ready for a new game after the user decides to play another game
  left.cleanUp();
  right.cleanUp();
  r.leftScore = 0;
  r.rightScore = 0;
  gameOver.rewind();
}

public void hud() { // will draw important info onscreen like score
  textFont(r.score);
  fill(255);
  text(r.leftScore, (width/2 - textWidth(Integer.toString(r.leftScore))/2) - 50, 585); // draw scores for both left and right cowboys
  text(r.rightScore, (width/2 - textWidth(Integer.toString(r.rightScore))/2) + 50, 585);
  if (!left.bulletFired) {
    image(r.bullet, 100, 560);
  }
  if (!right.bulletFired) {
    image(r.bullet, 650, 560);
  }
}


public boolean bulletInCowboy(int px, int py, int x, int y, int width, int height) { // take parameters for the bullet collision point being checked
  if (px >= x && px <= x+width && py >= y && py <= y+height) { // taken with influence from my OnClickListener class in my ISP
    return true;
  } else {
    return false;
  }
}


public void collision(Hitbox[] h, Bullet b) { // bullet collision with cowboy's will be handled here
  for (int i = 0; i < h.length; i++) { // go through hitbox array checking for collisions with any of the boxes
    for (int j = 0; j < b.points.length; j++) { // create second for loop that only runs the length of the points array to prevent Array out of bounds
      if (bulletInCowboy(b.points[j].x, b.points[j].y, h[i].x, h[i].y, h[i].w, h[i].h)) { // check each hitbox in the array to see if one is in contact with the bullet
        if (b.cowboy.whatSide.equals("LEFT") && b.cowboy.bulletFired) { // check what side the bullet is from and if it has been fired
          r.leftScore++; // increase the players score by 1 if they hit the other
          b.cowboy.bulletFired = false; // set bulletFired to false so the player can reload and shoot again
          println("LEFT SCORE: " + r.leftScore);
          hit.play(); // play a sound when a player is hit
          if (r.leftScore == r.maxScore) {
            b.cowboy.winOrLose = "Winner";
            r.gameState = 2; // switch to game over screen once max score is reached by either left or right cowboy
            println("LEFT: " + b.cowboy.winOrLose);
          }
        } else if (b.cowboy.whatSide.equals("RIGHT") && b.cowboy.bulletFired) {
          r.rightScore++;
          b.cowboy.bulletFired = false;
          println("RIGHT SCORE: " + r.rightScore);
          hit.play();
          if (r.leftScore == r.maxScore) {
            b.cowboy.winOrLose = "Winner";
            r.gameState = 2;
            println("RIGHT: " + b.cowboy.winOrLose);
          }
        }
      }
    }
  }
}


public void audio() { // plays audio for the game and updates audio snippets by rewinding them after they have been played
  if (r.gameState == 1) { // play the audio below only if the game is being played
    background.play(); // loops the background audio
    if (!background.isPlaying()) {
      background.rewind();
    }
    if (!hit.isPlaying()) { // rewind the file when it is not playing so when a cowboy gets hit by a bullet the sound plays from the beginning
      hit.rewind();
    }
    if (r.gameState != 2) {
      gameOver.rewind();
    }
  }
}


public void drawGame(int g) { // will take gamestate as param and run the corresponding the code
  if (g == -1) { // pause menu
  }
  if (g == 0) { // will draw start screen
    textFont(r.title);
    textSize(64);
    text("Cowboy Duels", width/2 - textWidth("Cowboy Duels")/2, 75);
  }
  if (g == 1) { // will draw game
    left.move();
    left.input();
    right.move();
    right.input();
    leftBullet.fire();
    rightBullet.fire();
    collision(right.hitbox, leftBullet);
    collision(left.hitbox, rightBullet);
    hud();
  }
  if (g == 2) { // game over screen
    background.pause();
    gameOver.play();
    textFont(r.title);
    fill(255);
    textSize(64);
    text("Game Over", width/2 - textWidth("Game Over")/2, 100);
    image(r.leftCowBoy, 0, height/2 - r.leftCowBoy.height/2);
    image(r.rightCowBoy, 550, height/2 - r.rightCowBoy.height/2);
    text(r.leftScore, (width/2 - textWidth(Integer.toString(r.leftScore))/2) - 50, 585); // draw scores for both left and right cowboys
    text(r.rightScore, (width/2 - textWidth(Integer.toString(r.rightScore))/2) + 50, 585);
    text(left.winOrLose, 50, height/2.5f - textWidth(left.winOrLose)/2.5f);
    text(right.winOrLose, 775 - textWidth(right.winOrLose), height/2.5f - textWidth(right.winOrLose)/2.2f);
    textSize(20);
    text("Press SPACE to Play Again", width/2 - textWidth("Press SPACE to Play Again")/2, 225);
    text("Press ENTER to Return to Main Menu", width/2 - textWidth("Press ENTER to Return to Main Menu")/2, 300);
  }
}
class Bullet {
  int x;
  int y;
  private int speed;
  private PImage bullet;
  Cowboy cowboy;
  public Hitbox[] points = new Hitbox[3];

  public Bullet(Cowboy c, int bulletSpeed) {
    this.speed = bulletSpeed;
    this.cowboy = c; // assign cowboy object inputted into constructor to another cowboy object to be used throughout the program
    if (c.whatSide.equals("LEFT")) { // check what image to load depending on which side of the screen the cowboy is on
      this.bullet = loadImage("assets/img/left.png");
    }
    if (c.whatSide.equals("RIGHT")) {
      this.bullet = loadImage("assets/img/right.png");
    }
    // initialize Hitbox arrays
    for (int i = 0; i < points.length; i++) {
      points[i] = new Hitbox();
    }
  }


  public void fire() { // called in a loop where the bullet image is moved across screen
    if (!cowboy.bulletFired) {
      this.y = cowboy.barrelY;
      this.x = cowboy.barrelX;
    } else if (this.cowboy.bulletFired) {
      this.cowboy.yOnFire = this.y;
      if (this.cowboy.whatSide.equals("LEFT")) {
        points[0].setPoint(this.x + 50, this.y + 23);
        points[1].setPoint(this.x + 35, this.y + 18);
        points[2].setPoint(this.x + 35, this.y + 30);
        image(this.bullet, this.x, this.y);
        this.x += this.speed;
        if (this.x > 800) {
          this.cowboy.bulletFired = false;
        }
      }
      if (this.cowboy.whatSide.equals("RIGHT")) {
        points[0].setPoint(this.x, this.y + 23);
        points[1].setPoint(this.x + 15, this.y + 18);
        points[2].setPoint(this.x + 15, this.y + 30);
        image(this.bullet, this.x, this.y);
        this.x -= this.speed;
        if (this.x < -50) {
          this.cowboy.bulletFired = false;
        }
      }
    }
  }
}
class Cowboy {
  private int x;
  private int y;
  private int speed = 1;
  private int up;
  private int down;
  public int maxScore = 10;
  private int startingX;
  private int startingY;
  int barrelX; // will be mapped to the barrel coordinates of the cowboy character's gun to ensure the bullet fires from the right place
  int barrelY;
  int yOnFire; // will store the y coordinate of the barrel when the fire button was pressed so the bullet does not move upwards or downwards with the cowboy
  public Hitbox[] hitbox = new Hitbox[5];
  private char downButton;
  private char upButton;
  private char fireButton;
  String whatSide; // stores what side the cowboy is on for the class
  boolean bulletFired; // true if the fire button specified in constructor has been pressed
  String winOrLose = "Loser"; // will have whether the cowboy has won or lost at the end of the game stays at loser originally and is change iif the particular cowboy is the winner
  PImage cowboy;


  public Cowboy(int startX, int startY, int scrollSpeed, char u, char d, char f, String side) { // take chars for up and down cowboy motion and fire button and speed and start coordinates take string to see what side the cowboy is on
    this.x = startX; // set starting coordinates of the cowboy unique to any particular instance of the class using this
    this.y = startY;
    this.startingX = startX;
    this.startingY = startY;
    this.downButton = d; // map up and down buttons to specified characters in the constructor
    this.upButton = u;
    this.fireButton = f;
    if (side.equals("LEFT")) {
      cowboy = loadImage("assets/img/leftCowboy.png");
    }
    if (side.equals("RIGHT")) {
      cowboy = loadImage("assets/img/rightCowboy.png");
    }
    this.whatSide = side;
    this.up = 0 - scrollSpeed;
    this.down = scrollSpeed;
    for (int i = 0; i < hitbox.length; i++) { // for loop to construct array of Hitbox objects
      this.hitbox[i] = new Hitbox();
    }
  }


  public void move() { // take cowboy image as input will also needs to run in a loop
    this.cowboy.resize(256/2, 336/2);
    image(cowboy, this.x, this.y);
    this.y += this.speed;
    if (this.whatSide.equals("LEFT")) { // set barrel coordinates for barrel for instance of cowboy on the left side of the screen
      this.barrelX = this.x + 80;
      this.barrelY = this.y + 86;
    }
    if (this.whatSide.equals("RIGHT")) {
      this.barrelX = this.x;
      this.barrelY = this.y + 86;
    }
    fill(255, 0, 0, 60);
    if (this.whatSide.equals("LEFT")) {
      this.hitbox[0].update(this.x + 45, this.y + 27, this.cowboy.width - 95, this.cowboy.height - 130); // index hit box coordinates into unique objects in the array
      this.hitbox[1].update(this.x + 20, this.y + 45, this.cowboy.width - 50, this.cowboy.height - 135);
      this.hitbox[2].update(this.x + 35, this.y + 77, this.cowboy.width - 80, this.cowboy.height - 115);
      this.hitbox[3].update(this.x + 60, this.y + 130, 27, cowboy.height - 140);
      this.hitbox[4].update(this.x + 33, this.y + 130, 27, cowboy.height - 140);
    }
    if (this.whatSide.equals("RIGHT")) {
      this.hitbox[0].update(this.x + 50, this.y + 27, this.cowboy.width - 95, this.cowboy.height - 130);
      this.hitbox[1].update(this.x + 25, this.y + 45, this.cowboy.width - 50, this.cowboy.height - 135);
      this.hitbox[2].update(this.x + 45, this.y + 77, this.cowboy.width - 80, this.cowboy.height - 115);
      this.hitbox[3].update(this.x + 40, this.y + 130, 27, cowboy.height - 140);
      this.hitbox[4].update(this.x + 69, this.y + 130, 27, cowboy.height - 140);
    }
    changeDir();
  }

  public void input() { // function will be called in a loop taking of user input to the cowboy characters
    if (keyPressed) {
      if (key == this.upButton && !(this.y + 30 <= 25)) {
        this.speed = this.up;
      }
      if (key == this.downButton && !(this.y + 157 >= 550)) {
        this.speed = this.down;
      }
      if (key == this.fireButton && !bulletFired) {
        this.bulletFired = true;
        this.yOnFire = this.barrelY;
      }
    }
  }


  private void changeDir() { // function will invert direction of cowboy to keeping it off screen
    if (this.y + 157 >= 575) {
      this.speed = this.up;
    }
    if (this.y + 30 <= 25) {
      this.speed = this.down;
    }
  }


  public void cleanUp() {
    this.x = this.startingX;
    this.y = this.startingY;
    this.bulletFired = false;
  }
}
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
class Resource {
  public PImage bg; // background image
  public PImage leftCowBoy;
  public PImage rightCowBoy;
  public PImage bullet;
  public PFont title;
  public PFont score;
  public int gameState = 1; // will determine what menu the game should be at
  public int leftScore = 0; // score variables for left and right players
  public int rightScore = 0;
  public int maxScore = 2;
  public boolean titleIn; // true if game title is finished animating in start menu


  public void load() { // loads assets for the game called once in setup
    bg = loadImage("assets/img/testBg.png");
    leftCowBoy = loadImage("assets/img/leftCowboy.png");
    rightCowBoy = loadImage("assets/img/rightCowboy.png");
    title = createFont("assets/fonts/title.ttf", 32);
    score = createFont("assets/fonts/score.ttf", 64);
    bullet = loadImage("assets/img/bullet.png");
  }
}
  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "cowboyDuels" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
