class Particle {
  float[] pos;
  float[] vel;
  int[] col;
  float size;
  int alpha = 255;
  int alphaChange;
  
  Particle(float xPos, float yPos, float xVel, float yVel, int[] rgb, float isize, int ialphaChange) {
    assert rgb.length == 3;
    
    pos = new float[] {xPos, yPos};
    vel = new float[] {xVel, yVel};
    col = rgb;
    size = isize;
    alphaChange = ialphaChange;
  }
  
  void update() {
    pos[0] += vel[0];
    pos[1] += vel[1];
    alpha += alphaChange;
  }
  
  void render() {
    noStroke();
    fill(col[0], col[1], col[2], alpha);
    circle(pos[0] - cameraPos[0]  + width / 2, pos[1] - cameraPos[1]+ height / 2, size);
  }
}
