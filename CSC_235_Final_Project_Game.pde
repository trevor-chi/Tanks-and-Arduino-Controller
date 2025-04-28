import processing.serial.*;

// tanks game by Trevor Childers

// global variables

// serial variables to pass info from arduino into processing
Serial port;    // create an object from Serial class
String portRead;     // data received from the serial port
int prevState;  // this state is used to decide when to tell arduino to change the neopixel colors

// player object
Player player;

// wall object
Wall wallOne;
Wall wallTwo;
Wall wallThree;
Wall wallFour;
Wall wallFive;
Wall wallSix;
Wall wallSeven;
Wall wallEight;

// enemy objects
Enemy enemyBottomRight;
Enemy enemyMiddleRight;
Enemy enemyTopRight;
Enemy enemyTopMiddle;
Enemy enemyTopLeft;
Enemy enemyLeftMiddle;

// player health objects
PlayerHealth playerHealthOne = new PlayerHealth(150, 740, 10, 50);
PlayerHealth playerHealthTwo = new PlayerHealth(165, 740, 10, 50);
PlayerHealth playerHealthThree = new PlayerHealth(180, 740, 10, 50);

// image variables for background images
PImage sand;
PImage dirt;
PImage title;
PImage win;
PImage death;

// enemy lists
ArrayList<Enemy> enemyList = new ArrayList<Enemy>();

// player bullet array list
ArrayList<PlayerBullet> playerBulletList = new ArrayList<PlayerBullet>();

// enemy bullet lists
ArrayList<EnemyBullet> enemyBullet = new ArrayList<EnemyBullet>();

// wall list
ArrayList<Wall> wallList = new ArrayList<Wall>();

// list of the players health objects
ArrayList<PlayerHealth> playerHealthList = new ArrayList<PlayerHealth>();

// interval var for shooting
int startTime = millis();
int startTimeTwo = millis();
int interval = 2000;
int intervalTwo = 2100;

// state variables to run the state machine
int state = 0;

// setup
void setup() {
  size(1000, 800);
  rectMode(CENTER);
  imageMode(CENTER);
  port = new Serial(this, "/dev/cu.usbmodem101", 9600);  // port to pass info from arduino into this sketch
  portRead = port.readStringUntil('\n'); // read from the serial port and the delimeter is the new line character
  prevState = -1;

  // initializing the player, enemy, wall, and obstacle variables
  player = new Player(100, 600, 30, 3, color(0, 255, 0));

  enemyBottomRight = new Enemy(900, 732, 30, 3, true, false);
  enemyMiddleRight = new Enemy(915, 350, 30, 3, false, true);
  enemyTopRight = new Enemy(950, 75, 30, 3, true, false);
  enemyTopMiddle = new Enemy(500, 50, 30, 3, false, true);
  enemyTopLeft = new Enemy(50, 50, 30, 3, true, false);
  enemyLeftMiddle = new Enemy(50, 370, 30, 3, true, false);

  wallOne = new Wall(300, 35, 50, 400, color(0, 0, 0));
  wallTwo = new Wall(0 + 150, 500, 350, 50, color(0, 0, 0));
  wallThree = new Wall(300, 575, 50, 175, color(0, 0, 0));
  wallFour = new Wall(238, 250, 175, 50, color(0, 0, 0));
  wallFive = new Wall(900, 250, 400, 50, color(0, 0, 0));
  wallSix = new Wall(700, 200, 50, 150, color(0, 0, 0));
  wallSeven = new Wall(700, 550, 50, 250, color(0, 0, 0));
  wallEight = new Wall(750, 425, 150, 50, color(0, 0, 0));

  // add enemies to the enemy list
  enemyList.add(enemyTopMiddle);
  enemyList.add(enemyTopLeft);
  enemyList.add(enemyBottomRight);
  enemyList.add(enemyMiddleRight);
  enemyList.add(enemyTopRight);
  enemyList.add(enemyLeftMiddle);
  
  // add walls to the list
  wallList.add(wallOne);
  wallList.add(wallTwo);
  wallList.add(wallThree);
  wallList.add(wallFour);
  wallList.add(wallFive);
  wallList.add(wallSix);
  wallList.add(wallSeven);
  wallList.add(wallEight);

  // add objects to player health list
  playerHealthList.add(playerHealthOne);
  playerHealthList.add(playerHealthTwo);
  playerHealthList.add(playerHealthThree);

  // image variables
  dirt = loadImage("dirt.png");
  dirt.resize(500, 400);

  sand = loadImage("sand.png");
  sand.resize(500, 400);
  
  title = loadImage("Cover_Image.png");
  title.resize(1000, 800);
  
  win = loadImage("Win_Screen.png");
  win.resize(1000, 800);
  
  death = loadImage("Death_Screen.png");
  death.resize(1000, 800);
}

// draw
void draw() {
  stateMachine();
  changeLEDState();
  serialEvent(port);
}

/////////////////////////////////////////
// FUNCTIONS FOR SENDING INFO TO ARDUINO
/////////////////////////////////////////

// if the state of the game changes then update the neopixels accordingly
void changeLEDState() {
  if (state != prevState) {
    if (state == 2) {
      port.write('D');        
    } 
    else if (state == 3) {
      port.write('W');        
    } 
    else {
      port.write('C');
    }
    prevState = state;
  }
}

///////////////////////////
// FUNCTION DEFINITIONS
///////////////////////////

// controls the players shooting ability and the state changing press by pressing arduino buttons
void serialEvent(Serial p) {
  String cmd = p.readStringUntil('\n');
  
  if (cmd == null) {
    return;
  }
  
  cmd = cmd.trim();

  switch(cmd) {
    case "/U":   
      player.isMovingUp = true;   
      player.isMovingDown = false;
      player.isMovingLeft = false;
      player.isMovingRight = false;
      player.lastDirection = "up";
      break;
      
    case "/D":   
      player.isMovingDown = true;
      player.isMovingUp = false;
      player.isMovingLeft = false;
      player.isMovingRight = false;
      player.lastDirection = "down";
      break;
      
    case "/L":   
      player.isMovingLeft = true;
      player.isMovingRight = false;
      player.isMovingUp = false;
      player.isMovingDown = false;
      player.lastDirection = "left";
      break;
      
    case "/R":   
      player.isMovingRight = true;
      player.isMovingLeft = false;
      player.isMovingUp = false;
      player.isMovingDown = false;
      player.lastDirection = "right";
      break;
      
    case "/S":
      // only stop if explicitly told to stop
      player.isMovingUp = false;
      player.isMovingDown = false;
      player.isMovingLeft = false;
      player.isMovingRight = false;
      break;

    case "/s":
      if (millis() - startTime >= interval) {
        int dx = 0, dy = 0;
        if (player.lastDirection.equals("up")) {
          dy = -1;
        }
        else if (player.lastDirection.equals("down")) {
          dy = +1;
        }
        else if (player.lastDirection.equals("left")) {
          dx = -1;
        }
        else if (player.lastDirection.equals("right")) {
          dx = +1;
        }

        playerBulletList.add(new PlayerBullet(player.x, player.y, dx, dy, color(0,255,0)));
        startTime = millis();
      }
      
      break;

    case "/r":
      if (state == 0) {
        state = 1;
      } 
      else if (state == 2 || state == 3) {
        resetGame();
        state = 0;
      }
      break;
  }
}

/* handles all bullets in the bullet array list */
void handlePlayerBullets() {
  for (PlayerBullet aBullet : playerBulletList) {
    aBullet.render();
    aBullet.move();
    aBullet.checkRemove();

    for (Enemy anEnemy : enemyList) {
      aBullet.collisionWithEnemy(anEnemy);
    }

    for (Wall aWall : wallList) {
      aBullet.collisionWithWall(aWall);
    }
  }
}

// handles all down shooting enemies bullets
void handleEnemyBullets() {
  for (EnemyBullet aBullet : enemyBullet) {
    aBullet.render();
    aBullet.checkRemove();
    aBullet.collisionWithPlayer(player);
    aBullet.move();
    
    for (Wall aWall : wallList) {
      aBullet.collisionWithWall(aWall);
    }
  }
}

// removes bullets from the list if needed
void removePlayerBullets() {
  for (int i = playerBulletList.size() - 1; i >= 0; i--) {
    PlayerBullet aBullet = playerBulletList.get(i);

    if (aBullet.shouldRemove == true) {
      playerBulletList.remove(aBullet);
    }
  }
}

// removes down shooting enemies bullets
void removeEnemyBullets() {
  for (int i = enemyBullet.size() - 1; i >= 0; i--) {
    EnemyBullet aBullet = enemyBullet.get(i);

    if (aBullet.shouldRemove == true) {
      enemyBullet.remove(aBullet);
    }
  }
}

// handles all down shooting enemies
void handleEnemies() {
  for (Enemy aEnemy : enemyList) {
    aEnemy.render();
    aEnemy.move();
    handleEnemyShooting();
    
    for (Wall aWall : wallList) {
       aEnemy.wallCollision(aWall);
    }
  }
}

// removes down shooting enemies from the list if needed
void removeEnemies() {
  for (int i = enemyList.size() - 1; i >= 0; i--) {
    Enemy anEnemy = enemyList.get(i);

    if (anEnemy.hitBullet == true) {
      enemyList.remove(anEnemy);
    }
  }
}

// handles all the walls
void handleWalls() {
  for (Wall aWall : wallList) {
    aWall.render();
  }
}

// handles all player functions
void handlePlayer(Player aPlayer) {
  aPlayer.render();
  aPlayer.move();
  aPlayer.hasHitBullet();

  // checks for a player wall collision for each wall in the list
  for (Wall aWall : wallList) {
    aPlayer.wallCollision(aWall);
  }
}

// handles the down shooting enemies automatic shooting
void handleEnemyShooting() {
  for (Enemy anEnemy : enemyList) {
    if (millis() - anEnemy.lastShotTime >= anEnemy.startShooting) {
      enemyBullet.add(new EnemyBullet(anEnemy.x, anEnemy.y, color(255, 0, 0), anEnemy.currentDirection));
      anEnemy.lastShotTime = millis();
    }
  }
}

// updates the visual representation of the players health if the player is hit by a bullet
void updatePlayerHealth () {
  int i = playerHealthList.size() - 1;

  if (player.hitEnemyBullet && playerHealthList.size() > 0) {
    playerHealthList.remove(i);
  }
}

// renders the players health
void renderPlayerHealth() {
  for (PlayerHealth aHealth : playerHealthList) {
    aHealth.render();
  }
}

// renders the players health text
void renderHealthText() {
  textSize(30);
  fill(0, 0, 0);
  text("HEALTH: ", 30, 750);
}

// changes the state of the game if the player defeats all the enemies
void checkWin() {
  if (enemyList.size() == 0) {
    state = 3;
  }
}

// changes the state of the game if the player dies
void checkDeath() {
  if (player.health <= 0) {
    state = 2;
  }
}

// resets the game once the player either wins or dies
void resetGame() {
  enemyList.clear();
  enemyList.add(enemyTopMiddle);
  enemyList.add(enemyTopLeft);
  enemyList.add(enemyBottomRight);
  enemyList.add(enemyMiddleRight);
  enemyList.add(enemyTopRight);
  enemyList.add(enemyLeftMiddle);

  for (Enemy aEnemy : enemyList) {
    aEnemy.hitBullet = false;
  }

  wallList.clear();
  playerHealthList.clear();
  enemyBullet.clear();
  playerBulletList.clear();

  // add walls to the list
  wallList.add(wallOne);
  wallList.add(wallTwo);
  wallList.add(wallThree);
  wallList.add(wallFour);
  wallList.add(wallFive);
  wallList.add(wallSix);
  wallList.add(wallSeven);
  wallList.add(wallEight);

  // add objects to player health list
  playerHealthList.add(playerHealthOne);
  playerHealthList.add(playerHealthTwo);
  playerHealthList.add(playerHealthThree);

  player.x = 100;
  player.y = 600;
  player.health = 3;
}

// runs all of the gameplay functions
void playGame() {
  // display images
  image(dirt, 750, 200);
  image(sand, 250, 200);
  image(dirt, 750, 600);
  image(sand, 250, 600);

  handlePlayer(player);
  handlePlayerBullets();
  removePlayerBullets();

  handleEnemyBullets();

  handleEnemies();

  removeEnemyBullets();

  removeEnemies();

  handleWalls();
  renderHealthText();
  renderPlayerHealth();
  updatePlayerHealth();

  checkWin();
  checkDeath();
  // arduinoInfo();
}

// start screen for the game
void startScreen() {
  image(title, width / 2, height / 2);
  textSize(46);
  fill(color(0, 0, 0));
  text("Press Begin To Start!", 280, 220);
}

// death screen
void deathScreen() {
 image(death, width / 2, height / 2);
}

// win screen
void winScreen() {
  image(win, width / 2, height / 2);
}

// state machine that runs the entire program
void stateMachine() {
  switch(state) {
  case 0:
    startScreen();
    break;

  case 1:
    playGame();
    break;

  case 2:
    deathScreen();
    break;

  case 3:
    winScreen();
    break;
  }
}
