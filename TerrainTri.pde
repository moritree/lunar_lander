class TerrainTri implements Terrain {
  float[][] vertices;
  int shade;
  
  // Comparator to sort vertices in order of y value
  final Comparator<float[]> Y_CMP = new Comparator<float[]>() {
    public int compare(float[] a, float[] b) {
      return Float.compare(a[1], b[1]);
    }
  };
  
  TerrainTri(float x0, float y0, float x1, float y1, float x2, float y2, int shade) {
    vertices = new float[][] {{x0, y0}, {x1, y1}, {x2, y2}};
    Arrays.sort(vertices, Y_CMP);  // Pre-sort vertices
   
    this.shade = shade;
  }
  
  boolean isWithin(float x, float y) {
    if (y > vertices[0][1] && y < vertices[2][1]) {
      // Top half of triangle
      if (y < vertices[1][1]) {
        // find X value of line between v[0] and v[1] at y
        float m = (vertices[1][1] - vertices[0][1])/(vertices[1][0] - vertices[0][0]);
        float xBorder1 = (y - vertices[0][1]) / m + vertices[0][0];
        
        // find X value of line between v[0] and v[2] at y
        m = (vertices[2][1] - vertices[0][1])/(vertices[2][0] - vertices[0][0]);
        float xBorder2 = (y - vertices[0][1]) / m + vertices[0][0];
        
        // if x is between these values, then return true
        if ((xBorder1 < xBorder2 && x > xBorder1 && x < xBorder2) || (x > xBorder2 && x < xBorder1)) 
          return true;
      }
    }
    return false;
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
