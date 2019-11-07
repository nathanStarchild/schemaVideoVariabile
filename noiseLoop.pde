static public class NoiseLoop {
  PApplet app;
  
  float min, max, increment, t, radius;
  float xOff, yOff;
  char incUp, incDown, rUp, rDown, pause;
  boolean paused;
  
  NoiseLoop(PApplet papp, float minIn, float maxIn, float r, float inc, char incU, char incD, char rU, char rD, char p, float xOffIn) {
    app = papp;
    min = minIn;
    max = maxIn;
    radius = r;
    increment = inc;
    incUp = incU;
    incDown = incD;
    rUp = rU;
    rDown = rD;
    pause = p;
    paused = false;
    t = 0;
    xOff = xOffIn;
    yOff = 0;
    //xOff = app.random(100);
    //yOff = app.random(100);
    app.registerMethod("keyEvent", this);
  }
  
  public float getValue() {
    if (!paused){
      t += increment;
    }
    
    float nfx = radius * cos(t);
    float nfy = radius * sin(t);
    //println(nfx);
    
      
    float ln = map(app.noise(nfx + xOff, nfy + yOff), 0, 1, min, max);
    return ln;
  }  
  
  public void setMax(float m) {
    max = m;
  }
  
  public void setMin(float m) {
    min = m;
  }
  
  public void pause(){
    paused = true;
  }
  
  public void unPause() {
    paused = false;
  }
  
  public void keyEvent(KeyEvent event) {
    char k = event.getKey();
      if(k == incUp){
        increment *= 1.1;
        }
      if(k == incDown){
        increment /= 1.1;
        }
      if(k == rUp){
        radius *= 1.1;
        }
      if(k == rDown){
        radius /= 1.1;
        }
      //if(k == pause){
      //  paused = !paused;
      //  }
  }
}
