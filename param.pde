import AULib.*;

public class Param {
  PApplet app;
    
  float val, min, max, increment, t;
  boolean paused;
  int mode, last;
  //Oscillator oscillator;
  NoiseLoop noiseLoop;
  Easer easer;
  
  //Param(PApplet papp, float startVal, Oscillator osc, NoiseLoop nl) {
  Param(float minIn, float maxIn, float incIn, NoiseLoop nl) {
    min = minIn;
    max = maxIn;
    val = (min + max)/2.0;
    mode = 0;
    paused = false;
    t = 0;
    increment = incIn;
    noiseLoop = nl;
    easer = new Easer(val, increment*50);
    last = millis();
    //app.registerMethod("keyEvent", this);
  }
  
  public float getValue(float x) {
    switch(mode){
      case(0):
        val = easer.getValue(x);
        break;
      case(1)://noiseLoop
        val = map(noiseLoop.getValue(x), -1, 1, min, max);
        break;
      case(2)://oscillator
        val = map(sin(x), -1, 1, min, max);
        break;      
      case(3)://incrementer
        val += increment;
        break;
    }
    return val;
  }
  
  public float getValue() {
    if (!paused){
      //t += increment;
      if (live) {
        advanceLive(1);
      } else {
        advance(1);
      }
    }
    return getValue(t);
  }
  
  public float getValue(float x, float y) {
    //println("yes, hello");
    if (!paused){
      //t += increment;
      if (live) {
        advanceLive(1);
      } else {
        advance(1);
      }
    }
    val = map(noiseLoop.getValue(t, x, y), -1, 1, min, max);
    return val;
    
  }
  
  public void setEase(float fac){
    easer.setEaseByFactor(fac, t);
  }
  
  public void setEaseByTarget(float targ){
    easer.setEaseByTarget(targ, t);
  }
  
  public void switchMode() {
    mode = (mode + 1) % 4;
    switch(mode){
      case(0):
        println("easer mode");
        break;
      case(1)://noiseLoop
        println("noise loop mode");
        break;
      case(2)://oscillator
        println("oscillator mode");
        break;    
      case(3):
        println("incrementer mode");
        break;
    }
  }
  
  public void setVal(float valIn){
    val = valIn;
  }
  
  public void multVal(float frac){
    val *= frac;
  }
  
  public void setMode(int m){
    mode = m % 4;
  }
  
  public void setMin(float m){
    min = m;
  }
  
  public void setMax(float m){
    max = m;
  }
  
  public void pause(){
    paused = true;
  }
  
  public void unpause(){
    paused = false;
    last = millis();
  }
  
  public void advance(int n){
    t += increment * n;
  }
  
  public void advanceLive(int n){
    int now = millis();
    t += n * increment * (now-last)*30/1000.0;
    last = now;
  }
  
  //public void keyEvent(KeyEvent event) {
  //  char k = event.getKey();
  //    if(k == incUp){
  //      increment *= 1.1;
  //      }
  //    if(k == incDown){
  //      increment /= 1.1;
  //      }
  //    if(k == pause){
  //      paused = !paused;
  //      }
  //}
}
