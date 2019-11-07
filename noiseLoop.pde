public class NoiseLoop {
  PApplet app;
  
  float radius;
  float xOff, yOff;
  boolean paused;
  
  NoiseLoop(float r, float xOffIn, float yOffIn) {
    radius = r;
    paused = false;
    xOff = xOffIn;
    yOff = yOffIn;
    osNoise = new OpenSimplexNoise();
  }
  
  public float getValue(float t) {
    float nfx = radius * cos(t);
    float nfy = radius * sin(t);
    float ln = (float)osNoise.eval(nfx + xOff, nfy + yOff);
    return ln;
  }  
  
  public float getValue(float t, float x) {
    float nfx = radius * cos(t);
    float nfy = radius * sin(t);
    float ln = (float)osNoise.eval(nfx + xOff, nfy + yOff, x);
    return ln;
  }  
  
  public float getValue(float t, float x, float y) {
    float nfx = radius * cos(t);
    float nfy = radius * sin(t);
    float ln = (float)osNoise.eval(x, y, nfx + xOff, nfy + yOff);
    return ln;
  }  
  
  public void pause(){
    paused = true;
  }
  
  public void unPause() {
    paused = false;
  }
  
}
