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

void setup() {
  left = new Cowboy(5, 300, 1, 'w', 's', 'e', "LEFT");
  right = new Cowboy(665, 300, 1, 'i', 'j', 'o', "RIGHT");
  leftBullet = new Bullet(left, 2);
  rightBullet = new Bullet(right, 2);
  size(800, 600);
  r.load();
  r.bg.resize(800, 600);
}


void draw() {
  image(r.bg, 0, 0);
  left.move();
  left.input();
  right.move();
  right.input();
  leftBullet.fire();
  rightBullet.fire();
  collision(right.rightHitbox, leftBullet);
  collision(left.leftHitbox, rightBullet);
}


boolean bulletInCowboy(int px, int py, int x, int y, int width, int height)  { // take parameters for the bullet collision point being checked
  if (px >= x && px <= x+width && py >= y && py <= y+height) { // taken with influence from my OnClickListener class in my ISP
    return true;
  } else {
    return false;
  }
}

void collision(Hitbox[] h, Bullet b) { // bullet collision with cowboy's will be handled here
  for (int i = 0; i < h.length; i++) { // go through hitbox array checking for collisions with any of the boxes
    for (int j = 0; j < b.points.length; j++) { // create second for loop that only runs the length of the points array to prevent Array out of bounds
      if (bulletInCowboy(b.points[j].x, b.points[j].y, h[i].x, h[i].y, h[i].width, h[i].height)) { // check each hitbox in the array to see if one is in contact with the bullet
        if (b.cowboy.whatSide.equals("LEFT") && b.cowboy.bulletFired) { // check what side the bullet is from and if it has been fired
          r.leftScore++; // increase the players score by 1 if they hit the other
          b.cowboy.bulletFired = false; // set bulletFired to false so the player can reload and shoot again
          println("LEFT SCORE: " + r.leftScore);
        } else if (b.cowboy.whatSide.equals("RIGHT") && b.cowboy.bulletFired) {
          r.rightScore++;
          b.cowboy.bulletFired = false;
          println("RIGHT SCORE: " + r.rightScore);
        }
      }
    }
  }
}
