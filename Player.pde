class Player {
  // player variables
  int x;
  int y;
  int size;
  int speed;
  int health;
  color c;

  // movement booleans
  boolean isMovingLeft;
  boolean isMovingRight;
  boolean isMovingUp;
  boolean isMovingDown;

  // represents if the player has hit an enemy bullet
  boolean hitEnemyBullet;

  // represents the last direction that the player was facing
  String lastDirection;

  // player hitboxes
  int left;
  int right;
  int bottom;
  int top;

  // player images
  PImage facingLeft;
  PImage facingRight;
  PImage facingUp;
  PImage facingDown;
  PImage barrelUp;
  PImage barrelLeft;
  PImage tracksUp;
  PImage tracksLeft;

  // Player Constructor
  Player(int aX, int aY, int aSize, int aSpeed, color aColor) {
    x = aX;
    y = aY;
    size = aSize;
    speed = aSpeed;
    c = aColor;

    isMovingLeft = false;
    isMovingRight = false;
    isMovingUp = false;
    isMovingDown = false;

    hitEnemyBullet = false;

    left = x - size / 2;
    right = x + size / 2;
    top = y - size / 2;
    bottom = y + size / 2;

    health = 3;
    
    lastDirection = "right";

    facingUp = loadImage("tankGreenoutline.png");
    facingUp.resize(size + 10, size + 10);

    facingDown = loadImage("tankGreenoutline_3.png");
    facingDown.resize(size + 10, size + 10);

    facingLeft = loadImage("tankGreenoutline_2.png");
    facingLeft.resize(size + 10, size + 10);

    facingRight = loadImage("tankGreenoutline_4.png");
    facingRight.resize(size + 10, size + 10);

    barrelUp = loadImage("barrelGreen_outline.png");
    barrelUp.resize(size - 20, size - 5);

    barrelLeft = loadImage("barrelGreen_outline_2.png");
    barrelLeft.resize(size - 5, size - 20);

    tracksUp = loadImage("tracksLarge.png");
    tracksUp.resize(size, size);

    tracksLeft = loadImage("tracksLarge_Left.png");
    tracksLeft.resize(size, size);
  }

  ///////////////////////////////
  // PLAYER FUNCTION DEFINITIONS
  ///////////////////////////////

  // renders the player
  void render() {
    if (isMovingUp) {
      image(facingUp, x, y);
      image(barrelUp, x, y - 20);
      image(tracksUp, x, y + 30);
    } else if (isMovingDown) {
      image(facingDown, x, y);
      image(barrelUp, x, y + 20);
      image(tracksUp, x, y - 30);
    } else if (isMovingLeft) {
      image(facingLeft, x, y);
      image(barrelLeft, x - 20, y);
      image(tracksLeft, x + 30, y);
    } else if (isMovingRight) {
      image(facingRight, x, y);
      image(barrelLeft, x + 20, y);
      image(tracksLeft, x - 30, y);
    } else {
      if (lastDirection == "up") {
        image(facingUp, x, y);
        image(barrelUp, x, y - 20);
      } else if (lastDirection == "down") {
        image(facingDown, x, y);
        image(barrelUp, x, y + 20);
      } else if (lastDirection == "left") {
        image(facingLeft, x, y);
        image(barrelLeft, x - 20, y);
      } else if (lastDirection == "right") {
        image(facingRight, x, y);
        image(barrelLeft, x + 20, y);
      }
    }
  }

  // handles player movement
  void move() {
    // updating player hitboxes
    left = x - size / 2;
    right = x + size / 2;
    top = y - size / 2;
    bottom = y + size / 2;

    // if the player isnt at the boundaries of the screen then allow movement
    if (isMovingLeft == true && x > 0 + size / 2) {
      x -= speed;
      lastDirection = "left";
    }
    if (isMovingRight == true && x < width - size / 2) {
      x += speed;
      lastDirection = "right";
    }
    if (isMovingUp == true && y > 0 + size / 2) {
      y -= speed;
      lastDirection = "up";
    }
    if (isMovingDown == true && y < height - size / 2) {
      y += speed;
      lastDirection = "down";
    }
  }

  // detects if the player has collided with a wall and stops movement if so
  void wallCollision(Wall aWall) {
    /* if the player collides with the left side of a wall,
     then stop the player from moving right */
    if (top <= aWall.bottom &&
      bottom >= aWall.top &&
      right > aWall.left &&
      left <= aWall.left) {

      isMovingRight = false;
      x = aWall.left - size / 2;
    }

    /* if the player collides with the right side of a platform,
     then stop the player from moving left */
    if (top <= aWall.bottom &&
      bottom >= aWall.top &&
      left < aWall.right &&
      right >= aWall.right) {

      isMovingLeft = false;
      x = aWall.right + size / 2;
    }

    /* if the player collides with the top of a platform,
     then stop the player from moving down */
    if (left <= aWall.right &&
      right >= aWall.left &&
      bottom > aWall.top &&
      top <= aWall.top) {

      isMovingDown = false;
      y = aWall.top - size / 2;
    }

    /* if the player collides with the bottom of
     a floating platform then make the player not move up */
    if (left <= aWall.right &&
      right >= aWall.left &&
      top < aWall.bottom &&
      bottom >= aWall.bottom) {

      isMovingUp = false;
      y = aWall.bottom + size / 2;
    }
  }

  // update the players health if the player is hit by a bullet
  void hasHitBullet() {
    if (hitEnemyBullet) {
      health--;
      hitEnemyBullet = false;
    }
  }
}
