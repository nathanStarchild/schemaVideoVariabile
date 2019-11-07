static public class Easer {
  PApplet app;
  
  int tStart, tEnd, duration;
  float val, sVal, eVal, t;
  boolean paused;
  
  Easer(PApplet papp, float valIn) {
    app = papp;
    val = valIn;
    sVal = val;
    eVal = val;
    duration = 50;
    t = 0;
    tStart = 0;
    tEnd = tStart + duration;
    paused = false;
  }
  
  public float getValue() {
    t = norm(app.frameCount, tStart, tEnd);
    float d = AULib.ease(AULib.EASE_CUBIC_ELASTIC, t);
    val = lerp(sVal, eVal, d);
    return val;
  }
  
  public void setEase(float fac){
    tStart = app.frameCount;
    tEnd = tStart + duration;
    sVal = val;
    eVal *= fac;
    println("new target: " + eVal);
  }
  
  public void pause(){
    paused = true;
  }
  
  public void unPause() {
    paused = false;
  }
  
}
