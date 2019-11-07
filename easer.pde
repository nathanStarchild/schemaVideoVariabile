static public class Easer {
  PApplet app;
  
  float tStart, tEnd, duration;
  float val, sVal, eVal;
  boolean paused;
  
  Easer(PApplet papp, float valIn, float dIn) {
    app = papp;
    val = valIn;
    sVal = val;
    eVal = val;
    duration = dIn;
    tStart = 0;
    tEnd = tStart + duration;
    paused = false;
  }
  
  public float getValue(float x) {
    float t = norm(x, tStart, tEnd);
    float d = AULib.ease(AULib.EASE_CUBIC_ELASTIC, t);
    val = lerp(sVal, eVal, d);
    return val;
  }
  
  public void setEase(float fac, float x){
    tStart = x;
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
