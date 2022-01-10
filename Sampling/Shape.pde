class Shape{
  color[] colors = {#4c99c6, #12375b, #98d9d8, #ffffff, #6fa1d1, #497180};
  float x;
  float y;
  
  Shape(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  void display(){
    stroke(colors[(int) random(colors.length)]);
    noFill();
    float n = random(5, 15);
    ArrayList<PVector> points = new ArrayList<PVector>();
    
    float w = random(width/4, 3 * width/4);
    float h = random(height/4, 3 * height/4);
    float x0 = random(-width/6, width - w + width/6);
    float y0 = random(-height/6, height - h + height/6);
    translate(x0 + w/2, y0 + h/2); 
    //let theta = random(TWO_PI);
    //rotate(theta);
    
    for (int i = 0; i < n; i++) {
      points.add(new PVector(random(-w/2, w/2), random(-h/2, h/2)));
    }
    
    for (int i = 0; i < n; i++) {
      strokeWeight(random(1.5));
      beginShape();
      for (PVector p : points) {
        float nzx = noise(p.x, p.y, frameCount + i/20);
        float nzy = noise(p.x, p.y, frameCount + i/20 + 1);
        curveVertex(p.x + (nzx - 1/2)*10, p.y + (nzy - 1/2)*10);
      }
      endShape();
    }
  }
}
