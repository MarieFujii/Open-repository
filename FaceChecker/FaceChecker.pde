import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;
import java.util.regex.*;

OpenCV opencv;
Capture capture;

PImage inputPhoto;

Rectangle[] faces;

// Screenshot count
int cnt = 1;

String imageFilePath = "";

void setup() {
  
  opencv = new OpenCV(this, 640, 480);
  
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  
  size(opencv.width, opencv.height);
  
  frameRate(24);

  try {
    selectInput("Select image file:", "fileSelected");
    while (imageFilePath.length() == 0) {
      Thread.sleep(1000);
    }
    inputPhoto = loadImage(imageFilePath);
  }
  catch (Exception e) {
    e.printStackTrace();
    exit();
  }
  
  capture = new Capture(this, width, height);
  
  capture.start();
  
  imageMode(CORNER);
}

void draw() {
  
  if (imageFilePath.length() == 0) {
    return;
  }
  
  opencv.loadImage(capture);

  image(capture, 0, 0);

  noFill();

  Rectangle[] faces = opencv.detect();

  println(faces.length);

  for (int i = 0; i < faces.length; i++) {

    image(inputPhoto, faces[i].x - 10, faces[i].y, faces[i].width + 10, faces[i].height + 10);

  }  
}

void captureEvent(Capture camera) {

  camera.read();

}

void keyPressed() {
 
  if(key == 'p' || key == 'P') {
    // save picture 
    save("screenshot" + cnt++ + ".png");
 
  }
  if(key == 'e' || key == 'E') {
    // end
    exit();
  }
}

void fileSelected(File selection) {
  String result = "";
  
  if (selection != null) {
    result = selection.getAbsolutePath();
    Pattern imageFilePattern = Pattern.compile("\\.(jpg|gif|png)$");
    Matcher imageFileMatcher = imageFilePattern.matcher(result);
    if (imageFileMatcher.find() == false){
      println("not image file: " + result);
      exit();
    }
  }
  else {
    println("not selected.");
    exit();
  }
  
  imageFilePath = result;

}
