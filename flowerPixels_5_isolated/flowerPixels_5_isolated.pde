
import processing.video.*;
Movie myMovie;
Movie myMovie2;
int videoScale = 5;
int cols, rows;
int movX;
int movY;

int xstart;
int ystart;
int xend;
int yend;
int centerPtX;
int centerPtY;
int pixelW;

void setup() {
  size(1280, 780);
  myMovie = new Movie(this, "Singleflower_1.mp4");
  myMovie2 = new Movie(this, "Singlerose_1.mp4");

  myMovie.loop();
  myMovie2.loop();
  frameRate(5);
  myMovie.speed(2.0);
  myMovie2.speed(2.0);
  movX = myMovie.width;
  movY = myMovie.height;
}


void movieEvent(Movie m) {
  m.read();
}

void draw() {
  videoScale = 20;
  //videoScale = updateFlatScaleUpAndDown();
  background(0);

  //// if just want movie to play
  //image(myMovie, 0, 0);
  //image(myMovie2, 0, 0);

  //// definiing pixel width here
  pixelW = updateScatterScaleUpAndDown () * videoScale;

  myMovie.loadPixels();
  myMovie2.loadPixels();

  /// effects for movie 1 - flower
  pushMatrix();
  translate(movX/5, movY/6);
  scale(0.8);
  drawMoviePixels();
  popMatrix();
  
  /// effects for movie 2 - rose
  /// can this be the crosshair simulation?
  pushMatrix();
  scale(0.4);
  translate(mouseX, mouseY);
  drawGridBrightness();
  popMatrix();
  //drawEdgeTrace();
  //drawSquare();


  updatePixels();
}


void drawMoviePixels() {
  // Begin loop for columns
  for (int i = 0; i < myMovie2.width; i +=videoScale) {
    // Begin loop for rows
    for (int j = 0; j < myMovie2.height; j +=videoScale) {

      // Looking up the appropriate color in the pixel array
      int loc = i + j * myMovie2.width;
      color c = myMovie2.pixels[loc];
      fill(c);
      noStroke();
      ellipse(i, j, videoScale, videoScale);
    }
  }
}

void drawSquare() {
  for (int i = xstart; i < xend; i +=videoScale) {
    // Begin loop for rows
    for (int j = ystart; j < yend; j +=videoScale) {

      // Looking up the appropriate color in the pixel array
      int loc = i + j * myMovie.width;
      color c = myMovie.pixels[loc];
      fill(c);
    }
  }
  rectMode(CENTER);
  rect(centerPtX, centerPtY, pixelW, pixelW);
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
}

/*
void drawEdgeTrace() {
  // Since we are looking at left neighbors
  // We skip the first column
  for (int i = 0; i < movX; i +=videoScale) {
    // Begin loop for rows
    for (int j = 0; j < movY; j +=videoScale) {
      // Pixel location and color
      int loc = i + j*myMovie2.width;
      color pix = myMovie2.pixels[loc];

      // Pixel to the left location and color
      int leftLoc = (i - 1) + j*myMovie2.width;
      color leftPix = myMovie2.pixels[leftLoc];

      // New color is difference between pixel and left neighbor
      float diff = abs(brightness(pix) - brightness(leftPix));
      
      ///  destination.pixels[loc] = color(diff); 
      
      fill(diff);
      rect(i, j, videoScale, videoScale);
    }
  }
}
*/



// replace framCount with bioSensing data;
int updateScatterScaleUpAndDown () {
  //int scale = ((int)millis() % 21);
  int scale = (frameCount % 31);

  if (scale < 15) {
    return (15 - scale);
  }
  return (scale - 14);
}