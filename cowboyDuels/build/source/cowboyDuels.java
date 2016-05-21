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
Revision Date: May 20, 2016
Description: The Cowboy Duels game is a 2 player game where cowboy characters scroll up and down the left and right
sides of the screen automatically the player can change the direction of their respective player and attempt to shoot the other cowboy.
The game's challenge comes from timing and firing your shot at the correct moment because if you have already shot will not gain another bullet until
your opponent shoots and vice versa. The game also has difficulty settings which will determine the speed of the bullet making  aiming easier or harder.
*/

//import ddf.minim.*; // 3rd party audio library downloaded from processing via library wizard

Resource r = new Resource();
Cowboy left = new Cowboy(5, 300, 1, 'w', 's', 'e', "LEFT");
Cowboy right = new Cowboy(665, 300, 1, 'i', 'j', 'o', "RIGHT");
Bullet test = new Bullet();

public void setup() {
  
  r.load();
  r.bg.resize(800, 600);
  frameRate(10);
}


public void draw() {
  image(r.bg, 0, 0);
  left.move(r.leftCowBoy);
  left.input();
  right.move(r.rightCowBoy);
  right.input();
  test.fire(r.bullet);
}
class Bullet {
  private int x;
  private int y;
  private int speed = 2;

  // public Bullet(Cowboy c) {
  //
  // }


  public void fire(PImage[] b) {
    for (int i = 0; i < b.length; i++) {
      image(b[i], 0, 0);
    }
  }
}
class Cowboy {
  private int x;
  private int y;
  private int speed = 1;
  private int up;
  private int down;
  int barrelX; // will be mapped to the barrel coordinates of the cowboy character's gun to ensure the bullet fires from the right place
  int barrelY;
  private char downButton;
  private char upButton;
  private String whatSide; // stores what side the cowboy is on for the class


  public Cowboy(int startX, int startY, int scrollSpeed, char u, char d, char f, String side) { // take chars for up and down cowboy motion and fire button and speed and start coordinates take string to see what side the cowboy is on
    this.x = startX; // set starting coordinates of the cowboy unique to any particular instance of the class using this
    this.y = startY;
    this.downButton = d; // map up and down buttons to specified characters in the constructor
    this.upButton = u;
    this.whatSide = side;
    this.up = 0 - scrollSpeed;
    this.down = scrollSpeed;
  }


  public void move(PImage cowboy) { // take cowboy image as input will also needs to run in a loop
    cowboy.resize(256/2, 336/2);
    image(cowboy, this.x, this.y);
    this.y += this.speed;
    if (this.whatSide.equals("LEFT")) {
      this.barrelX = this.x + 105;
      this.barrelY = this.y + 109;
    }
    if (this.whatSide.equals("RIGHT")) {
      this.barrelX = this.x + 23;
      this.barrelY = this.y + 109;
    }
    changeDir();
  }

  public void input() { // function will be called in a loop taking of user input to the cowboy characters
    if (keyPressed) {
      if (key == this.upButton) {
        this.speed = this.up;
      }
      if (key == this.downButton && !(this.y + 157 >= 550)) {
        this.speed = this.down;
      }
    }
  }


  private void changeDir() { // function will invert direction of cowboy to keeping it off screen
    if (this.y + 157 >= 575) {
      this.speed = -1;
    }
    if (this.y + 30 <= 25) {
      this.speed = 1;
    }
  }
}
class Resource {
  public PImage bg; // background image
  public PImage leftCowBoy;
  public PImage rightCowBoy;
  public PImage[] bullet = new PImage[20]; // bullet is a gif animation that will be stored in PImage array with each position being filled by a frame of the gif
  public int gameState; // will determine what menu the game should be at


  public void load() { // loads assets for the game called once in setup
    bg = loadImage("assets/img/testBg.png");
    leftCowBoy = loadImage("assets/img/leftCowboy.png");
    rightCowBoy = loadImage("assets/img/rightCowboy.png");
    for (int i = 0; i < 20; i++) {
      bullet[i] = loadImage("assets/img/bullet/frame_" + i + ".gif"); // use a for loop and i variable to iterate through bullet array to set a frame of the gif animation to each position
    }
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
