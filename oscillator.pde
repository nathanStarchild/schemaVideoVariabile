static public class Oscillator {
  PApplet app;
  
  OpenSimplexNoise osNoise;
  
  float min, max, increment, t;
  boolean paused, isSin;
  
  Oscillator(PApplet papp, float minIn, float maxIn, float inc, boolean s) {
    app = papp;
    min = minIn;
    max = maxIn;
    increment = inc;
    isSin = s;
    paused = false;
    t = 0;
  }
  
  public float getValue() {
    if (!paused){
      t += increment;
    }
    if(isSin){
      return map(sin(t), -1, 1, min, max);
      //return map(app.noise(t), 0, 1, min, max);
    }
    return t;
    //return 
  }
  
}
