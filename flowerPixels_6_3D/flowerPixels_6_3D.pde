// install this package https://packages.ubuntu.com/trusty/amd64/libgstreamer0.10-0/download
import processing.video.*;
Movie myMovie;
Movie myMovie2;
int videoScale = 5;
int depthScale = 0;
int cols, rows;
float pointillize = 2;
int movX;
int movY;

BlackPixels blackPixels;
BlackPixels purplePixels;

void setup() {
  size(1280, 780, P3D);
  myMovie = new Movie(this, "bloomHD_C.mp4");
  //myMovie2 = new Movie
  myMovie.loop();

  // changes speed of pixels appearing
  frameRate(10);
  myMovie.speed(2.0); 
  movX = myMovie.width;
  movY = myMovie.height;
  blackPixels = new BlackPixels(color(0), 40);
  purplePixels = new BlackPixels(color(200, 0, 200), 40);
}


void movieEvent(Movie m) {
  m.read();
}

void draw() {
  
  /// can either use biosensing data to adjust size of pixels or position on z-Axis
  videoScale = 8;
  depthScale = updateFlatScaleUpAndDown();
  background(0);

  //// if just want movie to play
  //image(myMovie, 0, 0);

  //movieScrubber();
  //blackPixels.display(updateScatterScaleUpAndDown());
  //purplePixels.display(updateScatterScaleUpAndDown());
  //println(updateScatterScaleUpAndDown ());
  myMovie.loadPixels();
  /*
  if (myMovie.available()) {
   myMovie.read();
   }*/

  scrubIndicator();
  drawMoviePixels();

  updatePixels();
}

void drawMoviePixels() {
  // Begin loop for columns
  for (int i = 0; i < movX; i +=videoScale) {
    // Begin loop for rows
    for (int j = 0; j < movY; j +=videoScale) {

      // Looking up the appropriate color in the pixel array
      int loc = i + j * myMovie.width;
      color c = myMovie.pixels[loc];
      fill(c);
      pushMatrix();
      //stroke(255);
      translate(i, j, depthScale * (int) random(-10, 10));
      rotateX(0.4);
      rotateY(1.25);
      rotate(0.5);
      box(videoScale);
      popMatrix();
    }
  }
}


void scrubIndicator() {
  float jumpPoint = myMovie.time()/myMovie.duration();
  fill(200, 0, 50);
  noStroke();
  ellipse(jumpPoint * width, movY + 40, 20, 20);
}

void movieScrubber() {
  float mousePosRatio = mouseX/ (float)width;
  myMovie.jump(mousePosRatio* myMovie.duration());
  //println(mousePosRatio* myMovie.duration());
}


void mousePressed() {
  float mousePosRatio = mouseX/ (float)width;
  myMovie.jump(mousePosRatio* myMovie.duration());
  //println((float)mousePosRatio * myMovie.duration());
}

int updateFlatScaleUp () {
  return (frameCount % 20) + 5;
}

int updateFlatScaleDown () {
  return (20-(frameCount % 20)) + 5;
}


int updateFlatScaleUpAndDown () {
  int scale = (frameCount % 20);
  if (scale < 10) {
    return (10-scale) + 5;
  }
  return (scale) + 5;
}

// replace framCount with bioSensing data;
int updateScatterScaleUpAndDown () {
  //int scale = ((int)millis() % 21);
  int scale = (frameCount % 21);
  println("scale "+scale);
  if (scale < 10) {
    return (10 - scale);
  }
  return (scale - 9);
}
