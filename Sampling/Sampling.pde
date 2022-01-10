ArrayList<Dart> dart;
color[] colors = {#F18C8E, #F0B7A4, #F1D1B5, #568EA6, #305F72};

void setup(){
  background(colors[(int) random(colors.length)]);
  size(500,500);
  pixelDensity(2);
}

void draw(){
  PoissonDisk pdSampling = new PoissonDisk(50);
  ArrayList<Dart> dart = pdSampling.getDarts();
  int count = 0;
  for (Dart d : dart){
    println(count);
    print(d.x, d.y);
    if (random(1) > 0.3){
      noFill();
      stroke(colors[(int) random(colors.length)]);
      strokeWeight(random(4));
      float endx = random(width - d.x);
      float endy = random(height - d.y);
      beginShape();
      curveVertex(d.x,  d.y);
      curveVertex(d.x,  d.x);
      curveVertex(random(d.x - width/2, d.x + width/2), random(d.y - height/2, d.y + height/2));
      curveVertex(random(d.x - width/2, d.x + width/2),  random(d.y - height/2, d.y + height/2));
      curveVertex(d.x, d.y);
      curveVertex(d.x, d.y);
      endShape();
    }
    else {
        fill(colors[(int) random(colors.length)]);
        noStroke();
        
        float size = 10 + randomGaussian() * 5;
        float xCenter = d.x;
        float yCenter = d.y;
        
        circle(d.x , d.y, size);
    
    }
    count++;
  }
  noLoop();
}

void mousePressed() {
  redraw();
}
