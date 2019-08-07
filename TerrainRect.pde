class TerrainRect implements Terrain {
  float[][] vertices;
  int shade;
  
  TerrainRect(float x0, float y0, float wid, float hgt, int shade) {
    vertices = new float[][] {{x0, y0}, {x0 + wid, y0}, {x0 + wid, y0 + hgt}, {x0, y0 + hgt}};
    this.shade = shade;
  }
  
  boolean isWithin(float x, float y) {
    if(x >= vertices[0][0] && x <= vertices[1][0] && y >= vertices[0][1] && y <= vertices[2][1]) return true;
    else return false;
  }
  
  void render() {
    fill(shade);
    stroke(shade);
    strokeWeight(1);
    
    beginShape();
    for (int i = 0; i < vertices.length; i ++) {
      float x = vertices[i][0];
      float y = vertices[i][1];
      vertex(
        (float)(x * scale - cameraPos[0] + width / 2),
        (float)(y * scale - cameraPos[1] + height / 2));
    }
    endShape();
  }
}
