import java.util.*; 
import java.util.Arrays;
import java.util.Collections;

Table table;                          // csv data
Table confusionMatrix;                // confusion matrix
ArrayList<Point> training;            // training set, category known
ArrayList<Point> testing;             // testing set, category unknown
float percentageTest = 2;             // percentage of testing data
int startTime;
int sS, sVi, sVe, viVi, viVe, viS, veVe, veVi, veS = 0;

void setup(){
  // canvas setup 
  size(600,500);
  pixelDensity(2);
  background(255, 251, 227);
  
  // time
  startTime = millis();
  
  // training set 
  training = new ArrayList<Point>();
  // testing set 
  testing = new ArrayList<Point>();
  
  // load data 
  // Data source: https://www.kaggle.com/uciml/iris
  table = loadTable("iris.csv", "header");
  for (TableRow row : table.rows()){
    Point p = new Point(4);
    p.attributes[0] = row.getFloat("SepalLengthCm");
    p.attributes[1] = row.getFloat("SepalWidthCm");
    p.attributes[2] = row.getFloat("PetalLengthCm");
    p.attributes[3] = row.getFloat("PetalWidthCm");
    p.target = row.getString("Species");
    if (random(10) < percentageTest){testing.add(p);}
    else {training.add(p);}
  }
}

void draw(){
  
  // KNN
  knn();
  
  float timeElapsed = millis() - startTime;
  println("Time elapsed:", timeElapsed);
  
  // Accuracy calculation
  int trueCount = 0;
  int falseCount = 0;
  for(Point p : testing){
    if (p.target.equals(p.prediction)){trueCount += 1;}
    else {falseCount += 1;}
  }
  println("Correct:", trueCount);
  println("Incorrect:", falseCount);
  float accuracy = ((float)trueCount / testing.size()) * 100;
  println("Accuracy: ", accuracy, "%");
  
  int startingVal = 0;

  
  // art
  float xoff = 0.0;
  
  for (int i = 0; i < timeElapsed * 3; i++){
    noFill();
    stroke(255, 255 - i, 94);
    circle(width/2, height/2, i);
  }
  filter(BLUR, 4);
  noFill();
  for (Point p : testing){
      beginShape();
      for (int i = 0; i < width; i++){
        if (p.target.equals(p.prediction)){stroke(255, random(255), 94);strokeWeight(1);}
        else {stroke(255, 0, 0);strokeWeight(4);}
        vertex(i, noise(xoff) * height);
        xoff+= 0.01;
      }
      endShape();
  }
  save("art.jpg");
  noLoop();
}

void knn(){
  //int k = 6;
  int k = (int) sqrt(table.getRowCount()) - 1;
  println("k: ", k);
  
  // For each testing point 
  for (Point testingPt : testing){
    Map<Float, Point> map = new HashMap<Float, Point>();    // Store point matched with distance
    ArrayList<Float> distance = new ArrayList<Float>();     // Store distance
    String[] neighbors = new String[k];                     // Store neihbouring targets
     
    // Loop through training points 
    for (Point trainingPt : training){
      // Get distance 
      float thisDist = testingPt.getDist(trainingPt);
      distance.add(thisDist);
      map.put(thisDist, trainingPt);
    }
    
    // Get neighbouring points
    Collections.sort(distance);
    for (int i = 0; i < k; i++){
      float dist = distance.get(i);
      Point neighbor = map.get(dist);
      neighbors[i] = neighbor.target;
    }
    
    // Vote 
    testingPt.prediction = vote(neighbors);
  }
}

String vote(String[] n){
  String[] unique = unique(n);
  ArrayList<Integer> count = new ArrayList<Integer>();
  for (int i = 0; i < unique.length; i++){count.add(0);}
  for (int i = 0; i < n.length; i++){
    for(int j  = 0; j < unique.length; j++){
      if (n[i] == unique[j]){count.set(j, count.get(j) + 1);}
    }
  }
  int counter = 0;
  int maxNum = 0;
  int index =0;
  for(int num : count){
    if(maxNum<num){
      maxNum = num;
      index= counter;
    }
    counter++;
  }
  return unique[index];
}

String[] unique(String[] n){
  String[] unique = new HashSet<String>(Arrays.asList(n)).toArray(new String[0]); 
  return unique;
}
