import java.util.Random;
import java.util.ArrayList;

private Random random;
private Arena arena;
private ArrayList<Goat> goats;
private ArrayList<Wolf> wolves;
private ArrayList<Animal> allAnimals;
private final int numberOfWolves = 0;
private final int numberOfGoats = 0;

public void setup() {
  size(1000, 800);
  this.random = new Random();
  this.arena = new Arena(width, height);
  this.allAnimals = new ArrayList<Animal>();
  this.wolves = new ArrayList<Wolf>();
  for (int i = 0; i < numberOfWolves; i++) {
    addWolf();
  }
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
  background(165);
  if (mousePressed) {
    PVector mousePosition = new PVector(mouseX, mouseY);
    for (Animal animal : allAnimals) {
      if (PVector.dist(mousePosition, animal.position) < animal.size * 1.5) { //May want to add some tolerance here
        animal.setPosition(mousePosition);
      }
    }
  }  
  for (Wolf wolf : wolves) {
    wolf.update(wolves, goats, allAnimals);
    wolf.render();
  }
  for (Goat goat : goats) {
    goat.update(wolves, goats, allAnimals);
    goat.render();
  }

}
