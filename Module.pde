class Module {
  // Size as coefficient of 100% (used for when crashing)
  float size = 1;
  
  int timer = 0;
  
  // Initial fuel amount
  int fuel = 200;
  
  // Fuel consumption per unit of change in angular velocity / linear velocity
  final float turnFuel = 500;
  final float thrustFuel = 1;
  
  // Current position, velocity, and acceleration vectors
  // Index 0 -> x, index 1 -> y
  float[] pos = {0, 0};
  float[] vel = {0, 0};
  float[] acc = {0, 0};
  
  // Direction that the module is facing, 0 = up (radians)
  float ang; 
  float angVel;
  final float maxAngVel = 0.1;
  
  // Defines the strength of the controls
  final float turnForce = 0.005;
  final float thrustForce = 0.1;
  
  // Defines the shape of the module
    float[][] vertices = 
      {{-10, -10}, {10, -10}, {15, 0}, {10, 10}, 
      {15, 10}, {20, 20}, {18, 20}, {14, 14}, 
      {8, 14}, {12, 20}, {-12, 20}, {-8, 14},
      {-14, 14}, {-18, 20}, {-20, 20}, {-15, 10}, 
      {-10, 10}, {-15, 0}};
      
    // Collision box
    float[][] collision = {{-20, -10}, {20, -10}, {20, 20}, {-20, 20}};
  
  Module(float x, float y) {
    this.pos = new float[] {x, y};
    this.vel = new float[] {0, 0};
  }
  
  /**
  * Thrust the module
  */
  void thrust() {
    // Change in velocity in each dimension
    double dx = module.thrustForce * Math.sin(module.ang);
    double dy = module.thrustForce * Math.cos(module.ang);
    
    fuel -= Math.hypot(dx, dy) * thrustFuel;
    
    for (int i = 0; i < (int) random(2, 5); i ++) {
      float[] thrustPos = posRotated(new float[] {(collision[3][0] + collision[2][0])/2 + random(-10, 10), collision[3][1]});
      particles.add(new Particle(thrustPos[0] + pos[0], thrustPos[1] + pos[1], vel[0], vel[1] + random(-0.4, 0.4), new int[] {255, 150, 150}, random(1, 3), -5));
    }
    
    vel[0] += dx;
    vel[1] -= dy;
  }
  
  /** 
  * Rotate the module
  * @param dir Left (-1) OR right (1), there should be no other input
  */
  void turn(int dir) {
    assert dir == 1 || dir == -1;
    
    float change = 0;
    // For increasing magnitude of angular velocity, 
    // adjust angular acceleration by proximity to maximum angVel
    if ((angVel > 0 && dir == 1) || (angVel < 0 && dir == -1))
      change = (maxAngVel - Math.abs(angVel)) / maxAngVel * turnForce * dir;
    // Otherwise (for slowing down spin) angular acceleration is constant
    else change = turnForce * dir;
    
    angVel += change;
    fuel -= Math.abs((int)(change * turnFuel));
  }
  
  /**
  * Update the module's location and orientation according to physical rules
  */
  void update() {
    if (mode == GameMode.PLAY) {
      this.ang += this.angVel;
      
      // Update velocity (due to gravity)
      this.vel[1] += gravity;
      
      // Update position
      this.pos[0] += this.vel[0];
      this.pos[1] += this.vel[1];
      
      // Collision detection for each of 8 points
      float[] BL = posRotated(collision[3]);
      float[] BM = posRotated(new float[] {(collision[3][0] + collision[2][0])/2, collision[3][1]});
      float[] BR = posRotated(collision[2]);
      float[] ML = posRotated(new float[] {collision[3][0], (collision[3][1] + collision[0][1])/2});
      float[] MR = posRotated(new float[] {collision[2][0], (collision[2][1] + collision[1][1])/2});
      float[] TL = posRotated(collision[0]);
      float[] TM = posRotated(new float[] {(collision[0][0] + collision[1][0])/2, collision[0][1]});
      float[] TR = posRotated(collision[1]);
      for (Terrain t : terrain) {
        boolean collide = false;
        boolean vert = false;
        boolean horiz = false;
        
        if (t.isWithin(BM[0] + pos[0], BM[1] + pos[1]) || t.isWithin(TM[0] + pos[0], TM[1] + pos[1])) { 
          if (DEBUG) println("Collision: Top/Bottom");
          vert = true;
          collide = true;
        }
        if (t.isWithin(ML[0] + pos[0], ML[1] + pos[1]) || t.isWithin(MR[0] + pos[0], MR[1] + pos[1])) { 
          if (DEBUG) println("Collision: Left/Right");
          horiz = true;
          collide = true;
        }
        if (t.isWithin(BR[0] + pos[0], BR[1] + pos[1]) || t.isWithin(BL[0] + pos[0], BL[1] + pos[1])
            || t.isWithin(TR[0] + pos[0], TR[1] + pos[1]) || t.isWithin(TL[0] + pos[0], TL[1] + pos[1])) { 
          if (DEBUG) println("Collision: CORNER");
          horiz = true;
          vert = true;
          collide = true;
        }
        
        // Check whether this collision is a safe landing or crash
        if (collide) { 
          this.angVel = 0;
          if (this.vel[1] < 10 && Math.abs(ang) < Math.PI / 8) {
            land();
          } else crash();
        }
        
        if (vert) {
          this.pos[1] -= this.vel[1];
          this.vel[1] = 0;
        }
        
        if (horiz) {
          this.pos[0] -= this.vel[0];
          this.vel[0] = 0;
        }
      }
    } else if (mode == GameMode.CRASHING) {
      size *= 0.85;
      
      // Generate explosion particles
      for (int i = 0; i < 10; i ++) {  
        float vel = random(-2, 2);
        float ang = random(0, (float)(2 * Math.PI));
        particles.add(new Particle(pos[0], pos[1], (float)(Math.cos(ang) * vel), (float)(Math.sin(ang) * vel), 
            new int[] {200, 200, 200}, 3, -10));
      }
     
      if (size < 0.05) mode = GameMode.PAUSE;
    }
  }
  
  void crash() {
    mode = GameMode.CRASHING;
    if (DEBUG) println("CRASHED");
  }
  
  void land() {
    mode = GameMode.LANDED;
    if (DEBUG) println("LANDED");
  }
  
  /**
  * Returns the relative position of the given point considering the rotation of the module
  */
  private float[] posRotated(float[] p) {
    assert p.length == 2;
    return new float[] 
      {(float)(p[0] * Math.cos(ang) - p[1] * Math.sin(ang)),
      (float)(p[0] * Math.sin(ang) + p[1] * Math.cos(ang))};
  }
  
  /**
  * Draw the module
  */
  void render() {
    fill(200);
    noStroke();
    
    // Draw all vertices of the shape, adjusted for angle and location
    beginShape();
    for(int i = 0; i < vertices.length; i ++) {
      float[] rotated = posRotated(new float[] {vertices[i][0], vertices[i][1]});
      vertex(
          (rotated[0] * scale * size + pos[0] - cameraPos[0] + width / 2),
          (rotated[1] * scale * size + pos[1] - cameraPos[1] + height / 2));
    }
    endShape();
    
    // Draw collision box if debugging
    if (DEBUG) {
      fill(255, 255, 255, 50);
      beginShape();
      for(int i = 0; i < collision.length; i ++) {
        float[] rotated = posRotated(new float[] {collision[i][0], collision[i][1]});
        vertex(
          (rotated[0] * scale + pos[0] - cameraPos[0] + width / 2),
          (rotated[1] * scale + pos[1] - cameraPos[1] + height / 2));
      }
      endShape();
    }
  }
}
