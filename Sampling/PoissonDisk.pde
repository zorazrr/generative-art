class PoissonDisk{
  
  ArrayList<Cell> cells;    // cell grid
  int r;                    // radius, diagonal 
  float size;               // side length
  ArrayList<Dart> darts;    // valid darts
  
  PoissonDisk(int r){
    this.r = r;
    size = r / sqrt(2);
    cells = new ArrayList<Cell>();
    darts = new ArrayList<Dart>();
    
    // initialize
    for (int i = 0; i < width/size; i++){
      for (int j = 0; j < height/size; j++){
        Cell newCell = new Cell(i * size, j * size, new PVector(i,j), size);
        cells.add(newCell);
      }
    }
    
    while (cells.size() > 0){
      // throw darts 
      throwDart();
      
      // split cells
      ArrayList<Cell> smallHolder = new ArrayList<Cell>();
      for (Cell c : cells){
        ArrayList<Cell> smallCells = c.splitCell();
        smallHolder.addAll(smallCells);
      }
      cells.clear();
      cells.addAll(smallHolder);
      
      // filter out cells that are inside the circle
      filterCell();
 
    }
    
    // display
    //for (Dart d : darts){
    //  Shape s = new Shape(d.x, d.y);
    //  s.display();
    //}
    //for(Cell c : cells){
    //  c.display();
    //}
  }
  
  ArrayList<Dart> getDarts(){
    return this.darts;
  }
  
  void throwDart(){
    // throw darts 
    for (int i = cells.size() - 1; i >= 0; i--){
      Cell thisCell = cells.get(i);
      if (random(10) > 7){
        Dart thisDart = new Dart (random(thisCell.x, thisCell.x + size), 
                                  random(thisCell.y, thisCell.y + size));
         darts.add(thisDart);
         thisCell.d = thisDart;
       }
    }
    println("d", darts.size());
    // check if the dart is valid 
    ArrayList<Cell> invalidCells = new ArrayList<Cell>();
    for (Cell ce : cells){
      if (ce.d != null){
        ArrayList<Cell> neighbours = ce.getNeighbour(cells);
        ArrayList<Dart> neighbourDarts = ce.getDartFromCell(neighbours);
        Dart da = ce.d;
        if (filterDart(da, neighbourDarts)){
          darts.remove(da);
          ce.d = null;
        }
        else {
          invalidCells.add(ce);
        }
    }
  }
  // remove invalid darts
  cells.removeAll(invalidCells);
  println("newd", darts.size());
  // check for active cells 
  }
  
  void filterCell(){
    ArrayList <Cell> holder = new ArrayList<Cell>();
    for (Dart d : darts){
      for (Cell c : cells){
        if (!d.cellOutside(c)){holder.add(c);}
      }
    }
    cells.removeAll(holder);
  }
  
  boolean filterDart(Dart thisDart, ArrayList<Dart> ndarts){
    for (Dart nda : ndarts){
      if (!thisDart.checkOther(nda)){
        return false;
          }
      }
      return true;
  }
  
}
 
