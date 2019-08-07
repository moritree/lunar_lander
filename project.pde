import java.util.Collections.*;
import java.util.Comparator;
import java.util.Arrays;

final boolean DEBUG = false;

float scale = 1;
float gravity = 0.002;

enum GameMode {
  PLAY,
  PAUSE
}
GameMode mode = GameMode.PLAY;

float[] cameraPos = {0, 0};

Module module = new Module(0, 0);

// Decoration
ArrayList<float[]> stars = new ArrayList();

ArrayList<Terrain> terrain = new ArrayList();

void setup() {
  size(1024, 768);
  
  // Generate starry background
  for (int i = 0; i < random(100, 100); i ++) {
    stars.add(new float[] {random(width), random(height)});
  }
  
  // Generate terrain
  terrain.add(new TerrainTri(-60, 60, -60, 0, -30, 60, 100));
  terrain.add(new TerrainRect(-500, 60, 1000, 500, 100));
  terrain.add(new TerrainRect(-200, 0, 140, 60, 100));
  terrain.add(new TerrainTri(-200, 60, -200, -30, -300, 60, 100));
  terrain.add(new TerrainTri(-200, 0, -200, -30, -150, 0, 100));
  
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
  
  for (Terrain t : terrain) t.render();
  
  if (mode == GameMode.PLAY) module.update();
  module.render();
  
  cameraPos = module.pos;
 
  fill(255);
  text("FUEL: " + module.fuel, 10, 20);
  text("Velocity (x): " + (int)(module.vel[0]*50), 10, 40);
  text("Velocity (y): " + (int)(-module.vel[1]*50), 10, 60);
}

void keyPressed() {
  if (module.fuel > 0) {
    if (key == 'a') module.turn(-1);
    if (key == 'd') module.turn(1);
    if (key == 'w') module.thrust();
  }
}
