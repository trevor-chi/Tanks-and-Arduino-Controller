class PlayerBullet {
  // bullet variables
  int x;
  int y;
  int dx;
  int dy;
  int d;
  int speed;
  color c;

  // boolean variables
  boolean shouldRemove;

  // hitbox variables
  int left;
  int top;
  int right;
  int bottom;

  // image variables
  PImage bulletRight;
  PImage bulletLeft;
  PImage bulletDown;
  PImage bulletUp;
  PImage currentImage;

  // bullet constructor
  PlayerBullet(int aX, int aY, int dirX, int dirY, color aColor) {
    x = aX;
    y = aY;
    dx = dirX;
    dy = dirY;
    d = 15;
    speed = 8;
    c = aColor;

    left = x - d / 2;
    right = x + d / 2;
    top = y - d / 2;
    bottom = y + d / 2;

    bulletRight = loadImage("bulletGreenSilver_outline_4.png");
    bulletRight.resize(d + 10, d + 5);

    bulletLeft = loadImage("bulletGreenSilver_outline_2.png");
    bulletLeft.resize(d + 10, d + 5);

    bulletUp = loadImage("bulletGreenSilver_outline.png");
    bulletUp.resize(d + 5, d + 10);

    bulletDown = loadImage("bulletGreenSilver_outline_3.png");
    bulletDown.resize(d + 5, d + 10);

    // Set image based on bullet direction
    if (dx == 1 && dy == 0) {
      currentImage = bulletRight;
    } else if (dx == -1 && dy == 0) {
      currentImage = bulletLeft;
    } else if (dx == 0 && dy == -1) {
      currentImage = bulletUp;
    } else if (dx == 0 && dy == 1) {
      currentImage = bulletDown;
    } else {
      currentImage = bulletUp; // default fallback
    }
  }

  //////////////////////////////////
  // BULLET FUNCTION DEFINITIONS
  //////////////////////////////////

  // render a bullet
  void render() {
    image(currentImage, x, y);
  }

  // handles bullet movement
  void move() {
    x += dx * speed;
    y += dy * speed;

    // updating bullet hitboxes
    left = x - d / 2;
    right = x + d / 2;
    top = y - d / 2;
    bottom = y + d / 2;
  }

  // determines if this bullet should be removed from the game
  void checkRemove() {
    if (x > width) {
      shouldRemove = true;
    }
  }

  // handles bullet collisions with a down shooting enemy
  void collisionWithEnemy(Enemy anEnemy) {
    if (top <= anEnemy.bottom &&
      bottom >= anEnemy.top &&
      right >= anEnemy.left &&
      left <= anEnemy.right) {

      anEnemy.hitBullet = true;
      shouldRemove = true;
    }
  }

  // handles bullet collision with a wall
  void collisionWithWall(Wall aWall) {
    if (top <= aWall.bottom &&
      bottom >= aWall.top &&
      right >= aWall.left &&
      left <= aWall.right) {

      shouldRemove = true;
    }
  }
}
