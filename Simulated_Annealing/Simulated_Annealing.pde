// Simulated Annealing Generative Art 
// By Zora Zhang

import java.io.*; 
import java.util.*; 

int size = 10;                                           // size of vertices/edges                      
ArrayList<Integer> V = getVertices(size);                // vertices 
ArrayList<PVector> E = getEdges((int) (size * 1.5));     // edges 
ArrayList<Integer> L = new ArrayList<Integer>();         // empty set L
int T0 = 100;                                            // initial temperature
int Tf = 5;                                              // final temperature
float a = 0.98;                                          // decay factor (0,1)
int count = 0;                                           // keeps track of number of loops
ArrayList<PVector> Ls = new ArrayList<PVector>();        // sum of nodes in all the solutions
color[] palette = {#84a9ac, #3b6978, #204051};  // color palette


// Circle position is defined by the sum of a set of nodes 
// Circle number of layers is defined by frequency that the algorithm reaches a set of nodes 
// Sector position is defined by the avg temperature that matches the set of nodes

void setup(){
  background(#e4e3e3);
  size(500,600);
  pixelDensity(2);
}

void draw(){
  ArrayList<Integer> solution = anneal();
  ArrayList<PVector> circles = summarize(Ls);
  Dictionary<Float, Float> Ts = getTemp(Ls);
  println(Ls);
  println(circles);
  println(Ts);
  for (PVector c : circles){
    int diag = 10;
    float deg = Ts.get(c.x);
    deg = map(deg, T0, Tf, 0, TWO_PI);
    float xloc = width/2 + map(c.x, getMinSum(Ls), getMaxSum(Ls), 0, random(-400, 400));
    float yloc = height/2 + map(c.x, getMinSum(Ls), getMaxSum(Ls), 0, random(-200, 200));
    c.y = map(c.y, 0, getMaxOcc(circles), 20, 100);
    for (int i = 0; i < c.y; i++){
      noFill();
      stroke(palette[(int) random(palette.length)]);
      strokeWeight(random(3));
      circle(xloc, yloc, diag);
      fill(palette[(int) random(palette.length)]);
      arc(xloc, yloc, diag, diag, deg - PI/10, deg);
      fill(#e4e3e3);
      arc(xloc, yloc, diag, diag, - deg, - deg + PI/20);
      diag +=5;
    }
  }
  noLoop();
}

ArrayList<Integer> anneal(){
  // set temperature to initial temp 
  float T = T0;
  // an empty array to hold the vertices 
  ArrayList<Integer> N = new ArrayList<Integer>();
  
  // initialize a starting point 
  int startingPoint = (int)random(V.size());
  L.add(V.get(startingPoint));
  N.add(V.get(startingPoint));
  
  while(T > Tf){
    // delete a random node from L 
    if (random(100) > 90 && N.size() > 0){
      N.remove((int)random(N.size()));
    }
    // add a random node, check independence
    else {
      int newV = randNewV();
      if (checkIndependent(newV)){
        N.add(newV);
      }
    }
    // N > L situation 
    if (N.size() > L.size()){
      L = (ArrayList<Integer>)N.clone();
    }
    // N < L situation
    else{
      float diff = N.size() - L.size();
      float temp = T - Tf;
      float x = diff / temp;
      if (exp(x) > random(1)){
        L = (ArrayList<Integer>)N.clone();
      }
    }
    // decrease the temperature 
    T *= a;
    // keep track of count 
    count++;
    // add the set of nodes to Ls, prepare for drawing out the art
    PVector circ = new PVector(sum(L), T);
    Ls.add(circ);
  }
  return L;
}

// get a random vertices that is not in L 
int randNewV(){
  ArrayList<Integer> notInL = (ArrayList<Integer>)V.clone();
  notInL.removeAll(L);
  int index = (int)random(notInL.size());
  int ver = notInL.get(index);
  return ver;
}

// get a new node based on the sum of existing ones 
int quotientNewV(){
  int sum = 0;
  for(int vertices : L) {sum += vertices;}
  int newV = sum % size;
  return newV;
}

// check if vertices are independent 
boolean checkIndependent(int v){
  boolean returner = true;
  for (int vertices : L){
    PVector connection = new PVector(vertices, v, 0.0);
    PVector connection2 = new PVector(v, vertices, 0.0);
    if ((E.contains(connection) || E.contains(connection2))){
      // if there is a connection, return false
      returner = false;
    }
  }
  // if no connection is detected, return true
  return returner;
}

// get an array of vertices 
ArrayList getVertices(int len){
  ArrayList<Integer> vertices = new ArrayList<Integer>();
  for (int i = 0; i < len; i++){
    vertices.add(i);
  }
  return vertices;
}

// get an array of edges in PVector 
ArrayList getEdges(int len){
  ArrayList<PVector> edges = new ArrayList<PVector>();
  int count = 0;
  while(count < len){
    int v1 = V.get((int)random(size));
    int v2 = V.get((int)random(size));
    edges.add(new PVector(v1, v2));
    count++;
  }
  return edges;
}

// get sum of the nodes in a set 
int sum(ArrayList<Integer> arr){
  int sum = 0;
  for(int i : arr) {sum += i;}
  return sum;
}

// a set of nodes --> sum, number of occurrences 
ArrayList<PVector> summarize(ArrayList<PVector> arr){
  ArrayList<Integer> nums = new ArrayList<Integer>();
  ArrayList<PVector> occurrence = new ArrayList<PVector>();
  for (PVector vec : arr){
    nums.add((int) vec.x);
  }
  for (Integer num : nums){
    int occ = Collections.frequency(nums,num);
    PVector bound = new PVector(num, occ);
    occurrence.add(bound);
  }
  Set<PVector> set = new HashSet<PVector>(occurrence);
  occurrence.clear();
  occurrence.addAll(set);
  return occurrence;
}

// finds the largest number of occurrences in the sets  
float getMaxOcc (ArrayList<PVector> arr){
  float holder = 0.0;
  for (PVector v : arr){
    if (v.y > holder){holder = v.y;}
  }
  return holder;
}

// finds the largest sum of the sets 
float getMaxSum (ArrayList<PVector> arr){
  float holder = 0.0;
  for (PVector v : arr){
    if (v.x > holder){holder = v.x;}
  }
  return holder;
}

// finds the smallest sum of the sets 
float getMinSum (ArrayList<PVector> arr){
  float holder = 9999.0;
  for (PVector v : arr){
    if (v.x < holder){holder = v.x;}
  }
  return holder;
}


// match sum of nodes to their average corresponding temperature 
Dictionary<Float, Float> getTemp(ArrayList<PVector> arr){
  Dictionary<Float, Float> Ts = new Hashtable(); 
  ArrayList<Float> matchNodes = new ArrayList<Float>();
  ArrayList<Float> matchTemps = new ArrayList<Float>();
  for (PVector vec : arr){
    if (!matchNodes.contains(vec.x)){
      matchNodes.add(vec.x);
      matchTemps.add(vec.y);
    }
    else {
      int index = matchNodes.indexOf(vec.x);
      matchTemps.set(index, vec.y + matchTemps.get(index)/2);
    }
  }
  for (int i = 0; i < matchNodes.size(); i ++){
    Ts.put(matchNodes.get(i), matchTemps.get(i));
  }
  return Ts;
}
