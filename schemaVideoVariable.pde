//So many globals....
PFont mono;
ArrayList<Oscillator> oscillators = new ArrayList<Oscillator>();
ArrayList<NoiseLoop> noiseLoops = new ArrayList<NoiseLoop>();
ArrayList<String> commands = new ArrayList<String>();
Param rObj, r2Obj, thObj, th2Obj, thRObj, zoomObj, speedObj;
Param cMap, th2Distort, r2Distort, r2SpeedObj, th2SpeedObj, imZoomObj;
Recorder myRecorder;
color bgCol;
int frameN = 1;
int frameLast = 0;
boolean showData = true;
boolean fillOn = true;
boolean frameOn;
int shiftX = 0;
int shiftY = 0;

boolean live = false;

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
float imZoom = 2.0;
float speed = 1.0;
int nGon1, nGon2;
int lastActivateButton = 0;
int lastModeButtons = 0;
int mode;

OpenSimplexNoise osNoise;

int vidFrames = 676;
int loopFrames = 100*30;
int df = 1;


//Image biz
Palette myPalette;
float heightRatio, widthRatio, imRatio;
PImage img;
import processing.video.*;
import gab.opencv.*;
Capture video;
OpenCV opencv;
int imgSrc = 2;
int newImgSrc = 0;

int wait = 60;
float flowSteady = 0.5;
float oldR = 1;
boolean shrinking = false;

//Serial biz
import processing.serial.*; //import the Serial library
Serial myPort;  //the Serial port object
String val;
// since we're doing serial handshaking, 
// we need to check if we've heard from the microcontroller
//but are we?
//boolean firstContact = false;

void setup() {
  //bgCol = color(63, 9, 66);
  bgCol = color(0);
  size(864, 1080);
  fill(bgCol);
  noStroke();
  frameRate(30);
  myPalette = new Palette();
  myPalette.setPalette(0);
  
  setMode(0);
  
  myRecorder = new Recorder(this);
  //myRecorder.startRecording();
  
  mono = createFont("Ubuntu Mono Bold", 13);  
    
  video = new Capture(this, 640/2, 480/2);
  opencv = new OpenCV(this, 640/2, 480/2);
  if (imgSrc == 3) {
    video.start();
    widthRatio = video.width/float(n2);
    heightRatio = video.height/float(m2); 
  }
  //if (imgSrc == 1) {
    img = loadImage("Walter_Benjamin.jpg");
    widthRatio = img.width/float(n2);
    heightRatio = img.height/float(m2); 
  //}
  if (imgSrc == 0) {
    widthRatio = zoom/float(n2);
    heightRatio = zoom/float(m2); 
  }
  
  //myPort = new Serial(this, "/dev/ttyUSB0", 9600);
  //myPort.bufferUntil('\n'); 
  //myPort.write("A");
  
  osNoise = new OpenSimplexNoise();
  commands.add("");
  commands.add("");
  commands.add("");
  commands.add("");
}

void draw() {
  int now = millis();
  if (imgSrc == 2) {
    //boolean exists = false;
    String fName = "";
    //while (!exists){
      //frameN += (now - frameLast)*30/1000;
      //fName = "rame" + nf((frameN)%3215 + 1, 4) + ".jpg";
      fName = "photos/vid/frame" + nf(frameN, 4) + ".jpg";
      //File f = dataFile(fName);
      //exists = f.isFile();
       frameN += df;
       if (frameN == 1 || frameN == vidFrames) {
         df *= -1;
       }
    //}
    img = loadImage(fName);
    img.loadPixels();
  }
  if (imgSrc == 3) {
    video.read();
    video.loadPixels();
    calculateFlow();
  } 
  
  updateParams();
        
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
    widthRatio = zoom*video.width/float(n2);
    heightRatio = zoom*video.height/float(m2);
    imRatio = imZoom*video.height/float(m2);
  } else if (imgSrc == 0) {
    widthRatio = zoom*float(n2);
    heightRatio = zoom*float(m2); 
    imZoom = heightRatio;
  } else {
    widthRatio = zoom*img.width/float(n2);
    heightRatio = zoom*img.height/float(m2);
    imRatio = imZoom*img.height/float(m2);
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
        for (int j = 0; j < m2; j++) {
          pushMatrix();
            if (j%2==0) {
              translate((w2+gap)/2, 0);
            }
            float y1 = j*(h2+gap*(sqrt(3)/2)) - cos(3*th2)*(h2+gap*(sqrt(3)/2))/6;
            float y2 = j*(h2+gap*(sqrt(3)/2))  - cos(3*(th2+(2*PI/6)))*(h2+gap*(sqrt(3)/2))/6;
            for (int i = 0; i < n2+1; i++) {
              float x1 = i * (w2+gap);
              float x2 = i * (w2+gap) + (w2+gap)/2;
              color c;
              float distFromCenterX = x1 - ((width-cdw2)/2.0);
              float distFromCenterY = y1 - ((height-cdh2)/2.0);
              if (imgSrc == 0) {
                int cn = (int)cMap.getValue(800+ distFromCenterX / zoom, 300 + distFromCenterY / zoom);
                c = myPalette.getColor(cn%256, 255);
              } else {
                int dfcXIm = floor(shiftX + (distFromCenterX)/imZoom);
                int dfcYIm = floor(shiftY + (distFromCenterY)/imZoom);
                
                if (imgSrc == 3) {
                  int imX = min(max(int(video.width/(2) + dfcXIm), 0), video.width-1);
                  int imY = min(max(int(video.height/(2) + dfcYIm), 0), video.height-1);
                  int imIdx = (video.width - imX - 1) + imY * video.width;//mirror the video
                  c = video.pixels[imIdx];
                } else { //<>//
                  int imX = min(max(int(img.width/(2) + dfcXIm), 0), img.width-1); //<>//
                  int imY = min(max(int(img.height/(2) + dfcYIm), 0), img.height-1);
                  int imIdx = imX + imY * img.width;
                  c = img.pixels[imIdx];
                }
              }
                
              stroke(c);
              float nv = th2Distort.getValue(800+ distFromCenterX / zoom, 300 + distFromCenterY / zoom);
              float rs = r2Distort.getValue(800+ distFromCenterX / zoom, 300 + distFromCenterY / zoom);
              nGon(nGon2, x1, y1, r2*rs+gap, th2+(nv*2*PI));
              nGon(nGon2, x2, y2, r2*rs+gap, th2+(nv*2*PI)+(2*PI/6));
            }
          popMatrix();
        }
      popStyle();
    popMatrix();
    
    if (fillOn) {
      gap = gapConst + (r - rNew);
      pushMatrix();
      
        translate(width/2, height/2);
        rotate(thR);
        translate(-width/2, -height/2);
        translate((w+cdw+gap)/2, (h/3)+(cdh+gap*(sqrt(3)/2))/2);
        translate(-w-gap, 0);
        pushStyle();
          fill(bgCol);
          noStroke();
          for (int j = 0; j < m; j++) {
            pushMatrix();
              if (j%2==0) {
                //fill(100,0,100);
                translate((w+gap)/2, 0);
              }
              for (int i = 0; i < n+1; i++) {
                //rect(i*(w+gap), j*(h+gap), w, h);
                nGon(nGon1, i * (w+gap), j*(h+gap*(sqrt(3)/2)) - cos(3*th)*(h+gap*(sqrt(3)/2))/6, rNew, th);
                nGon(nGon1, i * (w+gap) + (w+gap)/2, j*(h+gap*(sqrt(3)/2)) - cos(3*(th+(2*PI/6)))*(h+gap*(sqrt(3)/2))/6, rNew, th+(2*PI/6));
              }
            popMatrix();
          }
        popStyle();
      popMatrix();
    }
  popMatrix();
  
  if (frameOn) {
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
  }
  
  //println(n*m + n2*m2);
  
  if (showData){
    pushStyle();
      stroke(255, 50, 50);
      fill(200, 200, 200);
      text("frameRate = " + nf(frameRate, 0, 2) + ";", 10, 10);
      text("thetaR = " + nf(thR, 0, 2) + ";", 10, 10 + 1 * 12);
      text("theta = " + nf(th, 0, 2) + ";", 10, 10 + 2 * 12);
      text("theta2 = " + nf(th2, 0, 2) + ";", 10, 10 + 3 * 12);
      text("r = " + nf(r, 0, 2) + ";", 10, 10 + 4 * 12);
      text("r2 = " + nf(r2, 0, 2) + ";", 10, 10 + 5 * 12);
      text(commands.get(0), width-150, height - 3 - 3 * 12);
      text(commands.get(1), width-150, height - 3 - 2 * 12);
      text(commands.get(2), width-150, height - 3 - 1 * 12);
      text(commands.get(3), width-150, height - 3 - 0 * 12);
    popStyle();
  }
  
  myRecorder.update();

  frameLast = now;
}

void updateParams() {
  r = rObj.getValue();
  r2 = r2Obj.getValue();
  th = thObj.getValue();
  th2 = th2Obj.getValue();
  thR = thRObj.getValue();
  zoom = zoomObj.getValue();
  imZoom = imZoomObj.getValue();
  //speed = speedObj.getValue();
  cMap.noiseLoop.setRadius(speedObj.getValue());
  r2Distort.noiseLoop.setRadius(r2SpeedObj.getValue());
  th2Distort.noiseLoop.setRadius(th2SpeedObj.getValue());
  if (live) {
    cMap.advanceLive(1);
    r2Distort.advanceLive(1);
    th2Distort.advanceLive(1);
  } else {
    cMap.advance(1);
    r2Distort.advance(1);
    th2Distort.advance(1);
  }
}

void nGon(int n, float x, float y, float r, float thetaInit) {
  beginShape();
  for (int i=0; i<n+1; i++) {
    float theta = thetaInit + i * 2 * PI / float(n);
    vertex(x+r*sin(theta), y+r*cos(theta));
  }
  endShape(); //<>//
}

void switchImgSrc(){
  int imN = (imgSrc + 1) % 4;
  setImgSrc(imN);
}

void setImgSrc(int imN) {
  imgSrc = imN;
  if (imgSrc == 3) {
    video.start();
    widthRatio = video.width/float(n2);
    heightRatio = video.height/float(m2); 
  } else if (imgSrc == 0) {
    video.stop();
  } else if (imgSrc == 1) {
    println("whaddup?"); //<>//
    img = loadImage("Walter_Benjamin.jpg");
    widthRatio = img.width/float(n2);
    heightRatio = img.height/float(m2); 
  } 
}
