class EnemyBullet {
  // bullet variables
  int x;
  int y;
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
  
  // direction variables
  String direction;
  
  // image variables
  PImage bulletUp;
  PImage bulletDown;
  PImage bulletLeft;
  PImage bulletRight;

  // bullet constructor
  EnemyBullet(int aX, int aY, color aColor, String aDirection) {
    x = aX;
    y = aY;
    d = 15;
    speed = 8;
    c = aColor;

    left = x - d / 2;
    right = x + d / 2;
    top = y - d / 2;
    bottom = y + d / 2;
    
    direction = aDirection;
    
    shouldRemove = false;
    
    bulletUp = loadImage("bulletRedSilver_outline_4.png");
    bulletUp.resize(d + 5, d + 10);
    
    bulletDown = loadImage("bulletRedSilver_outline_2.png");
    bulletDown.resize(d + 5, d + 10);
    
    bulletRight = loadImage("bulletRedSilver_outline_3.png");
    bulletRight.resize(d + 10, d + 5);
    
    bulletLeft = loadImage("bulletRedSilver_outline.png");
    bulletLeft.resize(d + 10, d + 5);
  }

  //////////////////////////////////
  // BULLET FUNCTION DEFINITIONS
  //////////////////////////////////

  // render a bullet
  void render() {
    if (direction.equals("up")) {
      image(bulletUp, x, y);
    }
    else if (direction.equals("down")) {
      image(bulletDown, x, y);
    }
    else if (direction.equals("right")) {
      image(bulletRight, x, y);
    }
    else if (direction.equals("left")) {
      image(bulletLeft, x, y);
    }
  }

  // handles bullet movement
  void move() {
    if (direction.equals("up")) {
      y -= speed;
    }
    else if (direction.equals("down")) {
      y += speed;
    }
    else if (direction.equals("left")) {
      x -= speed;
    }
    else if (direction.equals("right")) {
      x += speed;
    }
    
    // updating bullet hitboxes
    left = x - d / 2;
    right = x + d / 2;
    top = y - d / 2;
    bottom = y + d / 2;
  }

  // determines if this bullet should be removed from the game
  void checkRemove() {
    if (y > height) {
      shouldRemove = true;
    }
  }

  // handles bullet collisions with the player
  void collisionWithPlayer(Player aPlayer) {
    if (top <= aPlayer.bottom &&
      bottom >= aPlayer.top &&
      right >= aPlayer.left &&
      left <= aPlayer.right) {

      aPlayer.hitEnemyBullet = true;
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
