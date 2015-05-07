import java.util.Random;

public class Wolf extends Animal {
  private Random random;
  public final static float maxTurn = 0.2, maxSpeed = 0.8, size = 2, FOV = 350, safeRadius = 40, wolfSeperation = 40, renderCircles = 10;
  private final static float chaseWeight = 1, goatSeperationWeight = 1, wolfSeperationWeight = 2, withinArenaWeight = 3; 
  private color coat;
  private final static int pinkishred = 359, pink = 303, purple = 279, darkblue = 237, lightblue = 202, aqua = 165, green = 126, yellow = 60, orange = 29;
  private final static float positionsToRemember = 50;
  private ArrayList<PVector> positions;
  
  Wolf(PVector startPosition, Arena arena) {
    super(startPosition, maxTurn, maxSpeed, size, FOV, safeRadius, arena);
    this.random = new Random();
    this.arena = arena;
    int[] coatColours = {pinkishred, pink, purple, darkblue, lightblue, aqua, green, yellow, orange};
    int coat = coatColours[random.nextInt(coatColours.length)];
    println(coat);
    this.coat = color(coat, 73, 99);
    this.positions = new ArrayList<PVector>();
  }
  
  public void update(ArrayList<Wolf> wolves, ArrayList<Goat> goats, ArrayList<Animal> allAnimals) {
    updatePosition(wolves, goats, allAnimals);
    super.subLife();
    positions.add(position);
    if (positions.size() > positionsToRemember) {
      positions.remove(0);
    }
    super.lastMated += 0.5;
  }
  
  //Gets the desired position in relation to other animals (to be chasing goats and staying away from wolves)
  private void updatePosition(ArrayList<Wolf> wolves, ArrayList<Goat> goats, ArrayList<Animal> allAnimals) {
    PVector desired = getDesiredMovement(wolves, goats);
    super.moveTowards(desired, allAnimals);
  }
  
  private PVector getDesiredMovement(ArrayList<Wolf> wolves, ArrayList<Goat> goats) {
    PVector desiredMovement = new PVector(0, 0);
    PVector desiredWithinArena = super.getDesiredWithinArena();
    desiredWithinArena.mult(withinArenaWeight);
    desiredMovement.add(desiredWithinArena);
    PVector desiredWolfSeperation = super.getDesiredSeperationFrom(wolves, wolfSeperation);
    desiredWolfSeperation.mult(wolfSeperationWeight);
    desiredMovement.add(desiredWolfSeperation);
    PVector desiredGoatSeperation = super.getDesiredSeperationFrom(goats, safeRadius);
    desiredGoatSeperation.mult(goatSeperationWeight);
    desiredMovement.add(desiredGoatSeperation);
    PVector desiredChase = super.getDesiredChaseOfClosest(goats);
    if (desiredChase.mag() == 0) {
      desiredChase = super.getRandomDesired();
    }
    desiredChase.mult(chaseWeight);
    desiredMovement.add(desiredChase);
    return desiredMovement;
  }
  
  public void render() {
    float centre = 100;
    float colourDiff = 60/renderCircles;
    for (float i = renderCircles; i > 0; i--) {
      float radius = size * i;
      //fill(centre + (i*colourDiff), super.life);
      fill(coat, super.life);
      ellipse(position.x, position.y, radius, radius);
      noStroke();
    }  
    /**
    for (int i = 0; i < positions.size(); i++) {
      fill(coat, (i+1)*0.5);
      ellipse(positions.get(i).x, positions.get(i).y, size*8, size*8);
    }
    **/
  }  
}
