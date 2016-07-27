
import processing.video.*;
Movie myMovie;
Movie myMovie2;
int videoScale = 5;
int cols, rows;
float pointillize = 2;
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
  myMovie = new Movie(this, "bloomHD_C.mp4");
  //myMovie2 = new Movie
  myMovie.loop();
  frameRate(30);
  myMovie.speed(2.0); 
  movX = myMovie.width;
  movY = myMovie.height;
}


void movieEvent(Movie m) {
  m.read();
}

void draw() {
  videoScale = 40;
  //videoScale = updateFlatScaleUpAndDown();
  background(0);

  //// if just want movie to play
  image(myMovie, 0, 0);

  //// for fixed starting point (center), the square scales up and down
  //pixelW = updateScatterScaleUpAndDown () * videoScale;
  //centerPtX = myMovie.width/2;
  //centerPtY = myMovie.height/2;
  
  //// for starting point influenced by mouse, can input Biosensing data here
  pixelW = videoScale * 10;
  centerPtX = mouseX;
  centerPtY = mouseY;
  
  xstart = constrain(centerPtX - pixelW/2, 0, myMovie.width); 
  ystart = constrain(centerPtY - pixelW/2, 0, myMovie.height);
  xend = constrain(centerPtX + pixelW/2, 0, myMovie.width);
  yend = constrain(centerPtY + pixelW/2, 0, myMovie.height);
  //println(xstart+ "," + ystart+ "," + xend+ "," + yend);

  //movieScrubber();

  myMovie.loadPixels();
  /*
  if (myMovie.available()) {
   myMovie.read();
   }*/

  scrubIndicator();
  
  //// Either a using a pixel effect or a flat square
  drawMoviePixels();
  //drawSquare();
  
  
  //drawGridBrightness();
  //adjustBrightness();
  //pointilize();
  updatePixels();
}

void drawMoviePixels() {
  // Begin loop for columns
  for (int i = xstart; i < xend; i +=videoScale) {
    // Begin loop for rows
    for (int j = ystart; j < yend; j +=videoScale) {

      // Looking up the appropriate color in the pixel array
      int loc = i + j * myMovie.width;
      color c = myMovie.pixels[loc];
      fill(c);
      //stroke(0);
      rect(i, j, videoScale, videoScale);
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

// replace framCount with bioSensing data;
int updateScatterScaleUpAndDown () {
  //int scale = ((int)millis() % 21);
  int scale = (frameCount % 31);

  if (scale < 15) {
    return (15 - scale);
  }
  return (scale - 14);
}