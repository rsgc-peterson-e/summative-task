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
Bullet test;

void setup() {
  test = new Bullet(left);
  size(800, 600);
  r.load();
  r.bg.resize(800, 600);
}


void draw() {
  image(r.bg, 0, 0);
  left.move(r.leftCowBoy);
  left.input();
  right.move(r.rightCowBoy);
  right.input();
  test.fire();
}
