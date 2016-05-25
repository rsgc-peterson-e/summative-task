/*
Cowboy Duels
 Author: Ethan Peterson
 Revision Date: May 25, 2016
 Description: The Cowboy Duels game is a 2 player game where cowboy characters scroll up and down the left and right
 sides of the screen automatically the player can change the direction of their respective player and attempt to shoot the other cowboy.
 The game's challenge comes from timing and firing your shot at the correct moment because if you have already shot will not gain another bullet until
 your fired bullet leaves the screen or hits you enemy. The game also has difficulty settings which will determine the speed of the bullet making  aiming easier or harder.
 */

import ddf.minim.*; // 3rd party audio library downloaded from processing via library wizard

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


void setup() {
  left = new Cowboy(5, 300, 1, 'w', 's', 'e', "LEFT");
  right = new Cowboy(665, 300, 1, 'i', 'j', 'o', "RIGHT");
  leftBullet = new Bullet(left, 5);
  rightBullet = new Bullet(right, 5);
  size(800, 600);
  r.load();
  r.bg.resize(800, 600);
  background = minim.loadSnippet("assets/audio/background.mp3");
  hit = minim.loadSnippet("assets/audio/hit.mp3");
}


void draw() {
  image(r.bg, 0, 0);
  audio();
  drawGame(r.gameState);
}


void hud() { // will draw important info onscreen like score
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


boolean bulletInCowboy(int px, int py, int x, int y, int width, int height) { // take parameters for the bullet collision point being checked
  if (px >= x && px <= x+width && py >= y && py <= y+height) { // taken with influence from my OnClickListener class in my ISP
    return true;
  } else {
    return false;
  }
}

boolean mouseOverButton(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY < y + height) {
    return true; // return true if the mouse is within the specified rectangle
  } else { // return false if the mouse is not within the given rectangle
    return false;
  }
}

void collision(Hitbox[] h, Bullet b) { // bullet collision with cowboy's will be handled here
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


void audio() { // plays audio for the game and updates audio snippets by rewinding them after they have been played
  if (r.gameState == 1) { // play the audio below only if the game is being played
    background.play(); // loops the background audio
    if (!background.isPlaying()) {
      background.rewind();
    }
    if (!hit.isPlaying()) { // rewind the file when it is not playing so when a cowboy gets hit by a bullet the sound plays from the beginning
      hit.rewind();
    }
  }
}


void drawGame(int g) { // will take gamestate as param and run the corresponding the code
  if (g == -1) { // pause menu
  }
  if (g == 0) { // will draw start screen
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
    textFont(r.title);
    fill(255);
    textSize(64);
    text("Game Over", width/2 - textWidth("Game Over")/2, 100);
    image(r.leftCowBoy, 0, height/2 - r.leftCowBoy.height/2);
    image(r.rightCowBoy, 550, height/2 - r.rightCowBoy.height/2);
    text(r.leftScore, (width/2 - textWidth(Integer.toString(r.leftScore))/2) - 50, 585); // draw scores for both left and right cowboys
    text(r.rightScore, (width/2 - textWidth(Integer.toString(r.rightScore))/2) + 50, 585);
    text(left.winOrLose, 50, height/2.5 - textWidth(left.winOrLose)/2.5);
    text(right.winOrLose, 775 - textWidth(right.winOrLose), height/2.5 - textWidth(right.winOrLose)/2.5);
  }
}


void keyTyped() { // for testing between modes
  if (key == ' ') {
    r.gameState++;
  }
  if (key == 'h') {
    r.gameState--;
  }
}
