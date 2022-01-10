class Dart
{
  
  float x;
  float y;
  int r = 100;
  Cell c = null;
  
  Dart(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  boolean checkOther(Dart d){
    float distance = sqrt(sq(this.x - d.x) + sq(this.y - d.y));
    if (distance < r/2 && distance != 0){
      return false;
    }
    return true;
  }
  
  boolean checkDart(ArrayList<Dart> darts){
    for (Dart other : darts){
      if (!this.checkOther(other)){ return false; }
    }
    return true;
  }
  
  boolean cellOutside(Cell c){
    float rightCirc = this.x + r/2;
    float leftCirc = this.x - r/2;
    float topCirc = this.y - r/2;
    float botCirc = this.y + r/2;
    float rightSq = c.x + c.size;
    float leftSq = c.x;
    float topSq = c.y;
    float botSq = c.y + c.size;
    if (rightSq < rightCirc && leftSq > leftCirc && botSq < botCirc && topSq > topCirc){
      return false;
    }
    return true;
  }
  
  void display(){
    fill(0);
    circle(x,y,4);
  }
  
}
