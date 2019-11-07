import AULib.*;

static public class Param {
  PApplet app;
  
  float val;
  boolean paused;
  int mode;
  Oscillator oscillator;
  NoiseLoop noiseLoop;
  Easer easer;
  
  Param(PApplet papp, float startVal, Oscillator osc, NoiseLoop nl) {
    app = papp;
    val = startVal;
    mode = 0;
    paused = false;
    oscillator = osc;
    noiseLoop = nl;
    easer = new Easer(app, val);
    //app.registerMethod("keyEvent", this);
  }
  
  public float getValue() {
    switch(mode){
      case(0):
        val = easer.getValue();
        break;
      case(1)://noiseLoop
        val = noiseLoop.getValue();
        break;
      case(2)://oscillator
        val = oscillator.getValue();
        break;        
    }
    return val;
  }
  
  public void setEase(float fac){
    easer.setEase(fac);
  }
  
  public void switchMode() {
    mode = (mode + 1) % 3;
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
    }
  }
  
  public void setVal(float valIn){
    val = valIn;
  }
  
  public void multVal(float frac){
    val *= frac;
  }
  
  public void setMode(int m){
    mode = m % 3;
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
