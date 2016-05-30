/*
Cowboy Duels
 Author: Ethan Peterson
 Revision Date: May 27, 2016
 Description: The Cowboy Duels game is a 2 player game where cowboy characters scroll up and down the left and right
 sides of the screen automatically the player can change the direction of their respective player and attempt to shoot the other cowboy.
 The game's challenge comes from timing and firing your shot at the correct moment because if you have already shot will not gain another bullet until
 your fired bullet leaves the screen or hits you enemy.
 
 Right Player Controls:
 press "i" to move up
 press "j" to move down
 press "o" to shoot
 
 Left Player Controls:
 press "w" to move up
 press "s" to move down
 press "e" to shoot
 */

import ddf.minim.*; // 3rd party audio library downloaded from processing via library wizard

Resource r = new Resource();
Cowboy left;
Cowboy right;
Bullet rightBullet;
Bullet leftBullet;
Minim minim = new Minim(this);
// define audio snippets for both sides so I have file to play for each cowboy if they are shooting at the same time
AudioSnippet leftHit; // wounded sound
AudioSnippet rightHit;
AudioSnippet gameOver; // sound that plays at the game over screen
AudioSnippet bulletCollision; // plays an explosion sound when the bullets collide
AudioPlayer background; // western 8 bit music

void setup() {
  left = new Cowboy(5, 300, 1, 'w', 's', 'e', "LEFT", this); // pass this keyword when specifying PApplet for cowboy class
  right = new Cowboy(665, 300, 1, 'i', 'j', 'o', "RIGHT", this); 
  leftBullet = new Bullet(left, 5);
  rightBullet = new Bullet(right, 5);
  size(800, 600);
  r.load();
  r.bg.resize(800, 600);
  background = minim.loadFile("assets/audio/background.mp3");
  leftHit = minim.loadSnippet("assets/audio/hit.mp3");
  rightHit = minim.loadSnippet("assets/audio/hit.mp3");
  gameOver = minim.loadSnippet("assets/audio/gameOver.mp3");
  bulletCollision = minim.loadSnippet("assets/audio/boom.mp3");
}


void draw() { // calls all the essential functions in my program in a loop
  image(r.bg, 0, 0);
  audio();
  resetMain();
  drawGame(r.gameState);
  left.update(r); // feed instance of resource class with correct variables vals to cowboy class
  right.update(r);
}


void keyTyped() { // for testing between modes
  if (r.gameState == -1 && key == ENTER) {
    r.gameState = 0;
    background.pause();
  } else if (r.gameState == -1 && key == ' ') {
    key = 'g'; // set key to different char to prevent other conditionals with key == ' ' from running
    r.gameState = 1;
  }
  if (r.gameState == 1) {
    if (key == ' ') {
      r.gameState = -1;
      left.audioCleanUp();
      right.audioCleanUp();
      background.pause();
    }
  }
  if (r.gameState == 2) { // if the game is over
    if (key == ' ') {
      restartGame();
      if (gameOver.isPlaying()) { // pause gameOver sound if someone passes game over screen before it finishes
        gameOver.pause();
      }
      r.gameState = 1;
    }
    if (key == ENTER) {
      if (gameOver.isPlaying()) {
        gameOver.pause();
      }
      r.gameState = 0;
    }
  }
  if (r.gameState == 0) {
    if (key == ' ') {
      r.gameState = 1;
    }
  }
  right.input();
  left.input();
  if (r.gameState == 1 && !background.isPlaying()) {
    background.rewind();
    background.play();
  }
}


void restartGame() { // cleans up objects and gets them ready for a new game after the user decides to play another game
  left.cleanUp();
  right.cleanUp();
  r.leftScore = 0;
  r.rightScore = 0;
  gameOver.rewind();
}


void resetMain() { // will reset variables for main menu animation
  if (r.gameState != 0) {
    r.titleY = -30; // reset animation variables so the main menu animateion will play everytime the main menu is accessed
    r.opacity = 0;
  }
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


void collision(Hitbox[] h, Bullet b) { // bullet collision with cowboy's will be handled here
  for (int i = 0; i < h.length; i++) { // go through hitbox array checking for collisions with any of the boxes
    for (int j = 0; j < b.points.length; j++) { // create second for loop that only runs the length of the points array to prevent Array out of bounds
      if (bulletInCowboy(b.points[j].x, b.points[j].y, h[i].x, h[i].y, h[i].w, h[i].h)) { // check each hitbox in the array to see if one is in contact with the bullet
        if (b.cowboy.whatSide.equals("LEFT") && b.cowboy.bulletFired) { // check what side the bullet is from and if it has been fired
          r.leftScore++; // increase the players score by 1 if they hit the other
          b.cowboy.bulletFired = false; // set bulletFired to false so the player can reload and shoot again
          println("LEFT SCORE: " + r.leftScore);
          rightHit.play(); // play a sound when a player is hit
          if (r.leftScore == r.maxScore) {
            leftBullet.cowboy.winOrLose = "Winner";
            r.gameState = 2; // switch to game over screen once max score is reached by either left or right cowboy
            println("LEFT: " + leftBullet.cowboy.winOrLose);
          }
        } else if (b.cowboy.whatSide.equals("RIGHT") && b.cowboy.bulletFired) {
          r.rightScore++;
          b.cowboy.bulletFired = false;
          println("RIGHT SCORE: " + r.rightScore);
          leftHit.play();
          if (r.rightScore == r.maxScore) {
            rightBullet.cowboy.winOrLose = "Winner";
            r.gameState = 2;
            println("RIGHT: " + rightBullet.cowboy.winOrLose);
          }
        }
      }
    }
  }
}


void bulletCollision(Bullet a, Bullet b) { // take two bullets as parameters and test if they touch one another while fired
  if (a.cowboy.bulletFired && b.cowboy.bulletFired) { // only run the function if two bullets have been fired to collide with one another in the first place
    // check for collisions with each bullet
    for (int i = 0; i < a.points.length; i++) {
      if (bulletInCowboy(a.points[i].x, a.points[i].y, b.hitbox.x, b.hitbox.y, b.hitbox.w, b.hitbox.h) || bulletInCowboy(b.points[i].x, b.points[i].y, a.hitbox.x, a.hitbox.y, a.hitbox.w, a.hitbox.h)) { // checks if any of bullet a's collision points went inside the hitbox rectangle of bullet b
        // put bullets back to their non fired state as they intersected
        a.cowboy.bulletFired = false;
        b.cowboy.bulletFired = false;
        bulletCollision.play();
      } else {
        bulletCollision.rewind();
      }
    }
  }
}


void audio() { // plays audio for the game and updates audio snippets by rewinding them after they have been played
  if (r.gameState == 1) { // play the audio below only if the game is being played
    if (!leftHit.isPlaying()) {
      leftHit.rewind();
    }
    if (!rightHit.isPlaying()) {
      rightHit.rewind();
    }
    background.play();
  }
  if (r.gameState != 2) {
    gameOver.rewind();
  }
}


void drawGame(int g) { // will take gamestate as param and run the corresponding the code
  if (g == -1) { // pause menu
    hud();
    image(left.cowboy, left.x, left.y);
    image(right.cowboy, right.x, right.y);
    if (left.bulletFired) { // draw bullet where it was onscreen when the game was paused as long it has been fired
      image(leftBullet.bullet, leftBullet.x, leftBullet.y);
    }
    if (right.bulletFired) {
      image(rightBullet.bullet, rightBullet.x, rightBullet.y);
    }
    fill(208, 100);
    noStroke();
    rect(0, 0, width, height);
    stroke(5);
    fill(255);
    textFont(r.title);
    textSize(64);
    text("Paused", width/2 - textWidth("Paused")/2, 125);
    textSize(32);
    text("Press SPACE to Continue", width/2 - textWidth("Press SPACE to Continue")/2, 200);
    text("Press ENTER to Exit to Main Menu", width/2 - textWidth("Press ENTER to Exit to Main Menu")/2, 250);
  }
  if (g == 0) { // will draw start screen
    textFont(r.title);
    textSize(64);
    if (r.titleY < 125) { // steadily increase titles y coordinate until its in the right pos
      r.titleY++;
    }
    fill(255);
    text("Cowboy Duels", width/2 - textWidth("Cowboy Duels")/2, r.titleY);
    image(r.leftCowBoy, 0, height/2 - r.leftCowBoy.height/2);
    image(r.rightCowBoy, 550, height/2 - r.rightCowBoy.height/2);
    textSize(32);
    if (r.opacity < 255) { // have text telling user to play by pressing space fade in
      r.opacity += 2;
    }
    fill(255, r.opacity);
    text("Press SPACE to Play", width/2 - textWidth("Press SPACE to Play")/2 + 5, 250);
  }
  if (g == 1) { // will draw game
    left.move();
    //left.input();
    right.move();
    //right.input();
    leftBullet.fire();
    rightBullet.fire();
    collision(right.hitbox, leftBullet);
    collision(left.hitbox, rightBullet);
    bulletCollision(leftBullet, rightBullet);
    hud();
    if (!background.isPlaying()) {
      background.rewind();
      background.play();
    }
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
    println(r.leftScore);
    println(r.rightScore);
    text(left.winOrLose, 50, height/2.5 - textWidth(left.winOrLose)/2.5);
    text(right.winOrLose, 775 - textWidth(right.winOrLose), height/2.5 - textWidth(right.winOrLose)/2.2);
    textSize(20);
    text("Press SPACE to Play Again", width/2 - textWidth("Press SPACE to Play Again")/2, 225);
    text("Press ENTER to Return to Main Menu", width/2 - textWidth("Press ENTER to Return to Main Menu")/2, 300);
  }
}