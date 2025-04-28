class Wall {
  // wall variables
  int x;
  int y;
  int w;
  int h;
  color c;

  // hitbox variables
  int left;
  int right;
  int top;
  int bottom;
  
  // image variables
  PImage sandBeigeImage;
  PImage sandBrownImage;

  // wall constructor
  Wall(int aX, int aY, int aW, int aH, color aColor) {
    x = aX;
    y = aY;
    w = aW;
    h = aH;
    c = aColor;

    left = x - w / 2;
    right = x + w / 2;
    top = y - h / 2;
    bottom = y + h / 2;
    
    sandBeigeImage = loadImage("sandbagBeige.png");
    sandBeigeImage.resize(w, h);
    
    sandBrownImage = loadImage("sandbagBrown.png");
    sandBrownImage.resize(w, h);
  }

  ///////////////////////////////
  // WALL FUNCTION DEFINITIONS
  ///////////////////////////////

  // renders a wall
  void render() {
    fill(c);
    
    if (x > 600) {
    image(sandBeigeImage, x, y);
    }
    else if (x < 600) {
      image(sandBrownImage, x, y);
    }
  }
}
