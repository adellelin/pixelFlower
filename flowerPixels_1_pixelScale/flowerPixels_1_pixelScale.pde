
import processing.video.*;
Movie myMovie;
Movie myMovie2;
int videoScale = 5;
int cols, rows;
float pointillize = 2;
int movX;
int movY;

void setup() {
  size(1280, 780);
  myMovie = new Movie(this, "bloomHD_C.mp4");
  //myMovie2 = new Movie
  myMovie.loop();
  frameRate(20);
  myMovie.speed(2.0); 
  movX = myMovie.width;
  movY = myMovie.height;
}


void movieEvent(Movie m) {
  m.read();
}

void draw() {
  //// scale of pixels here. To replace with biosensing data
  //videoScale = 8;
  videoScale = updateFlatScaleUpAndDown();
  background(0);
  
  //// if just want movie to play
  //image(myMovie, 0, 0);
  
  //movieScrubber();

  myMovie.loadPixels();
/*
  if (myMovie.available()) {
    myMovie.read();
  }*/

  scrubIndicator();
  drawMoviePixels();
  //drawGridBrightness();

  //adjustBrightness();
  
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
      //stroke(0);
      ellipse(i, j, videoScale, videoScale);
    }
  }
}

void drawGridBrightness() {
  // Begin loop for columns
  for (int i = 0; i < movX; i +=videoScale) {
    // Begin loop for rows
    for (int j = 0; j < movY; j +=videoScale) {

      // Reversing x to mirror the image
      // In order to mirror the image, the column is reversed with the following formula:
      // mirrored column = width - column - 1
      //int loc = (myMovie.width - i - 1) + j*myMovie.width;
      int loc = i + j * myMovie.width;

      // Each rect is colored white with a size determined by brightness
      color c = myMovie.pixels[loc];

      // A rectangle size is calculated as a function of the pixel's brightness. 
      // A bright pixel is a large rectangle, and a dark pixel is a small one.
      float sz = (brightness(c)/255)*videoScale; 
      rectMode(CENTER);
      fill(255);
      noStroke();
      rect(i + videoScale/2, j + videoScale/2, sz, sz);
    }
  }
}
void adjustBrightness() {
  loadPixels();
  for (int x = 0; x < myMovie.width; x++) {
    for (int y = 0; y < myMovie.height; y++) {

      // Calculate the 1D location from a 2D grid
      int loc = x + y * myMovie.width;

      // Get the R,G,B values from image
      float r = red(myMovie.pixels[loc]);
      float g = green(myMovie.pixels[loc]);
      float b = blue(myMovie.pixels[loc]);

      //calc multiplier ranging 0.0-8.0 based on mouseX pos
      float adjustBrightness = ((float) mouseX / myMovie.width) * 4.0;

      // Calculate an amount to change brightness based on proximity to the mouse
      //float d = dist(x, y, mouseX, mouseY);
      //float adjustBrightness = map(d, 0, 100, 4, 0); //the closer to mouse (0) the brighter
      r *= adjustBrightness;
      g *= adjustBrightness;
      b *= adjustBrightness;

      // Constrain RGB to make sure they are within 0-255 color range
      r = constrain(r, 0, 255);
      g = constrain(g, 0, 255);
      b = constrain(b, 0, 255);

      // Make a new color and set pixel in the window
      color c = color(r, g, b);
      pixels[loc] = c; //pixels not myMovie.pixels
    }
  }
  updatePixels();
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
  println(mousePosRatio* myMovie.duration());
}


void mousePressed() {
  float mousePosRatio = mouseX/ (float)width;
  myMovie.jump(mousePosRatio* myMovie.duration());
  println((float)mousePosRatio * myMovie.duration());
}

int updateFlatScaleUp () {
  return (frameCount % 20) + 5;
}

int updateFlatScaleDown () {
  return (20-(frameCount % 20)) + 5;
}


int updateFlatScaleUpAndDown () {
  //int scale = ((int)millis() % 40);
  int scale = (frameCount % 40);
  if (scale < 20) {
    return (20-scale) + 5;
  }
  return (scale - 19) + 5;
}

// todo : convert to milliseconds for smoother transission 
int updateFlatScaleSINE () {

  int speed = 10000;
  int maxScale = 40;
  int minScale = 10;
  int middleScale = (maxScale - minScale) / 2 + minScale;
  int remaining = (millis() % speed);
  float percentCircle = remaining / (float)speed;
  float radians = percentCircle * TWO_PI;
  int scale = (int) (sin(radians) * maxScale/2) + middleScale;
  println( remaining +","+percentCircle+","+radians+","+scale);
  return scale;
}