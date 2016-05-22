import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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
Revision Date: May 22, 2016
Description: The Cowboy Duels game is a 2 player game where cowboy characters scroll up and down the left and right
sides of the screen automatically the player can change the direction of their respective player and attempt to shoot the other cowboy.
The game's challenge comes from timing and firing your shot at the correct moment because if you have already shot will not gain another bullet until
your fired bullet leaves the screen or hits you enemy. The game also has difficulty settings which will determine the speed of the bullet making  aiming easier or harder.
*/

//import ddf.minim.*; // 3rd party audio library downloaded from processing via library wizard

Resource r = new Resource();
Cowboy left;
Cowboy right;
Bullet rightBullet;
Bullet leftBullet;
int leftBulletX;
int leftBulletY;

public void setup() {
  left = new Cowboy(5, 300, 1, 'w', 's', 'e', "LEFT");
  right = new Cowboy(665, 300, 1, 'i', 'j', 'o', "RIGHT");
  leftBullet = new Bullet(left, 2);
  rightBullet = new Bullet(right, 2);
  
  r.load();
  r.bg.resize(800, 600);
}


public void draw() {
  image(r.bg, 0, 0);
  left.move();
  left.input();
  right.move();
  right.input();
  leftBullet.fire();
  rightBullet.fire();
  println(bulletInCowboy(leftBullet.x, leftBullet.y, right.rightHitbox[0], right.rightHitbox[1], right.rightHitbox[2], right.rightHitbox[3]));
}

public boolean bulletInCowboy(int px, int py, int x, int y, int width, int height)  { // take parameters for the bullet collision point being checked
  if (px >= x && px <= x+width && py >= y && py <= y+height) { // taken with influence from my OnClickListener class in my ISP
    return true;
  } else {
    return false;
  }
}

public void collision() { // bullet collision with cowboy's will be handled here
  
}
class Bullet {
  int x;
  int y;
  private int speed;
  private PImage bullet;
  Cowboy cowboy;

  public Bullet(Cowboy c, int bulletSpeed) {
    this.speed = bulletSpeed;
    this.cowboy = c; // assign cowboy object inputted into constructor to another cowboy object to be used throughout the program
    if (c.whatSide.equals("LEFT")) { // check what image to load depending on which side of the screen the cowboy is on
      this.bullet = loadImage("assets/img/left.png");
    }
    if (c.whatSide.equals("RIGHT")) {
      this.bullet = loadImage("assets/img/right.png");
    }
  }


  public void fire() { // called in a loop where the bullet image is moved across screen
    if (!cowboy.bulletFired) {
      this.y = cowboy.barrelY;
      this.x = cowboy.barrelX;
      //image(this.bullet, this.x, this.y);
    } else if (this.cowboy.bulletFired) {
      this.cowboy.yOnFire = this.y;
      if (this.cowboy.whatSide.equals("LEFT")) {
        this.x += this.speed;
        if (this.x > 800) {
          this.cowboy.bulletFired = false;
        }
      }
      if (this.cowboy.whatSide.equals("RIGHT")) {
        this.x -= this.speed;
        if (this.x < -50) {
          this.cowboy.bulletFired = false;
        }
      }
      image(this.bullet, this.x, this.cowboy.yOnFire);
      fill(255);
      ellipse(this.x, this.cowboy.yOnFire, 5, 5);
    }
  }

  // private boolean bulletInCowboy(String side) {
  //   if (side.equals("RIGHT") && this.x >= cowboy.rightHitbox[0] && this.x <= cowboy.rightHitbox[0] + cowboy.rightHitbox[2] && this.cowboy.yOnFire >= cowboy.rightHitbox[1]
  //   && this.cowboy.yOnFire <= cowboy.rightHitbox[1] + cowboy.rightHitbox[3]) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
}
class Cowboy {
  private int x;
  private int y;
  private int speed = 1;
  private int up;
  private int down;
  int barrelX; // will be mapped to the barrel coordinates of the cowboy character's gun to ensure the bullet fires from the right place
  int barrelY;
  int yOnFire; // will store the y coordinate of the barrel when the fire button was pressed so the bullet does not move upwards or downwards with the cowboy
  public int[] leftHitbox = new int[4];
  public int[] rightHitbox = new int[4];
  // HitBox leftHitbox = new HitBox();
  // HitBox rightHitbox = new HitBox();
  private char downButton;
  private char upButton;
  private char fireButton;
  String whatSide; // stores what side the cowboy is on for the class
  boolean bulletFired; // true if the fire button specified in constructor has been pressed
  PImage cowboy;


  public Cowboy(int startX, int startY, int scrollSpeed, char u, char d, char f, String side) { // take chars for up and down cowboy motion and fire button and speed and start coordinates take string to see what side the cowboy is on
    this.x = startX; // set starting coordinates of the cowboy unique to any particular instance of the class using this
    this.y = startY;
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
  }


  public void move() { // take cowboy image as input will also needs to run in a loop
    cowboy.resize(256/2, 336/2);
    image(cowboy, this.x, this.y);
    rightHitbox[0] = this.x + 20; // index and update respective cowboy hitbox | x coordinate
    rightHitbox[1] = this.y + 27; // y coordinate
    rightHitbox[2] = cowboy.width - 45; // width
    rightHitbox[3] = cowboy.height - 35; // height
    leftHitbox[0] = this.x + 25;
    leftHitbox[1] = this.y + 27;
    leftHitbox[2] = cowboy.width - 45;
    leftHitbox[3] = cowboy.height - 35;
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
      //leftHitbox.setBox(this.x + 25, this.y + 27, cowboy.width - 45, cowboy.height - 35);
      rect(this.x + 45, this.y + 27, cowboy.width - 95, cowboy.height - 130); // hat hitbox
      rect(this.x + 20, this.y + 45, cowboy.width - 50, cowboy.height - 135); // hat tip hitbox
      rect(this.x + 35, this.y + 77, cowboy.width - 80, cowboy.height - 115); // main  torso hitbox
      rect(this.x + 87, this.y + 130, cowboy.width - 155, cowboy.height - 140); // right leg
      rect(this.x + 60, this.y + 130, cowboy.width - 155, cowboy.height - 140); // left leg
    }
    if (this.whatSide.equals("RIGHT")) {
      //rightHitbox.setBox(this.x + 20, this.y + 27, cowboy.width - 45, cowboy.height - 35);
      // rect(this.x + 20, this.y + 27, cowboy.width - 45, cowboy.height - 35);
      rect(this.x + 50, this.y + 27, cowboy.width - 95, cowboy.height - 130); // hat hitbox
      rect(this.x + 25, this.y + 45, cowboy.width - 50, cowboy.height - 135); // hat tip hitbox
      rect(this.x + 45, this.y + 77, cowboy.width - 80, cowboy.height - 115); // main  torso hitbox
      rect(this.x + 67, this.y + 130, cowboy.width - 155, cowboy.height - 140); // right leg
      rect(this.x + 95, this.y + 130, cowboy.width - 155, cowboy.height - 140); // left leg
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
}
class Resource {
  public PImage bg; // background image
  public PImage leftCowBoy;
  public PImage rightCowBoy;
  public int gameState = 1; // will determine what menu the game should be at
  public int leftScore; // score variables for left and right players
  public int rightScore;


  public void load() { // loads assets for the game called once in setup
    bg = loadImage("assets/img/testBg.png");
    leftCowBoy = loadImage("assets/img/leftCowboy.png");
    rightCowBoy = loadImage("assets/img/rightCowboy.png");
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
