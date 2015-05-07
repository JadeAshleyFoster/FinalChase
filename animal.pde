import java.util.TreeMap;

public abstract class Animal {
  protected final float maxLife = 100, lifeDecrease = 0.05, lifeIncrease = 5;
  protected PVector position, velocity, acceleration;
  private float maxTurn, maxSpeed, size, FOV, safeRadius, life, lastMated;
  private final float edgeThreshold = 50, mateRadius = 50;
  protected Arena arena;
  protected boolean mating;
  
  Animal(PVector startPosition, float maxTurn, float maxSpeed, float size, float FOV, float safeRadius, Arena arena) {
    random = new Random();
    position = startPosition;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    this.maxTurn = maxTurn;
    this.maxSpeed = maxSpeed;
    this.size = size;
    this.FOV = FOV;
    this.safeRadius = safeRadius;
    this.arena = arena;
    this.life = maxLife;
    this.lastMated = 0;
    this.mating = false;
  }
  
  protected void moveTowards(PVector desired, ArrayList<Animal> allAnimals) {
    line(position.x, position.y, position.x + desired.x, position.y + desired.y);
    calculateVelocity(desired);
    PVector nextPosition = PVector.add(position, velocity);
    if (arena.withinArenaLimits(nextPosition)) {
      position = nextPosition;
    }
    
    // Hack to fix animals that 'become one', essentialy prevents collisions
    PVector desiredAway = new PVector(0, 0);
    for (Animal animal :  allAnimals) {
      float animalDistance = position.dist(animal.position);
      if (animal != this && animalDistance < size * 1.5) {
        float relative = getInverseSquared(animalDistance) * 1000;
        desiredAway.add(PVector.mult(getDesiredAwayFrom(animal.position), relative));
      }
    }
    desired.add(desiredAway);
    calculateVelocity(desiredAway);
    
    acceleration.mult(0);
  }
  
  private void calculateVelocity(PVector desired) {
    desired.limit(maxSpeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxTurn);
    acceleration.add(steer);
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
  }
  
  private boolean canSee(PVector toBeSeen) {
    return position.dist(toBeSeen) < FOV;
  }
  
  //Returns the desired vector to seperate from all animals that are too close
  protected PVector getDesiredSeperationFrom(ArrayList<? extends Animal> animals, float threshold) {
    PVector totalSeperation = new PVector(0, 0);
    for (Animal animal : animals) {
      if (animal != this && isTooClose(animal.position, threshold)) {
        PVector desiredSeperationFromAnimal = PVector.sub(position, animal.position);
        if (desiredSeperationFromAnimal.mag() > 0) {
          totalSeperation.add(desiredSeperationFromAnimal);
        } else {
          totalSeperation.add(getRandomDesired());
        }
      }
    }
    totalSeperation.normalize();
    return totalSeperation;
  }
  
  //Returns the desired vector to stay away from walls
  protected PVector getDesiredWithinArena() {
    PVector desiredWithinArena = new PVector(0, 0);
    for (PVector[] edge : arena.edges) {
      float edgeDistance = arena.getDistanceFromEdge(position, edge);
      if (edgeDistance < edgeThreshold) {
        float relative = getInverseSquared(edgeDistance) * 1000; //this just works, believe in it
        PVector desiredAwayFromEdge = getDesiredAwayFromEdge(position, edge);
        desiredAwayFromEdge.normalize();
        desiredAwayFromEdge.mult(relative);    
        desiredWithinArena.add(desiredAwayFromEdge);
      }
    }
    desiredWithinArena.normalize();
    return desiredWithinArena;
  }
  
  protected PVector getDesiredAwayFromEdge(PVector point, PVector[] edge) {
    PVector desiredAwayFromEdge = new PVector(0, 0);
    PVector edgePoint = arena.getPerpendicularEdgePoint(point, edge);
    desiredAwayFromEdge = PVector.sub(position, edgePoint);
    return desiredAwayFromEdge;
  }
  
  //Returns the desired vector to get to the location of the closest animal in the list, if within FOV and not at safe radius
  protected PVector getDesiredChaseOfClosest(ArrayList<? extends Animal> animals) {
    PVector desiredChase = new PVector(0, 0);
    Animal closest = getClosest(animals);
    if (closest != null && canSee(closest.position) && isTooClose(closest.position, safeRadius) == false) {
      desiredChase =  PVector.sub(closest.position, position);
    } else if (closest != null && isTooClose(closest.position, safeRadius)) {  //If within safeRadius move away
      desiredChase = PVector.sub(position, closest.position);
    } else {
      desiredChase = new PVector(0, 0);  
    }
    desiredChase.normalize();
    return desiredChase;
  }
  
  private PVector getRandomDesired() {
    return PVector.random2D();  // TODO: Sort this aaggghhhhuuuuooottt...
  }
  
  private PVector getDesiredAwayFrom(PVector point) {
    return PVector.sub(position, point);
  }
  
  private PVector getDesiredChaseOf(PVector point) {
    return PVector.sub(point, position);
  }
  
  //Returns if a point is too close in regards to a given threshold
  public boolean isTooClose(PVector objectPosition, float threshold) {
    return position.dist(objectPosition) < threshold;
  }
  
  
  //Returns the closest animal in a given list
  private Animal getClosest(ArrayList<? extends Animal> animals) {
    if (animals.size() < 1) {
      return null;
    }
    TreeMap<Float, Animal> distances = new TreeMap<Float, Animal>();
    for (Animal animal : animals) {
      if (animal != this) {
        float distance = position.dist(animal.position);
        distances.put(distance, animal);
      }
    }
    return distances.get(distances.firstKey());
  }
  
  protected boolean isAtSafeRadius(ArrayList<? extends Animal> animals) {
    for (Animal animal : animals) {
      if (isTooClose(animal.position, safeRadius)) {
        return true;
      }
    }
    return false;
  }
  
  protected float getInverseSquared(float r) {
    return 1/(r*r);
  }
  
  public void setPosition(PVector newPosition) {
    position = newPosition;
  }
  
  public void addLife() {
    if (life < maxLife) {
      life += lifeIncrease;
    }
  }
  
  public void subLife() {
    life -= lifeDecrease;
  }
  
  public boolean isDead() {
    return life < 0;
  }
  
}
