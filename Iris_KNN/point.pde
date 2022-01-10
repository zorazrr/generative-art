class Point{
  
  int size;
  float[] attributes;
  String target;
  String prediction;
  
  Point(int size){
    this.size = size;
    this.attributes = new float[size];
  }
  
  float getDist(Point other){
    float dist = 0.0;
    for (int i = 0; i < this.size; i++){
      float diff = this.attributes[i] - other.attributes[i];
      dist += sq(diff);
    }
    return sqrt(dist);
  }
  
  void display(float x, float y){
    noStroke();
    if (target.equals(prediction)){fill(0,255,0,127);}
    else {fill(255,0,0,200);}
    circle(x,y,50);
  }
}
