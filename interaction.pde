void calculateFlow() {
  opencv.loadImage(video);
  opencv.calculateOpticalFlow();
  PVector aveFlow = opencv.getAverageFlow();
  float tVal = abs(aveFlow.x) + abs(aveFlow.y);
  tVal = round(tVal * 10)/10.0;
  if (tVal > flowSteady) {
    wait = 30;
  }
  if (!(tVal != tVal)){//who would write this condition?
    if (tVal > flowSteady) { //|| 0.04 > flowSteady) {
        println("up " + tVal + ", " + flowSteady);
        flowSteady = lerp(abs(tVal), flowSteady, 0.95);
    } else if (0.04 > flowSteady) {
        flowSteady = lerp(abs(tVal), flowSteady, 0.6);      
    } else {
      wait--;
      if (0 >= wait) {
        println("down " + tVal + ", " + flowSteady);
        flowSteady = lerp(abs(tVal), flowSteady, 0.97);
      }
    }
    adjustLoops(abs(flowSteady));  
  }
}

void adjustLoops(float val){  
  //rObj.setMax(map(val, 0, 3, 4, 250));
  //r2Obj.setMax(map(val, 0, 3, 4, 250));
  //thObj.setMin(map(val, 0, 3, -PI/10, -PI/5));
  //thObj.setMax(map(val, 0, 3, PI/10, PI/5));
  //th2Obj.setMin(map(val, 0, 3, -PI/10, -2*PI));
  //th2Obj.setMax(map(val, 0, 3, PI/10, 2*PI));
  //thRObj.setMin(map(val, 0, 3, -PI/10, -2*PI));
  //thRObj.setMax(map(val, 0, 3, PI/10, 2*PI));
  
  //if (mode == 1) {
    r2Distort.setMax(map(val, 0.1, 3, 1, 6));
    th2Distort.setMax(map(val, 0.1, 3, 0, 6));
    r2Distort.setMin(map(val, 0.1, 3, 1, -2));
    th2Distort.setMin(map(val, 0.1, 3, 0, -5));
    if (val < 0.2 && !shrinking) {
      shrinking = true;
      oldR = r2Obj.easer.eVal;
      r2Obj.easer.setEaseMode(3);
      r2Obj.easer.duration = r2Obj.increment * 200;
      r2Obj.setEaseByTarget(oldR/1.8);
    }
    if (val >= 0.8 && shrinking) {
      shrinking = false;
      r2Obj.easer.setEaseMode(3);
      r2Obj.easer.duration = r2Obj.increment * 120;
      r2Obj.setEaseByTarget(oldR);
    }
  //}
  
}

void handleSerial(String val){
  newCommand("handleSerial(" + val + ");"); 
  String[] vals = val.split(",");
  for (int i=0; i< vals.length; i++){
    println(vals[i]);
  }
  println();
  int activateButton =  (int(vals[0]) >> 4) & 0xff;
  int modeButtons = int(vals[0]) & 0xf;
  
  if (activateButton != lastActivateButton) { //on press
    if (activateButton == 1){
      println("Activate!");  
      switchImgSrc();
      newCommand("setImageSource("+imgSrc+");");
    }
    lastActivateButton = activateButton;
  }
  
  if (modeButtons != lastModeButtons){
    println("new mode: " + modeButtons);
    setMode(modeButtons);
    newCommand("setMode(" + modeButtons + ");");
    lastModeButtons = modeButtons;
  }
  
  
  
  //rObj.setVal(map(float(vals[1]), 0, 53, 3, 120));
  //r2Obj.setVal(map(float(vals[2]), 0, 53, 3, 120));
  //thRObj.setVal(map(float(vals[3]), 0, 5, -PI, PI));
  if (mode <= 1) {
    rObj.setEaseByTarget(map(float(vals[1]), 0, 53, 3, 120));
    r2Obj.setEaseByTarget(map(float(vals[2]), 0, 53, 3, 120));
    thRObj.setEaseByTarget(map(float(vals[3]), 0, 5, -PI, PI));
  } else if (mode == 2) {
    zoomObj.setEaseByTarget(map(float(vals[1]), 0, 53, 0.1, 10));
    //speedObj.setEaseByTarget(map(float(vals[2]), 0, 53, 0.1, 3));
    float myNewInc = map(float(vals[2]), 0, 53, 2*PI/(24*loopFrames), 2*2*PI/(loopFrames));
    cMap.increment = myNewInc;
    r2Distort.increment = myNewInc;
    th2Distort.increment = myNewInc;
  } else if (mode == 3) {
    rObj.setEaseByTarget(map(float(vals[1]), 0, 53, 3, 120));
    r2Obj.setEaseByTarget(map(float(vals[1]), 0, 53, 3, 120));
    float myNewInc = map(float(vals[2]), 0, 53, 2*PI/(12*loopFrames), 9*2*PI/(loopFrames));
    thRObj.increment = myNewInc;
    int newNGonVal = int(map(float(vals[3]), 0, 5, 3, 10));
    nGon1 = newNGonVal;
    nGon2 = newNGonVal;
  } else if (mode == 4) {
    zoomObj.setEaseByTarget(map(float(vals[1]), 0, 53, 0.1, 4));
    float di = map(float(vals[2]), 0, 53, 1, 20);
    r2Distort.setMax(1 + di);
    r2Distort.setMin(1 - di);
    //r2Distort.setMax(map(float(vals[2]), 0, 53, 0.2, 5));
  } else if (mode == 5) {
    float di1 = map(float(vals[1]), 0, 53, 0, PI);
    float di2 = map(float(vals[2]), 0, 53, 0, PI);
    thObj.setMax(2*PI+di1);
    thObj.setMin(2*PI - di1);
    th2Obj.setMax(2*PI+di2);
    th2Obj.setMin(2*PI - di2);
    //r2Distort.setMax(map(float(vals[2]), 0, 53, 0.2, 5));
    rObj.setEaseByTarget(map(float(vals[3]), 0, 5, 17, 2));
    r2Obj.setEaseByTarget(map(float(vals[3]), 0, 5, 17, 2));
  } else if (mode == 6) {
    println("setting palette to: " + floor(map(float(vals[1]), 0, 53, 0, 25)));
    myPalette.setPalette(floor(map(float(vals[1]), 0, 53, 0, 25)));
    //speedObj.setEaseByTarget(map(float(vals[2]), 0, 53, 0.1, 3));
    //float myNewInc = map(float(vals[2]), 0, 53, 2*PI/(24*loopFrames), 2*2*PI/(loopFrames));
    //cMap.increment = myNewInc;
    //r2Distort.increment = myNewInc;
    //th2Distort.increment = myNewInc;
    zoomObj.setEaseByTarget(map(float(vals[2]), 0, 53, 0.1, 10));
  } else if (mode == 7) {
    //float newMax = map(float(vals[1]), 0, 53, 20, 90);
    //float newMin = map(float(vals[2]), 0, 53, 2, 10);
    //rObj.setMax(newMax);
    //rObj.setMin(newMin);
    //r2Obj.setMax(newMax);
    //r2Obj.setMin(newMin);
    nGon1 = floor(map(float(vals[1]), 0, 53, 3, 16));
    nGon2 = floor(map(float(vals[2]), 0, 53, 3, 16));
  }
}

void setMode(int n){
  switch(n%8){
    case(0):
      mode = 0;
      myPalette.setPalette(0);  
      setImgSrc(2);
      
      rObj = new Param(6, 60, 2*PI/loopFrames, new NoiseLoop(2.0, 0.0, 0.0));
      r2Obj = new Param(3, 90, 2*PI/loopFrames, new NoiseLoop(2.0, 5.0, 0.0));
      thObj = new Param(2*PI-PI/4., 2*PI+PI/4., 2*PI/loopFrames, new NoiseLoop(2.0, 90.0, 0.0));
      th2Obj = new Param(2*PI-PI*1.3, 2*PI+PI*1.3, 2*PI/loopFrames, new NoiseLoop(2.0, 92.0, 0.0));
      thRObj = new Param(2*PI-2.0*PI, 2*PI+2*PI, 2*PI/loopFrames, new NoiseLoop(2.0, 150.0, 0.0));
      zoomObj = new Param(200, 400, 2*PI/loopFrames, new NoiseLoop(2.0, 180.0, 0.0));
      speedObj = new Param(loopFrames/300, loopFrames/300, 2*PI/loopFrames, new NoiseLoop(2.0, 200.0, 0.0));
      cMap = new Param(0, 256*3, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 1100.0));
      r2Distort = new Param(-0.5, 2.5, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 1100.0));
      r2SpeedObj = new Param(loopFrames/300, loopFrames/300, 2*PI/loopFrames, new NoiseLoop(2.0, 200.0, 0.0));
      th2Distort = new Param(1/8.,(1/8.) + 2/3., 2*PI/loopFrames, new NoiseLoop(4., 200.0, 1100.0));
      th2SpeedObj = new Param(loopFrames/300, loopFrames/300, 2*PI/loopFrames, new NoiseLoop(2.0, 200.0, 0.0));
      imZoomObj = new Param(0.2, 5, 2*PI/loopFrames, new NoiseLoop(2.0, 180.0, 0.0));
      
      rObj.setMode(0);
      r2Obj.setMode(0);
      thObj.setMode(0);
      th2Obj.setMode(0);
      thRObj.setMode(0);
      zoomObj.setMode(0);
      r2SpeedObj.setMode(0);
      th2SpeedObj.setMode(0);
      imZoomObj.setMode(0);
      r2Obj.easer.duration = r2Obj.increment * 10;
      imZoomObj.easer.duration = imZoomObj.increment * 10;
      
      
      cMap.pause();
      r2Distort.pause();
      th2Distort.pause();
        
      nGon1 = 3;        
      nGon2 = 3;
      break;
      
    case(1):
      mode = 1;
      setImgSrc(3);
      
      rObj = new Param(6, 60, 2*PI/loopFrames, new NoiseLoop(2.0, 0.0, 0.0));
      r2Obj = new Param(6, 60, 2*PI/loopFrames, new NoiseLoop(2.0, 5.0, 0.0));
      thObj = new Param(2*PI-PI/4., 2*PI+PI/4., 2*PI/loopFrames, new NoiseLoop(2.0, 90.0, 0.0));
      th2Obj = new Param(2*PI-PI*1.3, 2*PI+PI*1.3, 2*PI/loopFrames, new NoiseLoop(2.0, 92.0, 0.0));
      thRObj = new Param(2*PI-2.0*PI, 2*PI+2*PI, 2*PI/loopFrames, new NoiseLoop(2.0, 150.0, 0.0));
      zoomObj = new Param(0.2, 5, 2*PI/loopFrames, new NoiseLoop(2.0, 180.0, 0.0));
      speedObj = new Param(0.5, 1.5, 2*PI/loopFrames, new NoiseLoop(2.0, 200.0, 0.0));
      cMap = new Param(0, 256*3, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 10.0));
      r2Distort = new Param(0, 2, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 10.0));
      th2Distort = new Param(0, 2, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 10.0));
      
      rObj.setMode(0);
      r2Obj.setMode(0);
      thObj.setMode(0);
      th2Obj.setMode(0);
      thRObj.setMode(0);
      zoomObj.setMode(0);
      
      cMap.pause();
      r2Distort.pause();
      th2Distort.pause();
        
      nGon1 = 3;        
      nGon2 = 3;
      break;
      
    case(2):
      mode = 2;
      setImgSrc(0);
      
      rObj = new Param(1, 5, 2*PI/loopFrames, new NoiseLoop(2.0, 0.0, 0.0));
      r2Obj = new Param(6, 60, 2*PI/loopFrames, new NoiseLoop(2.0, 0.0, 0.0));
      thObj = new Param(2*PI-PI/4., 2*PI+PI/4., 2*PI/loopFrames, new NoiseLoop(2.0, 90.0, 0.0));
      th2Obj = new Param(2*PI-PI*1.3, 2*PI+PI*1.3, 2*PI/loopFrames, new NoiseLoop(2.0, 92.0, 0.0));
      thRObj = new Param(2*PI-2.0*PI, 2*PI+2*PI, 2*PI/loopFrames, new NoiseLoop(2.0, 150.0, 0.0));
      zoomObj = new Param(0.2, 5, 2*PI/loopFrames, new NoiseLoop(2.0, 180.0, 0.0));
      speedObj = new Param(0.5, 1.5, 2*PI/loopFrames, new NoiseLoop(2.0, 200.0, 0.0));
      cMap = new Param(0, 256*3, 2*PI/(4*loopFrames), new NoiseLoop(4., 200.0, 10.0));
      r2Distort = new Param(0.5, 1.5, 2*PI/(4*loopFrames), new NoiseLoop(4., 200.0, 10.0));
      th2Distort = new Param(0.5, 1.5, 2*PI/(4*loopFrames), new NoiseLoop(4., 200.0, 10.0));
      
      rObj.setMode(1);
      r2Obj.setMode(1);
      thObj.setMode(0);
      th2Obj.setMode(0);
      thRObj.setMode(3);
      zoomObj.setMode(0);
      zoomObj.easer.duration = zoomObj.increment * 10;
      
      cMap.pause();
      r2Distort.pause();
      th2Distort.pause();
        
      nGon1 = 6;        
      nGon2 = 6;
      break;
      
    case(3):
      mode = 3;
      setImgSrc(1);
      
      rObj = new Param(6, 60, 2*PI/loopFrames, new NoiseLoop(2.0, 0.0, 0.0));
      r2Obj = new Param(6, 60, 2*PI/loopFrames, new NoiseLoop(2.0, 5.0, 0.0));
      thObj = new Param(2*PI-PI/4., 2*PI+PI/4., 2*PI/(2*loopFrames), new NoiseLoop(3.0, 90.0, 0.0));
      th2Obj = new Param(2*PI-PI*1.3, 2*PI+PI*1.3, 2*PI/(4*loopFrames), new NoiseLoop(4.0, 92.0, 0.0));
      thRObj = new Param(2*PI-2.0*PI, 2*PI+2*PI, 2*PI/(loopFrames), new NoiseLoop(4.0, 150.0, 0.0));
      zoomObj = new Param(0.2, 5, 2*PI/loopFrames, new NoiseLoop(2.0, 180.0, 0.0));
      speedObj = new Param(0.5, 1.5, 2*PI/loopFrames, new NoiseLoop(2.0, 200.0, 0.0));
      cMap = new Param(0, 256*3, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 10.0));
      r2Distort = new Param(1, 1, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 10.0));
      th2Distort = new Param(1, 1, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 10.0));
      
      rObj.setMode(0);
      r2Obj.setMode(0);
      r2Obj.easer.duration = r2Obj.easer.duration * 1.9;
      thObj.setMode(1);
      th2Obj.setMode(1);
      thRObj.setMode(3);
      zoomObj.setMode(0);
      zoomObj.setEaseByTarget(1.1);
      
      cMap.pause();
      r2Distort.pause();
      th2Distort.pause();
        
      nGon1 = 3;        
      nGon2 = 3;
      break;
      
    case(4):
      mode = 4;
      setImgSrc(2);
      
      rObj = new Param(2, 20, 2*PI/loopFrames, new NoiseLoop(2.0, 0.0, 0.0));
      r2Obj = new Param(2, 20, 2*PI/loopFrames, new NoiseLoop(2.0, 0.5, 0.0));
      thObj = new Param(2*PI-PI/4., 2*PI+PI/4., 2*PI/(2*loopFrames), new NoiseLoop(3.0, 90.0, 0.0));
      th2Obj = new Param(2*PI-PI*1.3, 2*PI+PI*1.3, 2*PI/(4*loopFrames), new NoiseLoop(4.0, 92.0, 0.0));
      thRObj = new Param(2*PI-2.0*PI, 2*PI+2*PI, 2*PI/(loopFrames), new NoiseLoop(4.0, 150.0, 0.0));
      zoomObj = new Param(0.2, 5, 2*PI/loopFrames, new NoiseLoop(2.0, 180.0, 0.0));
      speedObj = new Param(0.5, 1.5, 2*PI/loopFrames, new NoiseLoop(2.0, 200.0, 0.0));
      cMap = new Param(0, 256*3, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 10.0));
      r2Distort = new Param(0.1, 1.9, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 10.0));
      th2Distort = new Param(1, 1, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 10.0));
      
      rObj.setMode(1);
      r2Obj.setMode(1);
      r2Obj.easer.duration = r2Obj.easer.duration * 1.9;
      thObj.setMode(3);
      th2Obj.setMode(3);
      thRObj.setMode(3);
      zoomObj.setMode(0);
      zoomObj.setEaseByTarget(1.1);
      
      cMap.pause();
      r2Distort.pause();
      th2Distort.pause();
        
      nGon1 = 4;        
      nGon2 = 4;
      break;
      
    case(5):
      mode = 5;
      setImgSrc(3);
      
      rObj = new Param(4, 30, 2*PI/loopFrames, new NoiseLoop(2.0, 0.0, 0.0));
      r2Obj = new Param(4, 30, 2*PI/(3*loopFrames), new NoiseLoop(2.0, 0.5, 0.0));
      thObj = new Param(2*PI-PI/4., 2*PI+PI/4., 2*PI/(4*loopFrames), new NoiseLoop(3.0, 90.0, 0.0));
      th2Obj = new Param(2*PI-PI/6., 2*PI+PI/6.0, 2*PI/(4*loopFrames), new NoiseLoop(4.0, 92.0, 0.0));
      thRObj = new Param(2*PI-2.0*PI, 2*PI+2*PI, 2*PI/(loopFrames), new NoiseLoop(4.0, 150.0, 0.0));
      zoomObj = new Param(0.2, 5, 2*PI/loopFrames, new NoiseLoop(2.0, 180.0, 0.0));
      speedObj = new Param(0.5, 1.5, 2*PI/loopFrames, new NoiseLoop(2.0, 200.0, 0.0));
      cMap = new Param(0, 256*3, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 10.0));
      r2Distort = new Param(0.1, 1.9, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 10.0));
      th2Distort = new Param(1, 1, 2*PI/loopFrames, new NoiseLoop(4., 200.0, 10.0));
      
      rObj.setMode(0);
      r2Obj.setMode(0);
      thObj.setMode(2);
      th2Obj.setMode(2);
      thRObj.setMode(3);
      zoomObj.setMode(0);
      zoomObj.setEaseByTarget(1.1);
      
      cMap.pause();
      r2Distort.pause();
      th2Distort.pause();
        
      nGon1 = 3;        
      nGon2 = 3;
      break;
      
    case(6):
      mode = 6;
      setImgSrc(0);
      
      rObj = new Param(1, 5, 2*PI/loopFrames, new NoiseLoop(2.0, 0.0, 0.0));
      r2Obj = new Param(6, 60, 2*PI/loopFrames, new NoiseLoop(2.0, 0.0, 0.0));
      thObj = new Param(2*PI-PI/4., 2*PI+PI/4., 2*PI/loopFrames, new NoiseLoop(2.0, 90.0, 0.0));
      th2Obj = new Param(2*PI-PI*1.3, 2*PI+PI*1.3, 2*PI/loopFrames, new NoiseLoop(2.0, 92.0, 0.0));
      thRObj = new Param(2*PI-2.0*PI, 2*PI+2*PI, 2*PI/loopFrames, new NoiseLoop(2.0, 150.0, 0.0));
      zoomObj = new Param(0.2, 5, 2*PI/loopFrames, new NoiseLoop(2.0, 180.0, 0.0));
      speedObj = new Param(0.5, 1.5, 2*PI/loopFrames, new NoiseLoop(2.0, 200.0, 0.0));
      cMap = new Param(0, 256*3, 2*PI/(4*loopFrames), new NoiseLoop(4., 200.0, 10.0));
      r2Distort = new Param(0.5, 1.5, 2*PI/(4*loopFrames), new NoiseLoop(4., 200.0, 10.0));
      th2Distort = new Param(0.5, 1.5, 2*PI/(4*loopFrames), new NoiseLoop(4., 200.0, 10.0));
      
      rObj.setMode(1);
      r2Obj.setMode(1);
      thObj.setMode(0);
      th2Obj.setMode(0);
      thRObj.setMode(3);
      zoomObj.setMode(0);
      zoomObj.easer.duration = zoomObj.increment * 10;
      
      cMap.pause();
      r2Distort.pause();
      th2Distort.pause();
        
      nGon1 = 12;        
      nGon2 = 12;
      break;
      
    case(7):
      mode = 7;
      setImgSrc(0);
      myPalette.setPalette(10);  
      
      rObj = new Param(5, 20, 2*PI/(4*loopFrames), new NoiseLoop(2.0, 0.0, 0.0));
      r2Obj = new Param(5, 20, 2*PI/(2*loopFrames), new NoiseLoop(2.0, 0.0, 0.0));
      thObj = new Param(2*PI-PI/4., 2*PI+PI/4., 2*PI/loopFrames, new NoiseLoop(2.0, 90.0, 0.0));
      th2Obj = new Param(2*PI-PI*1.3, 2*PI+PI*1.3, 2*PI/loopFrames, new NoiseLoop(2.0, 92.0, 0.0));
      thRObj = new Param(2*PI-2.0*PI, 2*PI+2*PI, 2*PI/loopFrames, new NoiseLoop(2.0, 150.0, 0.0));
      zoomObj = new Param(10, 11, 2*PI/loopFrames, new NoiseLoop(2.0, 180.0, 0.0));
      speedObj = new Param(0.5, 1.5, 2*PI/loopFrames, new NoiseLoop(2.0, 200.0, 0.0));
      cMap = new Param(0, 256*3, 2*PI/(14*loopFrames), new NoiseLoop(4., 200.0, 10.0));
      r2Distort = new Param(1, 1, 2*PI/(4*loopFrames), new NoiseLoop(4., 200.0, 10.0));
      th2Distort = new Param(1, 1, 2*PI/(4*loopFrames), new NoiseLoop(4., 200.0, 10.0));
      
      rObj.setMode(1);
      r2Obj.setMode(1);
      thObj.setMode(0);
      th2Obj.setMode(0);
      thRObj.setMode(3);
      zoomObj.setMode(0);
      zoomObj.easer.duration = zoomObj.increment * 10;
      
      cMap.pause();
      r2Distort.pause();
      th2Distort.pause();
        
      nGon1 = 3;        
      nGon2 = 3;
      break;
  }
}

void newCommand(String com){
  println(com);
  commands.add(com);
  commands.remove(0);
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
  
    //if (firstContact) {
      handleSerial(val);
      //println("that val again is: " + val);
      myPort.write("A");
    //} else {
    //  if (val.equals("A")) {
    //    myPort.clear();
    //    firstContact = true;
    //    myPort.write("A");
    //    println("contact");
    //  }
    //}
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
      r2SpeedObj.setEase(1.1);
      break;
    case('k'):
      r2SpeedObj.setEase(1 / 1.1);
      break;
    case('I'):
      r2SpeedObj.setEase(1.6);
      break;
    case('K'):
      r2SpeedObj.setEase(1 / 1.6);
      break;
    case('o'):
      th2SpeedObj.setEase(1.1);
      break;
    case('l'):
      th2SpeedObj.setEase(1 / 1.1);
      break;
    case('O'):
      th2SpeedObj.setEase(1.6);
      break;
    case('L'):
      th2SpeedObj.setEase(1 / 1.6);
      break;
    case('}'):
      nGon1 += 1;
      break;
    case('{'):
      nGon1 = max(nGon1 - 1, 0);
      break;
    case(']'):
      nGon2 += 1;
      break;
    case('['):
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
    case('.'):
      imZoomObj.setEase(1.1);
      break;
    case(','):
      imZoomObj.setEase(1 / 1.1);
      break;
    case('>'):
      imZoomObj.setEase(1.6);
      break;
    case('<'):
      imZoomObj.setEase(1 / 1.6);
      break;
    case ('+'):
      setMode(mode + 1);
      break;
    case('-'):
      myRecorder.startRecording();
      frameN = 1;
      df = 1;
      break;
    case(' '):
      switchImgSrc();
      //showData = !showData;
      //myRecorder.startRecording();
      break;
    case('/'):
      fillOn = !fillOn;
      break;
    case('?'):
      frameOn = !frameOn;
      break;
    case('|'):
      showData = !showData;
      break;
  }
  if (key == CODED) {
    if (keyCode == DOWN) {
      shiftY += 10;
    } else if (keyCode == UP) {
      shiftY -= 10;
    } else if (keyCode == RIGHT) {
      shiftX += 10;
    } else if (keyCode == LEFT) {
      shiftX -= 10;
    } 
  }
}

void mousePressed() {
  myPalette.nextPalette();
}
