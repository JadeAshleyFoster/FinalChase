public class Goat extends Animal {  
  public final static float maxTurn = 0.2, maxSpeed = 0.5, size = 3, FOV = 250, safeRadius = 80, goatSeperation = 20, renderCircles = 10;
  private final static float goatSeperationWeight = 0.5, wolfSeperationWeight = 1, withinArenaWeight = 3, chaseWeight = 3;
  private final static float positionsToRemember = 10;
  private ArrayList<PVector> positions;
  
  Goat(PVector startPosition, Arena arena) {
    super(startPosition, maxTurn, maxSpeed, size, FOV, safeRadius, arena);
    this.arena = arena;
    this.positions = new ArrayList<PVector>();
  }
  
  public void update(ArrayList<Wolf> wolves, ArrayList<Goat> goats, ArrayList<Animal> allAnimals) {
    updatePosition(wolves, goats, allAnimals);
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
    PVector desiredGoatSeperation = super.getDesiredSeperationFrom(goats, goatSeperation);
    desiredGoatSeperation.mult(goatSeperationWeight);
    desiredMovement.add(desiredGoatSeperation);
    PVector desiredWolfSeperation = super.getDesiredSeperationFrom(wolves, FOV);
    desiredWolfSeperation.mult(wolfSeperationWeight);
    desiredMovement.add(desiredWolfSeperation);
    if (goats.size() > 1 && super.life > 50) {
      PVector desiredMateChase = super.getDesiredChaseOfClosest(goats);
      println(desiredMateChase);
      desiredMateChase.mult(chaseWeight);
      desiredMovement.add(desiredMateChase);
    }
    if (desiredMovement.mag() == 0) {
      desiredMovement = super.getRandomDesired();
    }
    return desiredMovement;
  }
  
  public void beEatenBy(ArrayList<Wolf> wolves) {
    if (cornered(wolves)) {
      for (Wolf wolf : wolves) {
        if (super.isTooClose(wolf.position, safeRadius)) {
          super.subLife();
          wolf.addLife();
        }
      }
    }
  }
  
  private boolean cornered(ArrayList<? extends Animal> animals) {
    float averageMovement = getAverage(positions, positions.size());
    if (averageMovement < 0.2 && super.isAtSafeRadius(animals)) {
      return true;
    }
    return false;
  }
  
  private float getAverage(ArrayList<PVector> points, float numberOf) {
    float totalPointChange = 0;
    for (int i = 0; i < points.size()-1; i++) {
      PVector thisPoint = points.get(i);
      PVector nextPoint = points.get(i+1);
      float distance = PVector.dist(thisPoint, nextPoint);
      totalPointChange += distance;
    }
    float avPointChange = totalPointChange/numberOf;
    return avPointChange;
  }
  
  public ArrayList<Goat> mate(ArrayList<Goat> goats, ArrayList<Animal> allAnimals) {
    ArrayList<Goat> offspring = new ArrayList<Goat>();
    if (!mating) {
      if (super.life > 50 && super.lastMated > 100) {
        Animal possibleMate = super.getClosest(goats);
        if (possibleMate.life > 50 && possibleMate.lastMated > 100) {
          PVector desired = super.getDesiredChaseOf(possibleMate.position);
          super.moveTowards(desired, allAnimals);
          if (super.isTooClose(possibleMate.position, size)) {
            super.mating = true;
          }
        }
      }
    } else {
      offspring.add(new Goat(position, arena));
      super.lastMated = 0;
    }
    return offspring;
  }
  
  public void render() {
    float colourDiff = 80/renderCircles;
    for (float i = renderCircles; i > 0; i--) {
      float radius = size * i;
      //fill(centre - (i*colourDiff), super.life);
      fill(248, 0, 79, super.life);
      ellipse(position.x, position.y, radius, radius);
      noStroke();
    }
  }
  
}
