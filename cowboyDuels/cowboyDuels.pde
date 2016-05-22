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
  println(bulletInCowboy(leftBullet.x, leftBullet.y, right.rightHitbox[0], right.rightHitbox[1], right.rightHitbox[2], right.rightHitbox[3]));
}

boolean bulletInCowboy(int px, int py, int x, int y, int width, int height)  { // take parameters for the bullet collision point being checked
  if (px >= x && px <= x+width && py >= y && py <= y+height) { // taken with influence from my OnClickListener class in my ISP
    return true;
  } else {
    return false;
  }
}

void mouseClicked() {
}
