public class Arena {
  private final float arenaTolerance = 0;
  private float maxX, maxY;
  private PVector topLeft, topRight, bottomLeft, bottomRight;
  private PVector[] northEdge, eastEdge, southEdge, westEdge;
  private PVector[][] edges;
  
  Arena(float maxX, float maxY) {
    this.maxX = maxX;
    this.maxY = maxY;
    topLeft = new PVector(0, 0);
    topRight = new PVector(maxX, 0);
    bottomLeft = new PVector(0,maxY);
    bottomRight = new PVector(maxX, maxY);
    northEdge = new PVector[2];
    northEdge[0] = topLeft;  //Add points clockwise
    northEdge[1] = topRight;
    eastEdge = new PVector[2];
    eastEdge[0] = topRight;
    eastEdge[1] = bottomRight;
    southEdge = new PVector[2];
    southEdge[0] = bottomRight;
    southEdge[1] = bottomLeft;
    westEdge = new PVector[2];
    westEdge[0] = bottomLeft;
    westEdge[1] = topRight;
    edges = new PVector[4][];
    edges[0] = northEdge;  //Add edges clockwise
    edges[1] = eastEdge;   
    edges[2] = southEdge;
    edges[3] = westEdge;
  }
  
  public float getDistanceFromEdge(PVector point, PVector[] edge) {
    PVector edgePoint = getPerpendicularEdgePoint(point, edge);
    return PVector.dist(point, edgePoint);
  }
  
  public PVector getPerpendicularEdgePoint(PVector point, PVector[] edge) {
    PVector perpendicular = new PVector(0, 0);
    if (edge == northEdge) {
      perpendicular = new PVector(point.x, 0);
    } else if (edge == eastEdge) {
      perpendicular = new PVector(maxX, point.y);
    } else if (edge == southEdge) {
      perpendicular = new PVector(point.x, maxY);
    } else {  //edge == westEdge
      perpendicular = new PVector(0, point.y);
    }
    return perpendicular;
  }
  
  public boolean withinArenaLimits(PVector point) {
    if (point.x > (maxX - arenaTolerance) || point.x < arenaTolerance || point.y > (maxY - arenaTolerance) || point.y < arenaTolerance){
      return false;
    } else {
      return true;
    }
  }
  
}
