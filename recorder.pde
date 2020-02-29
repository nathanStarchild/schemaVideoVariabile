public class Recorder {
  PApplet app;
  boolean recording;
  int n;
  int count;
  String title;
  int startFrame;
    
  
  
  //Param(PApplet papp, float startVal, Oscillator osc, NoiseLoop nl) {
  Recorder(PApplet papp) {
    recording = false;
    n = 0;
    count = 0;
    app = papp;    
    title = "recorded";
    startFrame = 0;
  }
  
  public void startRecording() {
    count += 1;
    n = 0;
    recording = true;
    startFrame = app.frameCount;
    println("start Recording " + title + "" + count + "/frame" + nf(n, 5) + ".jpg");
  }
  
  public void update() {    
    if (recording) {
      app.saveFrame("" + title + "" + count + "/frame" + nf(n, 5) + ".jpg");
      n++;
    }
    if ( recording && app.frameCount > startFrame + loopFrames) {
      recording = false;
      println("done recording");
    }
  }
}
