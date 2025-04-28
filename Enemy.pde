class Enemy {
  // enemy variables
  int x;
  int y;
  int size;
  int speed;
  int lastShotTime;
  float startShooting;
  float startMoving;

  // enemy hitboxes
  int left;
  int right;
  int top;
  int bottom;

  // boolean variables
  boolean hitBullet;
  boolean isMovingLeft;
  boolean isMovingRight;
  boolean isCollidingWithWall;

  // holds the direction the enemy was moving when colliding with the wall.
  String wallCollisionDirection = "";

  // image variables
  PImage enemyImageDown;
  PImage enemyImageRight;
  PImage enemyImageLeft;
  PImage enemyImageUp;

  PImage enemyBarrelUp;
  PImage enemyBarrelLeft;

  // movement variables for random movement
  int moveTimer;
  int moveDuration;
  String currentDirection;

  // enemy constructor
  Enemy(int aX, int aY, int aSize, int aSpeed, boolean movingLeft, boolean movingRight) {
    x = aX;
    y = aY;
    size = aSize;
    speed = aSpeed;

    left = x - size / 2;
    right = x + size / 2;
    top = y - size / 2;
    bottom = y + size / 2;

    hitBullet = false;
    isMovingLeft = movingLeft;
    isMovingRight = movingRight;
    isCollidingWithWall = false;

    lastShotTime = millis();
    startShooting = random(650, 2000);
    startMoving = random(0, 500);

    moveTimer = millis();
    moveDuration = int(random(1500, 2500));
    currentDirection = pickRandomDirection();

    enemyImageDown = loadImage("tankRed_outline.png");
    enemyImageDown.resize(size + 10, size + 10);

    enemyImageRight = loadImage("tankRed_outline_3.png");
    enemyImageRight.resize(size + 10, size + 10);

    enemyImageLeft = loadImage("tankRed_outline_2.png");
    enemyImageLeft.resize(size + 10, size + 10);

    enemyImageUp = loadImage("tankRed_outline_4.png");
    enemyImageUp.resize(size + 10, size + 10);

    enemyBarrelUp = loadImage("barrelRed_outline.png");
    enemyBarrelUp.resize(size - 20, size - 5);

    enemyBarrelLeft = loadImage("barrelRed_outline_2.png");
    enemyBarrelLeft.resize(size - 5, size - 20);
  }

  // renders an enemy
  void render() {
    if (currentDirection.equals("down")) {
      image(enemyImageDown, x, y);
      image(enemyBarrelUp, x, y + 20);
    } else if (currentDirection.equals("right")) {
      image(enemyImageRight, x, y);
      image(enemyBarrelLeft, x + 20, y);
    } else if (currentDirection.equals("left")) {
      image(enemyImageLeft, x, y);
      image(enemyBarrelLeft, x - 20, y);
    } else if (currentDirection.equals("up")) {
      image(enemyImageUp, x, y);
      image(enemyBarrelUp, x, y - 20);
    }
  }

  // handles the enemy's patrol movement
  void move() {
    // If the move duration has elapsed, choose a new random direction:
    if (millis() - moveTimer >= moveDuration) {
      currentDirection = pickRandomDirection();
      moveTimer = millis();
      moveDuration = int(random(1000, 2000));

      // check wall collision
      if (isCollidingWithWall) {
        if ((wallCollisionDirection.equals("right") && !currentDirection.equals("right")) ||
          (wallCollisionDirection.equals("left") && !currentDirection.equals("left")) ||
          (wallCollisionDirection.equals("down") && !currentDirection.equals("down")) ||
          (wallCollisionDirection.equals("up") && !currentDirection.equals("up"))) {
          isCollidingWithWall = false;
          wallCollisionDirection = "";
        }
      }
    }

      // determine if the enemy can move
      boolean canMove = true;
      if (isCollidingWithWall) {
        if ((wallCollisionDirection.equals("right") && currentDirection.equals("right")) ||
          (wallCollisionDirection.equals("left") && currentDirection.equals("left")) ||
          (wallCollisionDirection.equals("up") && currentDirection.equals("up")) ||
          (wallCollisionDirection.equals("down") && currentDirection.equals("down"))) {
          canMove = false;
        }
      }

      // Move in the current direction if allowed.
      if (canMove) {
        if (currentDirection.equals("left") && x > 0 + size / 2) {
          x -= speed;
        } else if (currentDirection.equals("right") && x < width - size / 2) {
          x += speed;
        } else if (currentDirection.equals("up") && y > 0 + size / 2) {
          y -= speed;
        } else if (currentDirection.equals("down") && y < height - size / 2) {
          y += speed;
        }
      }

    // Update enemy hitboxes
    left = x - size / 2;
    right = x + size / 2;
    top = y - size / 2;
    bottom = y + size / 2;
  }

  // picks a random direction for this enemy to move in
  String pickRandomDirection() {
    int dir = int(random(4));
    if (dir == 0) return "left";
    else if (dir == 1) return "right";
    else if (dir == 2) return "up";
    else return "down";
  }

  // detects if the enemy has collided with a wall and stops movement if so
  // also stores which side the collision happened on
  void wallCollision(Wall aWall) {
    // collision with the left side of a wall
    if (top <= aWall.bottom &&
      bottom >= aWall.top &&
      right > aWall.left &&
      left <= aWall.left) {
      isCollidingWithWall = true;
      wallCollisionDirection = "right";  // the enemy was moving right when it collided
      x = aWall.left - size / 2;
    }

    // collision with the right side of a wall
    if (top <= aWall.bottom &&
      bottom >= aWall.top &&
      left < aWall.right &&
      right >= aWall.right) {
      isCollidingWithWall = true;
      wallCollisionDirection = "left";   // the enemy was moving left when it collided
      x = aWall.right + size / 2;
    }

    // collision with the top of a wall
    if (left <= aWall.right &&
      right >= aWall.left &&
      bottom > aWall.top &&
      top <= aWall.top) {
      isCollidingWithWall = true;
      wallCollisionDirection = "down";   // the enemy was moving down when it collided
      y = aWall.top - size / 2;
    }

    // collision with the bottom of a wall
    if (left <= aWall.right &&
      right >= aWall.left &&
      top < aWall.bottom &&
      bottom >= aWall.bottom) {
      isCollidingWithWall = true;
      wallCollisionDirection = "up";     // the enemy was moving up when it collided
      y = aWall.bottom + size / 2;
    }
  }
}
