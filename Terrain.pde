public class Terrain {
  private HashMap<Integer, Float> terrainHeight = new HashMap();
  final int incX = 25;
  final int incY = 25;
  
  final int minHeight = 60;
  final int maxHeight = 300;
  
  int widthRounded;
  
  Terrain() {
    // Generate initial terrain
    widthRounded = Math.round(width / incX) * incX;
    if (DEBUG) println("widthRounded: " + widthRounded);
    terrainHeight.put(- widthRounded, (float)(Math.round(random(60, 150) / incY) * incY));
    for (int i = - widthRounded + incX; i < widthRounded; i += incX) {
      boolean isFlat = (random(1) < 0.2);
      float newHeight = maxHeight + 1;
      if (isFlat) {
        newHeight = terrainHeight.get(i - incX);
      } else {
        while (newHeight > maxHeight || newHeight < minHeight) {
          newHeight = (float)(terrainHeight.get(i - incX) + Math.round(random(-3, 3)) * incY);
        }
      }
      terrainHeight.put((Integer)i, newHeight);
    }
  }
  
  boolean isWithin(float x, float y) { 
    if (getHeight(x) < y) return true;
    else return false;
  }
  
  double getHeight(float x) {
    int colL = (int)(Math.floor(x / incX) * incX);
    int colR = (int)(Math.ceil(x / incX) * incX);
    if (terrainHeight.get(colL) == null || terrainHeight.get(colR) == null) return 0;
    
    double gradient = (terrainHeight.get(colR) - terrainHeight.get(colL)) / incX;
    return gradient * (x - colL) + terrainHeight.get(colL);
  }
  
  void render() {
    widthRounded = Math.round(width / incX) * incX;
    
    for (int i = -widthRounded; i < widthRounded; i += incX) {
      if (terrainHeight.get(i) == null) terrainHeight.put((Integer)i, (float)(terrainHeight.get(i + incX) + Math.round(random(-2, 2)) * incY));
      if (terrainHeight.get(i + incX) == null) terrainHeight.put((Integer)i + incX, (float)(terrainHeight.get(i) + Math.round(random(-2, 2)) * incY));
      
      stroke(150);
      strokeWeight(1);
      fill(150);
      beginShape();
      vertex(i - cameraPos[0] + width/2, terrainHeight.get(i) - cameraPos[1] + height/2);
      vertex(i + incX - cameraPos[0] + width/2, terrainHeight.get(i + incX) - cameraPos[1] + height/2);
      vertex(i + incX - cameraPos[0] + width/2, height);
      vertex(i - cameraPos[0] + width/2, height);
      endShape();
    }
  }
}
