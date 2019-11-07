static public class Oscillator {
  PApplet app;
  
  float min, max, increment, t;
  char incUp, incDown, pause;
  boolean paused, isSin;
  
  Oscillator(PApplet papp, float minIn, float maxIn, float inc, char incU, char incD, char p, boolean s) {
    app = papp;
    min = minIn;
    max = maxIn;
    increment = inc;
    incUp = incU;
    incDown = incD;
    pause = p;
    isSin = s;
    paused = false;
    t = 0;
    app.registerMethod("keyEvent", this);
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
  
  public void keyEvent(KeyEvent event) {
    char k = event.getKey();
      if(k == incUp){
        increment *= 1.1;
        }
      if(k == incDown){
        increment /= 1.1;
        }
      //if(k == pause){
      //  paused = !paused;
      //  }
  }
}
