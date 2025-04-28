class PlayerHealth {
  int x;
  int y;
  int w;
  int h;
  
  PlayerHealth(int aX, int aY, int aW, int aH) {
    x = aX;
    y = aY;
    w = aW;
    h = aH;
  }
  
  ///////////////////////////////////////
  // PLAYER HEALTH FUNCTION DEFINITIONS
  ///////////////////////////////////////
  
  // renders the player health
  void render() {
    fill(0, 255, 0);
    rect(x, y, w, h);
  }
}
