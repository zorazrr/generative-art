/* Author:   Zora Zhang
 Date:     July 9, 2020
 
 Abstract: This sketch produces generative art that imitates the piece
 "Interruption" by Vera Molnar, with some modifications and color changes! 
 Click the sketch to regenerate.
 
 */

/* Global variables */

int horizMargin = 50;             // width of margin on left/right of image
int vertMargin = 50;             // width of margin on top/bottom of image
int space = 10;                  // space between lines
int len = 20;                    // length of the lines
float rotateAngle;                // rotation angle
float threshold = 0.73;            // noise threshold to create holes
color c1 = color(20, 169, 255);    // gradient color #1
color c2 = color(255, 42, 20);      // gradient color #2

void setup() {
  size(600, 600);
  noFill();
  strokeWeight(1);
  pixelDensity(2);
}

void draw() {  
  clear();
  background(0);
  noiseSeed((long) random(100));
  interrupt();
  noLoop();
}

void interrupt() {

  for (int x = horizMargin; x < width - horizMargin; x += space) {
    for (int y = vertMargin; y < height - vertMargin; y += space) {

      // use perlin noise to generate smooth hole patterns
      // Reference: https://www.openprocessing.org/sketch/586226/
      noiseDetail(3, 0.65);
      float noiseVal;
      float noiseScale = 0.01;
      noiseVal = noise(x * noiseScale, y * noiseScale);

      // below threshold: draw the lines 
      if (noiseVal < threshold) {
        pushMatrix();
        translate(x, y + space);
        // gaussian distribution so that most of the rotation angles are not huge
        rotateAngle = randomGaussian() * 0.6;
        rotate(rotateAngle);
        float inter = map(y, 0 , height - vertMargin, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(0, 0, 0, len);
        popMatrix();
      }

      // above threshold: do nothing, leave blank spaces
      else {
      }
    }
  }
}

// click for the sketch to regenerate
// I also tried to make the lines move on mouseDragged(),
// but it did not work out with noLoop()
void mouseClicked() {
  redraw();
}
