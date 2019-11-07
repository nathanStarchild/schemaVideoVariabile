//So many globals....
PFont mono;
ArrayList<Oscillator> oscillators = new ArrayList<Oscillator>();
ArrayList<NoiseLoop> noiseLoops = new ArrayList<NoiseLoop>();
Param rObj, r2Obj, thObj, th2Obj, thRObj, zoomObj, speedObj;
color bgCol;
int frameN = 1;

//Schema Params
int n, n2, m, m2;
float w = 46;
float h = w;
float r = 12;
float r2 = r;
float h2, w2, cdw, cdh, cdw2, cdh2;
float th = PI;
float th2 = PI;
float thR = PI;
float rGap = 2;
float gap = 6;
float gapConst = 3;
float gapConst2 = 3;
float zoom = 2.0;
float speed = 1.0;
int nGon1, nGon2;

OpenSimplexNoise osNoise;

float loopFrames = 30*50;

//Image biz
Palette myPalette;
float heightRatio, widthRatio;
PImage img;
import processing.video.*;
import gab.opencv.*;
Capture video;
OpenCV opencv;
int imgSrc = 0;
int newImgSrc = 0;

int wait = 60;
float flowSteady = 0.5;

//Serial biz
import processing.serial.*; //import the Serial library
Serial myPort;  //the Serial port object
String val;
// since we're doing serial handshaking, 
// we need to check if we've heard from the microcontroller
//but are we?
boolean firstContact = false;

void setup() {
  //bgCol = color(63, 9, 66);
  bgCol = color(0);
  size(620, 620);
  fill(bgCol);
  noStroke();
  frameRate(30);
  myPalette = new Palette();
  myPalette.setPalette(0);
  
  mono = createFont("Ubuntu Mono Bold", 13);
  
  oscillators.add(new Oscillator(this, 6, 90, 2*PI/(loopFrames), 'q', 'a', 'z', true));
  oscillators.add(new Oscillator(this, 6, 60, 2*PI/(loopFrames), 'w', 's', 'x', true));
  oscillators.add(new Oscillator(this, 1, 1, 2 * PI /(loopFrames), 'e', 'd', 'c', false));
  oscillators.add(new Oscillator(this, 1, 1, 2 * PI /(loopFrames), 'r', 'f', 'v', false));
  oscillators.add(new Oscillator(this, 1, 1, 4 * 2 * PI /(loopFrames), 't', 'g', 'b', false));
  oscillators.add(new Oscillator(this, 20, 40, 2*PI/(loopFrames), 'y', 'h', 'n', true));
  oscillators.add(new Oscillator(this, 2, 3, 2*PI/(loopFrames), 'u', 'j', 'm', true));
  
  noiseLoops.add(new NoiseLoop(this, 6, 30, 2, 2*PI/(loopFrames), 'q', 'a', 'Q', 'A', 'z', 0));//r
  noiseLoops.add(new NoiseLoop(this, 6, 30, 2, 0.82*PI/(loopFrames), 'w', 's', 'W', 'S', 'x', 5));//r2
  noiseLoops.add(new NoiseLoop(this, -PI/4, PI/4, 2, 2 * PI /(loopFrames), 'e', 'd', 'E', 'D', 'c', 90));//th
  noiseLoops.add(new NoiseLoop(this, -PI*1.3, PI*1.3, 2, 2 * PI /(loopFrames), 'r', 'f', 'R', 'F', 'v', 92));//th2
  noiseLoops.add(new NoiseLoop(this, -2.0*PI, 2*PI, 1.1, 2 * PI /(loopFrames), 't', 'g', 'T', 'G', 'b', 150));
  noiseLoops.add(new NoiseLoop(this, 0.3, 3, 2, 2*PI/(loopFrames), 'y', 'h', 'Y', 'H', 'n', 180));
  noiseLoops.add(new NoiseLoop(this, 2, 2, 5, 2*PI/(loopFrames), 'u', 'j', 'U', 'J', 'm', 210));
  
  noiseLoops.get(0).unPause();
  noiseLoops.get(1).unPause();
  noiseLoops.get(2).unPause();
  noiseLoops.get(3).unPause();
  noiseLoops.get(4).unPause();
  noiseLoops.get(5).unPause();
  
  
  rObj = new Param(this, r, oscillators.get(0), noiseLoops.get(0));
  r2Obj = new Param(this, r2, oscillators.get(1), noiseLoops.get(1));
  thObj = new Param(this, th, oscillators.get(2), noiseLoops.get(2));
  th2Obj = new Param(this, th2, oscillators.get(3), noiseLoops.get(3));
  thRObj = new Param(this, thR, oscillators.get(4), noiseLoops.get(4));
  zoomObj = new Param(this, zoom, oscillators.get(5), noiseLoops.get(5));
  speedObj = new Param(this, speed, oscillators.get(6), noiseLoops.get(6));
  
  
  rObj.setMode(1);
  r2Obj.setMode(1);
  thObj.setMode(1);
  th2Obj.setMode(1);
  thRObj.setMode(1);
  zoomObj.setMode(1);
    
  nGon1 = 3;        
  nGon2 = 3;
    
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  if (imgSrc == 3) {
    video.start();
    widthRatio = video.width/float(n2);
    heightRatio = video.height/float(m2); 
  }
  if (imgSrc == 1) {
    img = loadImage("testPattern.png");
    widthRatio = img.width/float(n2);
    heightRatio = img.height/float(m2); 
  }
  if (imgSrc == 0) {
    widthRatio = zoom/float(n2);
    heightRatio = zoom/float(m2); 
  }
  
  //myPort = new Serial(this, "/dev/ttyUSB0", 9600);
  //myPort.bufferUntil('\n'); 
  
  osNoise = new OpenSimplexNoise();
}

void draw() {
  //imgSrc = newImgSrc;
  if (imgSrc == 2) {
    //frameN++;
    //img = loadImage("vid" + nf((frameCount)%1125 + 1, 4) + ".jpg");
    boolean exists = false;
    String fName = "";
    while (!exists){
      frameN++;
      fName = "frame" + nf((frameN)%3215 + 1, 4) + ".jpg";
      File f = dataFile(fName);
      exists = f.isFile();
    }
    img = loadImage(fName);
    img.loadPixels();
  }
  if (imgSrc == 3) {
    video.read();
    video.loadPixels();
    calculateFlow();
  }
    
  r = rObj.getValue();
  r2 = r2Obj.getValue();
  th = thObj.getValue();
  th2 = th2Obj.getValue();
  thR = thRObj.getValue();
  zoom = zoomObj.getValue();
  speed = speedObj.getValue();
        
  float rNew = map(r*cos(0*PI/6 + 6*th), r, -r, r, 10*r/12);
  gap = gapConst + (r - rNew);
   
  ////for squares r^2 = 2*w^2
  //w = 2 * sqrt((r*r)/2);
  //h = w;
  //gap = 2 * sqrt((rGap*rGap)/2);
  //for triangles r = w/sqrt(3)
  w = r * sqrt(3);
  h = (sqrt(3)/2)*w;
  w2 = r2 * sqrt(3);
  h2 = (sqrt(3)/2)*w2;

  n = floor(width/(w+gap));
  m = floor(height/(h+gap*(sqrt(3)/2)));
  n -= n % 2 - 2;
  m -= m % 4 - 8;
  n2 = floor(width/(w2+gapConst2));
  m2 = floor(height/(h2+gapConst2*(sqrt(3)/2)));
  n2 -= n2 % 2 - 0;
  m2 -= m2 % 4 - 4;
  
  if (imgSrc == 3) {
    widthRatio = video.width/float(n2);
    heightRatio = video.height/float(m2);
  } else if (imgSrc == 0) {
    widthRatio = zoom*float(n2);
    heightRatio = zoom*float(m2); 
  } else {
    widthRatio = zoom*img.width/float(n2);
    heightRatio = zoom*img.height/float(m2);
  }

  cdw = width - (n * (w+gap));
  cdh = height - (m * (h+gap*(sqrt(3)/2)));
  cdw2 = width - (n2 * (w2+gapConst2));
  cdh2 = height - (m2 * (h2+gapConst2*(sqrt(3)/2)));
  
  background(bgCol);
  pushMatrix();    
  pushMatrix();
  pushStyle();
  stroke(0, 150, 255);
  gap = gapConst2;
  strokeWeight(gap);
  noFill();
  translate(width/2, height/2);
  translate((w2+cdw2+gap-width)/2, (h2/3)+(cdh2+gap*(sqrt(3)/2)-height)/2);
  translate(-w2-gap, 0);
  float nfu = speed*cos(frameCount*2*PI/(loopFrames));
  float nfv = speed*sin(frameCount*2*PI/(loopFrames));
  for (int j = 0; j < m2; j++) {
    pushMatrix();
    if (j%2==0) {
      translate((w2+gap)/2, 0);
    }
    for (int i = 0; i < n2+1; i++) {
      pushStyle();
      color c;
      if (imgSrc == 0) {
        //int cn = int(map(noise(800+(i-n2/2)/zoom, 300+(j-m2/2)/zoom, speed*cos(frameCount*2*PI/(loopFrames))), 0, 1, 0, 256*3));
        int cn = int(map((float)osNoise.eval(800+(i-n2/2)/widthRatio, 300+(j-m2/2)/heightRatio, nfu, nfv), -1, 1, 0, 256*3));
        c = myPalette.getColor(cn%256, 255);
      } else {
        float distFromCenterX = (n2+1)/2.0 - i;
        float distFromCenterY = m2/2.0 - j;
        
        int dfcXIm = floor(heightRatio*distFromCenterX);
        int dfcYIm = floor(heightRatio*distFromCenterY*(sqrt(3)/2));
        
        if (imgSrc == 3) {
          int imX = min(max(video.width/2 - dfcXIm, 0), video.width-1);
          int imY = min(max(video.height/2 - dfcYIm, 0), video.height-1);
          int imIdx = (video.width - imX - 1) + imY * video.width;//mirror the video
          c = video.pixels[imIdx];
        } else {
          int imX = min(max(img.width/2 - dfcXIm, 0), img.width-1);
          int imY = min(max(img.height/2 - dfcYIm, 0), img.height-1);
          int imIdx = imX + imY * img.width;
          c = img.pixels[imIdx];
        }
      }
        
      
      stroke(c);
      float nv = 1 + 4.0*(float)osNoise.eval(800+(i-n2/2)/(2.0*widthRatio), 300+(j-m2/2)/(2.0*heightRatio), nfu, nfv);
      float rs = 1 + 4.0*(float)osNoise.eval(1800+(i-n2/2)/(3.0*widthRatio), 1300+(j-m2/2)/(3.0*heightRatio), nfu, nfv);
      nGon(nGon2, i * (w2+gap), j*(h2+gap*(sqrt(3)/2)) - cos(3*th2)*(h2+gap*(sqrt(3)/2))/6, r2*nv+gap, th2*nv);
      nGon(nGon2, i * (w2+gap) + (w2+gap)/2, j*(h2+gap*(sqrt(3)/2))  - cos(3*(th2+(2*PI/6)))*(h2+gap*(sqrt(3)/2))/6, r2*nv+gap, th2*nv+(2*PI/6));
      
      popStyle();
    }
    popMatrix();
  }

  popStyle();
  popMatrix();
  
  gap = gapConst + (r - rNew);
  pushMatrix();
  
  translate(width/2, height/2);
  rotate(thR);
  translate(-width/2, -height/2);
  translate((w+cdw+gap)/2, (h/3)+(cdh+gap*(sqrt(3)/2))/2);
  translate(-w-gap, 0);
  for (int j = 0; j < m; j++) {
    pushMatrix();
    pushStyle();
    if (j%2==0) {
      //fill(100,0,100);
      translate((w+gap)/2, 0);
    }
    for (int i = 0; i < n+1; i++) {
      //rect(i*(w+gap), j*(h+gap), w, h);
      nGon(nGon1, i * (w+gap), j*(h+gap*(sqrt(3)/2)) - cos(3*th)*(h+gap*(sqrt(3)/2))/6, rNew, th);
      nGon(nGon1, i * (w+gap) + (w+gap)/2, j*(h+gap*(sqrt(3)/2)) - cos(3*(th+(2*PI/6)))*(h+gap*(sqrt(3)/2))/6, rNew, th+(2*PI/6));
    }
    popStyle();
    popMatrix();
  }
  popMatrix();
  popMatrix();
  pushStyle();
  
  pushMatrix();
  pushStyle();
    translate(width/2, height/2);
    noFill();
    stroke(bgCol);
    float sw = sqrt(2*width/2*width/2) - width/2;
    strokeWeight(sw);
    ellipseMode(RADIUS);
    ellipse(0, 0, (width + sw)/2, (height+sw)/2);
  popStyle();
  popMatrix();
  
  pushStyle();
    stroke(255, 50, 50);
    fill(255, 50, 50);
    text(frameRate, 10, 60);
  popStyle();
  
  //saveFrame("dsp/frame####.jpg");

  //if (frameCount >= loopFrames){
  if (frameN >= 3215){
    //exit();
  }
}


void nGon(int n, float x, float y, float r, float thetaInit) {
  pushMatrix();
  translate(x, y);
  beginShape();
  for (int i=0; i<n; i++) {
    float theta = thetaInit + i * 2 * PI / float(n);
    vertex(r*sin(theta), r*cos(theta));
  }
  endShape(CLOSE);
  popMatrix();
}

void switchImgSrc(){
  imgSrc = (imgSrc + 1) % 4;
  if (imgSrc == 3) {
    video.start();
    widthRatio = video.width/float(n2);
    heightRatio = video.height/float(m2); 
  } else if (imgSrc == 0) {
    video.stop();
  } else if (imgSrc == 1) {
    img = loadImage("testPattern.png");
    widthRatio = img.width/float(n2);
    heightRatio = img.height/float(m2); 
  }
  
}

void calculateFlow() {
  opencv.loadImage(video);
  opencv.calculateOpticalFlow();
  PVector aveFlow = opencv.getAverageFlow();
  float tVal = abs(aveFlow.x) + abs(aveFlow.y);
  tVal = round(tVal * 10)/10.0;
  if (tVal > flowSteady) {
    wait = 3;
  }
  if (!(tVal != tVal)){
    if (tVal > flowSteady || 0.04 > flowSteady) {
        println("up " + tVal + ", " + flowSteady);
        flowSteady = lerp(abs(tVal), flowSteady, 0.9);
    } else {
      wait--;
      if (0 >= wait) {
        println("down " + tVal + ", " + flowSteady);
        flowSteady = lerp(abs(tVal), flowSteady, 0.95);
      }
    }
    adjustLoops(abs(flowSteady));  
  }
}

void adjustLoops(float val){
  //th = noiseLoops.get(2).getValue();
  //th2 = noiseLoops.get(3).getValue();
  //thR = noiseLoops.get(4).getValue();
  //r = noiseLoops.get(0).getValue();
  //r2 = noiseLoops.get(1).getValue();
  //zoom = noiseLoops.get(5).getValue();
  //speed = noiseLoops.get(6).getValue();
  
  noiseLoops.get(0).setMax(map(val, 0, 3, 4, 250));
  noiseLoops.get(1).setMax(map(val, 0, 3, 4, 250));
  noiseLoops.get(2).setMin(map(val, 0, 3, -PI/10, -PI/5));
  noiseLoops.get(2).setMax(map(val, 0, 3, PI/10, PI/5));
  noiseLoops.get(3).setMin(map(val, 0, 3, -PI/10, -2*PI));
  noiseLoops.get(3).setMax(map(val, 0, 3, PI/10, 2*PI));
  noiseLoops.get(4).setMin(map(val, 0, 3, -PI/10, -2*PI));
  noiseLoops.get(4).setMax(map(val, 0, 3, PI/10, 2*PI));
  
}

void handleSerial(String val){
  String[] vals = val.split(",");
  for (int i=0; i< vals.length; i++){
    println(vals[i]);
  }
  println();
  rObj.setVal(map(float(vals[1]), 0, 26048, 3, 120));
  r2Obj.setVal(map(float(vals[2]), 0, 26048, 3, 120));
  thRObj.setVal(map(float(vals[3]), 0, 26048, -PI, PI));
}

void keyPressed() {
  switch(key){
    case('q'):
      rObj.setEase(1.1);
      break;
    case('a'):
      rObj.setEase(1 / 1.1);
      break;
    case('Q'):
      rObj.setEase(1.6);
      break;
    case('A'):
      rObj.setEase(1 / 1.6);
      break;
    case('w'):
      r2Obj.setEase(1.1);
      break;
    case('s'):
      r2Obj.setEase(1 / 1.1);
      break;
    case('W'):
      r2Obj.setEase(1.6);
      break;
    case('S'):
      r2Obj.setEase(1 / 1.6);
      break;
    case('e'):
      thObj.setEase(1.1);
      break;
    case('d'):
      thObj.setEase(1 / 1.1);
      break;
    case('E'):
      thObj.setEase(1.6);
      break;
    case('D'):
      thObj.setEase(1 / 1.6);
      break;
    case('r'):
      th2Obj.setEase(1.1);
      break;
    case('f'):
      th2Obj.setEase(1 / 1.1);
      break;
    case('R'):
      th2Obj.setEase(1.6);
      break;
    case('F'):
      th2Obj.setEase(1 / 1.6);
      break;
    case('t'):
      thRObj.setEase(1.1);
      break;
    case('g'):
      thRObj.setEase(1 / 1.1);
      break;
    case('T'):
      thRObj.setEase(1.6);
      break;
    case('G'):
      thRObj.setEase(1 / 1.6);
      break;
    case('y'):
      zoomObj.setEase(1.1);
      break;
    case('h'):
      zoomObj.setEase(1 / 1.1);
      break;
    case('Y'):
      zoomObj.setEase(1.6);
      break;
    case('H'):
      zoomObj.setEase(1 / 1.6);
      break;
    case('u'):
      speedObj.setEase(1.1);
      break;
    case('j'):
      speedObj.setEase(1 / 1.1);
      break;
    case('U'):
      speedObj.setEase(1.6);
      break;
    case('J'):
      speedObj.setEase(1 / 1.6);
      break;
    case('i'):
      nGon1 += 1;
      break;
    case('k'):
      nGon1 = max(nGon1 - 1, 0);
      break;
    case('o'):
      nGon2 += 1;
      break;
    case('l'):
      nGon2 = max(nGon2 - 1, 0);
      break;
    case('z'):
      rObj.switchMode();
      break;
    case('x'):
      r2Obj.switchMode();
      break;
    case('c'):
      thObj.switchMode();
      break;
    case('v'):
      th2Obj.switchMode();
      break;
    case('b'):
      thRObj.switchMode();
      break;
    case('n'):
      zoomObj.switchMode();
      break;
    case('m'):
      speedObj.switchMode();
      break;
    case(' '):
      switchImgSrc();
      break;
  }
}


void mousePressed() {
  myPalette.nextPalette();
}


void serialEvent(Serial myPort) {
  //println("serial Event");
  val = myPort.readStringUntil('\n');
  //make sure our data isn't empty before continuing
  if (val == null) {
    println("null");
    return;
  }
    //trim whitespace and formatting characters (like carriage return)
    val = trim(val);
    //println(val);
  
    if (firstContact) {
      handleSerial(val);
      //println("that val again is: " + val);
      myPort.write("A");
    } else {
      if (val.equals("A")) {
        myPort.clear();
        firstContact = true;
        myPort.write("A");
        println("contact");
      }
    }
}

//void captureEvent(Capture c) {
//  c.read();
//}
