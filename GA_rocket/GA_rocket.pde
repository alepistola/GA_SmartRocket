// Smart Rockets w/ Genetic Algorithms

// Each Rocket's DNA is an array of PVectors
// Each PVector acts as a force for each frame of animation
// Imagine an booster on the end of the rocket that can point in any direction
// and fire at any strength every frame

// The Rocket's fitness is a function of how close it gets to the target as well as how fast it gets there

// This example is inspired by Jer Thorp's Smart Rockets
// http://www.blprnt.com/smartrockets/

int lifetime;  // How long should each generation live

Population population;  // Population

int lifecycle;          // Timer for cycle of generation
int recordtime;         // Fastest time to target
int record_ever;        // Record loaded from file

Obstacle target;        // Target position

//int diam = 24;          // Size of target

ArrayList<Obstacle> obstacles;  //an array list to keep track of all the obstacles!

void setup() { //<>//
  loadRecordSettings();
  size(640, 360);
  //size(displayWidth, displayHeight); smart
  //orientation(LANDSCAPE); smart
  // The number of cycles we will allow a generation to live
  //lifetime = 500; Smart
  lifetime = 300;
  // Initialize variables
  lifecycle = 0;
  recordtime = lifetime;
  
  
  
  
  //target = new Obstacle(width/2-75, height/2.65, 150, 150); smart
  target = new Obstacle(width/2-12, 24, 24, 24); 
  // Create a population with a mutation rate, and population max
  float mutationRate = 0.01;
  population = new Population(mutationRate, 50);

  // Create the obstacle course  
  obstacles = new ArrayList<Obstacle>();
  //obstacles.add(new Obstacle(width/2-250, height/1.5, 500, 40)); smart
  obstacles.add(new Obstacle(width/2-100, height/2, 200, 10));
}

void draw() { //<>//
  background(255);
  
  // Draw the start and target positions
  target.display();


  // If the generation hasn't ended yet
  if (lifecycle < lifetime) {
    population.live(obstacles);
    if ((population.targetReached()) && (lifecycle < recordtime)) {
      recordtime = lifecycle;
      //if (recordtime < record_ever){ //<>//
      //   saveRecordSettings(population.getBestGenes(), recordtime, population.getGenerations()); 
      //}
    }
    lifecycle++;
    // Otherwise a new generation
  } 
  else {
    lifecycle = 0;
    population.fitness();
    population.selection();
    population.reproduction();
  }

  // Draw the obstacles
  for (Obstacle obs : obstacles) {
    obs.display();
  }

  // Display some info 
  fill(0);
  //smart
  //textSize(50);
  //text("Generation #: " + population.getGenerations(), 10, 55);
  //text("Cycles left: " + (lifetime-lifecycle), 10, 110);
  //text("Record cycles: " + recordtime, 10, 165);
  text("Generation #: " + population.getGenerations(), 10, 18);
  text("Cycles left: " + (lifetime-lifecycle), 10, 36);
  text("Record cycles: " + recordtime, 10, 54);
  //if (population.getGenerations() < 10){
  //  saveFrame("frames/####.tif");
  //}
  
  //if (population.getGenerations() > 1990 && population.getGenerations() < 2000){
  //  saveFrame("frames/####.tif");
  //}
}

// Move the target if the mouse is pressed
// System will adapt to new target
void mousePressed() {
  target.position.x = mouseX;
  target.position.y = mouseY;
  recordtime = lifetime;
}

//load the previous record setting
void loadRecordSettings(){
  String[] lines = loadStrings("record_settings.txt");
  record_ever = Integer.parseInt(lines[1]);
}

//save the new record setting
void saveRecordSettings(PVector[] geni, int recordTime, int numGen){
  String output;
  String geniString = "";
  for(int i=0; i<= lifetime-1; i++){
    
      geniString += "[" + Float.toString(geni[i].x) + ", " + Float.toString(geni[i].y) + ", "+ Float.toString(geni[i].z) + "]";
  }
  output = geniString + ";" + Integer.toString(recordTime) + ";" + Integer.toString(numGen);
  String[] list = split(output, ";");
  saveStrings("record_settings.txt", list);
}