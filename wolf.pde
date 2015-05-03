import java.util.Random;

public class Wolf extends Animal {
  private Random random;
  private final float wolfSeperation = 60, renderCircles = 10; 
  private final static float maxTurn = 0.2, maxSpeed = 0.8, size = 3, FOV = 275, safeRadius = 40; 
  
  Wolf(PVector startPosition, Arena arena) {
    super(startPosition, maxTurn, maxSpeed, size, FOV, safeRadius, arena);
    this.random = new Random();
    this.arena = arena;
  }
  
  public void update(ArrayList<Wolf> wolves, ArrayList<Goat> goats, ArrayList<Animal> allAnimals) {
    updatePosition(wolves, goats, allAnimals);
  }
  
  //Gets the desired position in relation to other animals (to be chasing goats and staying away from wolves)
  private void updatePosition(ArrayList<Wolf> wolves, ArrayList<Goat> goats, ArrayList<Animal> allAnimals) {
    PVector desired = getDesiredMovement(wolves, goats);
    super.moveTowards(desired, allAnimals);
  }
  
  private PVector getDesiredMovement(ArrayList<Wolf> wolves, ArrayList<Goat> goats) {
    PVector desiredMovement = new PVector(0, 0);
    PVector desiredWithinArena = super.getDesiredWithinArena();
    desiredMovement.add(desiredWithinArena);
    PVector desiredWolfSeperation = super.getDesiredSeperationFrom(wolves, wolfSeperation);
    desiredMovement.add(desiredWolfSeperation);
    PVector desiredGoatSeperation = super.getDesiredSeperationFrom(goats, safeRadius);
    desiredMovement.add(desiredGoatSeperation);
    PVector desiredChase = super.getDesiredChaseOfClosest(goats);
    if (desiredChase.mag() == 0) {
      desiredChase = super.getRandomDesired();
    }
    desiredMovement.add(desiredChase);
    return desiredMovement;
  }
  
  public void render() {
    float centre = 100;
    float colourDiff = 60/renderCircles;
    for (float i = renderCircles; i > 0; i--) {
      float radius = size * i;
      fill(centre + (i*colourDiff));
      ellipse(position.x, position.y, radius, radius);
      noStroke();
    }  
  }
}
