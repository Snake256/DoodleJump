class Ray
{
  PVector StartPoint;
  PVector EndPoint;
  
  PVector Direction;
  
  float dx;
  float dy;
  
  float DistanceSquared;
  
  float Determinant;
  
  public Ray(PVector startpoint, PVector endpoint)
  {
    if(startpoint == null)
    {
      throw new IllegalArgumentException("StartPoint cannot be null.");  
    }
    
    if(endpoint == null)
    {
      throw new IllegalArgumentException("EndPoint cannot be null.");  
    }
    
    this.StartPoint = startpoint;
    this.EndPoint = endpoint;
    
    this.dx = this.EndPoint.x - this.StartPoint.x;
    this.dy = this.EndPoint.y - this.StartPoint.y;
    
    if(dx == 0 && dy == 0)
    {
      throw new IllegalArgumentException("Startpoint and Endpoint cannot be the same point.");
    }
    
    this.Direction = new PVector(dx, dy);
    
    this.DistanceSquared = pow(dx, 2) + pow(dy, 2);
    
    this.Determinant = this.StartPoint.x * this.EndPoint.y - this.EndPoint.x * this.StartPoint.y;
  }
  
  public Ray(PVector direction)
  {
    this(new PVector(0, 0), direction);
  }
  
  public void Move(PVector offset)
  {
    this.StartPoint.add(offset);
    this.EndPoint.add(offset);
    this.Determinant = this.StartPoint.x * this.EndPoint.y - this.EndPoint.x * this.StartPoint.y;
  }
  
  public Ray Copy()
  {
    return new Ray(this.StartPoint.copy(), this.EndPoint.copy());
  }
}
