class Cell{
  
  float x;
  float y;
  float size;
  PVector cord;
  Dart d = null;
  
  Cell(float x, float y , PVector cord, float s)
  {
      this.x = x;
      this.y = y;
      this.size = s;
      this.cord = cord;
  }
  
  ArrayList<Cell> splitCell(){
    ArrayList<Cell> holder = new ArrayList<Cell>();
    holder.add(new Cell(x, y, cord, size/2));
    holder.add(new Cell(x + size/2, y, cord, size/2));
    holder.add(new Cell(x, y + size/2, cord, size/2));
    holder.add(new Cell(x + size/2, y + size/2, cord, size/2));
    return holder;
  }
  
  ArrayList<Cell> matchCord(PVector p, ArrayList<Cell> cells){
    ArrayList<Cell> holder = new ArrayList<Cell>();
    for(Cell c : cells) {
        if(c.cord.equals(p) && c.d != null) {
            holder.add(c);
        }
    }
    return holder;
  }
  
  ArrayList<Cell> getNeighbour(ArrayList<Cell> cells){
    ArrayList<Cell> holder = new ArrayList<Cell>();
    float x0 = min(this.cord.x - 1, 0);
    float x1 = max(this.cord.x + 1, width/size);
    float y0 = min(this.cord.y - 1, 0);
    float y1 = max(this.cord.y + 1, height/size);
    for (float i = x0; i < x1; i++){
      for (float j = y0; j < y1; j++){
        PVector thisCord = new PVector(i, j);
        holder.addAll(matchCord(thisCord, cells));
      }
    }
    return holder;
  }
  
  ArrayList<Dart> getDartFromCell(ArrayList<Cell> cells){
    ArrayList<Dart> holder = new ArrayList<Dart>();
    for (Cell c : cells){
      holder.add(c.d);
    }
    return holder;
  }
  
  void display(){
    noFill();
    square(x, y, size);
  }

}
