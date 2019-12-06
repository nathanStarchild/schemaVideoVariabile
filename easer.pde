static public class Easer {
  
  float tStart, tEnd, duration;
  float val, sVal, eVal;
  boolean paused;
  int easeMode;
  
  Easer(float valIn, float dIn) {
    val = valIn;
    sVal = val;
    eVal = val;
    duration = dIn;
    tStart = 0;
    tEnd = tStart + duration;
    paused = false;
    easeMode = 0;
  }
  
  //public static final int EASE_LINEAR = 0;       // the simplest case, for completeness
  //public static final int EASE_IN_CUBIC = 1;      // start slow, finish abruptly D:[0, !0]  V:[0,1]
  //public static final int EASE_OUT_CUBIC = 2;     // start abruptly, finish slow D:[!0, 0]  V:[0,1]
  //public static final int EASE_IN_OUT_CUBIC = 3;  // start and end slow D:[0, 0]  V:[0,1]
  //public static final int EASE_IN_BACK = 4;       // start slow, back up, finish abruptly D:[0, !0] V:[-1.1, 1]
  //public static final int EASE_OUT_BACK = 5;      // start abruptly, overshoot, then end slow D:[!0, 0]  V:[0, 1.1]
  //public static final int EASE_IN_OUT_BACK = 6;   // start slow, undershoot, overshoot, end slow D:[0, 0]  V:[-0.05, 1.05]
  //public static final int EASE_IN_ELASTIC = 7;    // sit there, wiggle a bit, then zoom to end D:[0, !0]  V:[-.336, 1]
  //public static final int EASE_OUT_ELASTIC = 8;   // zoom to overshoot, then slowly wiggle into place D:[!0, 0] V:[0, 1.33]
  //public static final int EASE_IN_OUT_ELASTIC = 9; // sit there, wiggle, overshoot end, wiggle and settle D:[0, 0]  V:[-.17, 1.17]
  //// These are my hybrids
  //public static final int EASE_CUBIC_ELASTIC = 10;       // start slow, then bounce at the end D=[0,0] V:[0,1.17]
  //public static final int EASE_ANTICIPATE_CUBIC = 11;   // small negative motion, then ease
  //public static final int EASE_ANTICIPATE_ELASTIC = 12; // small backwards motion, then bounce
  
  public float getValue(float x) {
    float t = norm(x, tStart, tEnd);
    float d = AULib.ease(easeMode, t);
    val = lerp(sVal, eVal, d);
    return val;
  }
  
  public void setValue(float v) {
    val = v;
    sVal = val;
    eVal = val;
  }
  
  public void setEaseByFactor(float fac, float x){
    //duration = dur;
    tStart = x;
    tEnd = tStart + duration;
    sVal = val;
    eVal *= fac;
    println("new target: " + eVal);
  }
  
  public void setEaseByTarget(float targ, float x){
    //duration = dur;
    tStart = x;
    tEnd = tStart + duration;
    sVal = val;
    eVal = targ;
    println("new target: " + eVal);
  }
  
  public void setEaseMode(int mode){
    easeMode = mode;
  }
  
  public void pause(){
    paused = true;
  }
  
  public void unPause() {
    paused = false;
  }
  
}
