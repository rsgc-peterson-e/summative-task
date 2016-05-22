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
Bullet[] leftAmmo = new Bullet[5];
Bullet[] rightAmmo = new Bullet[5];
int timesLeftFired = 0; // tracks the amount of time the left fire button has been pressed
int timesRightFired = 0;


void setup() {
  left = new Cowboy(5, 300, 1, 'w', 's', 'e', "LEFT");
  right = new Cowboy(665, 300, 1, 'i', 'j', 'o', "RIGHT");
  size(800, 600);
  r.load();
  r.bg.resize(800, 600);
  for (int i = 0; i < leftAmmo.length; i++) {
    leftAmmo[i] = new Bullet(left, 2);
    rightAmmo[i] = new Bullet(right, 2);
  }
}


void draw() {
  image(r.bg, 0, 0);
  left.move();
  left.input();
  right.move();
  right.input();
  leftAmmo[timesLeftFired].fire();
  rightAmmo[timesRightFired].fire();
}


// void keyTyped() { // runs when key is pressed and released
//   if (key == left.fireButton) {
//
//     timesLeftFired++;
//   }
//   if (key == right.fireButton) {
//     timesRightFired++;
//   }
// }
