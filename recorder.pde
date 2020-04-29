public class Recorder {
  PApplet app;
  boolean recording;
  int n;
  int count;
  String title;
  int startFrame;
  int snapCount;
  PGraphics theG;
    
  
  
  //Param(PApplet papp, float startVal, Oscillator osc, NoiseLoop nl) {
  Recorder(PApplet papp, PGraphics pg) {
    recording = false;
    n = 0;
    count = 0;
    app = papp;    
    title = "recorded";
    startFrame = 0;
    theG = pg;
    snapCount = 0;
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
      theG.save("" + title + "" + count + "/frame" + nf(n, 5) + ".jpg");
      n++;
    }
    if ( recording && app.frameCount > startFrame + loopFrames) {
      recording = false;
      println("done recording");
    }
    if ( recording && app.frameCount == startFrame + (loopFrames/2.0)) {
      df = -df;
      println("flipIt");
    }
    if ( recording && app.frameCount == startFrame + (3*loopFrames/4.0)) {
      println("go!");
    }
  }

  public void snapshot() {
    theG.save("snap" + nf(snapCount, 3) + ".jpg" );
    snapCount++;
  }
}
