import java.util.Collections.*;
import java.util.Comparator;
import java.util.Arrays;

final boolean DEBUG = false;

float gravity = 0.002;

enum GameMode {
  PLAY,
  PAUSE,
  CRASHING,
  CRASHED,
  LANDED
}
GameMode mode = GameMode.PLAY;

float[] cameraPos = {0, 0};

Module module = new Module(0, 0);
ArrayList<float[]> stars = new ArrayList();
ArrayList<Particle> particles = new ArrayList();

Terrain terrain;
int widthRounded;

void setup() {
  size(1024, 768);
  frameRate(60);
  
  // Generate starry background
  for (int i = 0; i < random(100, 100); i ++) {
    stars.add(new float[] {random(width), random(height)});
  }
  
  terrain = new Terrain();
}

/**
* Main game loop
*/
void draw() {
  background(0);
  
  // Draw stars
  stroke(255);
  for (float[] star : stars) {
    point(star[0] - cameraPos[0], star[1] - cameraPos[1]);
  }
  
  // Terrain
  terrain.render();
  
  // Particle effects
  ArrayList<Particle> remove = new ArrayList();
  for (Particle p : particles) {
    p.update();
    p.render();
    if (p.alpha <= 0) remove.add(p);
  }
  for (Particle r : remove) particles.remove(r);
  
  // Module
  module.update();
  module.render();
  
  // Update camera position
  cameraPos = module.pos;
 
  // Information
  fill(255);
  if (mode == GameMode.PLAY) {
    textSize(12);
    text("FUEL: " + module.fuel, 10, 20);
    text("REL. ALT: " + (int)(terrain.getHeight(module.pos[0]) - module.pos[1])/4, 10, 40);
    text("VEL (x): " + (int)(module.vel[0]*50), 10, 60);
    text("VEL (y): " + (int)(-module.vel[1]*50), 10, 80);
  } else if (mode == GameMode.LANDED) {
    textSize(48);
    text("LANDED", 10, 46);
  } else if (mode == GameMode.CRASHING) {
    textSize(48);
    text("CRASHING", 10, 46);
  } else if (mode == GameMode.CRASHED) {
    textSize(48);
    text("CRASHED", 10, 46);
  }
}

/**
* Handle key presses
*/
void keyPressed() {
  if (mode == GameMode.PLAY && module.fuel > 0) {
    if (key == 'a') module.turn(-1);
    if (key == 'd') module.turn(1);
    if (key == 'w') module.thrust();
    if (key == 's') {
      if (module.angVel > 0) module.turn(-1);
      else if (module.angVel < 0) module.turn(1);
    }
  }
}


void reset(boolean resetFuel) {
  module.pos = new float[] {0, 0};
  terrain = new Terrain();
  if (resetFuel) module.fuel = module.initialFuel;
}
