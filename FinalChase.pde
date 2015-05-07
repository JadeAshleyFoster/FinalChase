import java.util.Random;
import java.util.ArrayList;

private Random random;
private Arena arena;
private ArrayList<Goat> goats, goatsToDie;
private ArrayList<Wolf> wolves, wolvesToDie;
private ArrayList<Animal> allAnimals;
private int numberOfWolves;
private int numberOfGoats;

public void setup() {
  colorMode(HSB, 358, 100, 100);
  size(1200, 800);
  this.random = new Random();
  this.arena = new Arena(width, height);
  this.allAnimals = new ArrayList<Animal>();
  this.numberOfWolves = 0;
  this.wolves = new ArrayList<Wolf>();
  for (int i = 0; i < numberOfWolves; i++) {
    addWolf();
  }
  this.numberOfGoats = 0;
  this.goats = new ArrayList<Goat>();
  for (int i = 0; i < numberOfGoats; i++) {
    addGoat();
  }
}

public void addGoat() {
  Goat newGoat = new Goat(new PVector(random.nextInt((width - 0) + 1) + 0, random.nextInt((height - 0) + 1) + 0), arena);
  goats.add(newGoat);
  allAnimals.add(newGoat);
}

public void addWolf() {
  Wolf newWolf = new Wolf(new PVector(random.nextInt((width - 0) + 1) + 0, random.nextInt((height - 0) + 1) + 0), arena);
  wolves.add(newWolf);
  allAnimals.add(newWolf);
}

public void removeWolf(Wolf wolf) {
  wolves.remove(wolf);
  allAnimals.remove(wolf);
}

public void removeGoat(Goat goat){
  goats.remove(goat);
  allAnimals.remove(goat);
}

public void keyPressed() {
  if (keyPressed) {
    if (key == 'g') {
      addGoat();
    } else if (key == 'w') {
      addWolf();
    }
  }
}

public void draw() {
  background(358, 0, 95);
  
  if (mousePressed) {
    PVector mousePosition = new PVector(mouseX, mouseY);
    for (Animal animal : allAnimals) {
      if (PVector.dist(mousePosition, animal.position) < animal.size * 1.5) { //May want to add some tolerance here
        animal.setPosition(mousePosition);
      }
    }
  }  
  
  numberOfWolves = wolves.size();
  ArrayList<Wolf> wolvesToDie = new ArrayList<Wolf>();
  for (Wolf wolf : wolves) {
    wolf.update(wolves, goats, allAnimals);
    wolf.render();
    if (wolf.isDead()) {
      wolvesToDie.add(wolf);
    }
  }
  for (Wolf wolf : wolvesToDie) {
    removeWolf(wolf);
  }
  
  numberOfGoats = goats.size();
  ArrayList<Goat> goatsToDie = new ArrayList<Goat>();
  ArrayList<Goat> offspring = new ArrayList<Goat>();
  for (Goat goat : goats) {
    goat.update(wolves, goats, allAnimals);
    goat.render();
    goat.beEatenBy(wolves);
    if (goat.isDead()) {
      goatsToDie.add(goat);
    }
    //offspring = goat.mate(goats, allAnimals);
  }
  for (Goat goat : goatsToDie) {
    removeGoat(goat);
  }
  /**
  for (Goat goat : offspring) {
    goats.add(goat);
  }
  **/
}
