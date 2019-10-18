abstract class Collider
{
  public PVector Position;
  
  public Collider(PVector position)
  {
    if(position == null)
    {
      throw new IllegalArgumentException("Position cannot be null.");  
    }
    
    this.Position = position;
  }
  
  public abstract void Draw();
  
  public abstract Collider Copy();
}

public class CircleCollider extends Collider
{
  public float Radius;
  
  public CircleCollider(PVector position, float radius)
  {
    super(position);
    
    if(radius <= 0)
    {
      throw new IllegalArgumentException("Radius has to be greater than 0.");  
    }
    
    this.Radius = radius;
  }
  
  @Override
  public void Draw()
  {
    ellipseMode(RADIUS);
    ellipse(this.Position.x, -this.Position.y, this.Radius, this.Radius);
  }
  
  @Override
  public Collider Copy()
  {
    CircleCollider col = new CircleCollider(this.Position.copy(), this.Radius);
    return col;
  }
}

public class RectangleCollider extends Collider
{
  float Width;
  float Height;
  
  public RectangleCollider(PVector position, float _width, float _height)
  {
    super(position);
    
    if(_width <= 0)
    {
      throw new IllegalArgumentException("Width has to be greater than 0.");  
    }
    
    this.Width = _width;
    
    if(_height <= 0)
    {
      throw new IllegalArgumentException("Height has to be greater than 0.");  
    }
    
    this.Height = _height;
  }
  
  public float LowerX()
  {
    return this.Position.x - (this.Width / 2);
  }
  
  public float UpperX()
  {
    return this.Position.x + (this.Width / 2);
  }
  
  public float LowerY()
  {
    return this.Position.y - (this.Height / 2);
  }
  
  public float UpperY()
  {
    return this.Position.y + (this.Height / 2);
  }
  
  public PVector GetClosestPointInRect(PVector position)
  {
    if(position == null)
    {
      throw new IllegalArgumentException("Position cannot be null.");
    }
    
    float closestpointinrectx = Utilities.Clamp(position.x, this.Position.x - this.Width / 2, this.Position.x + this.Width / 2);
    float closestpointinrecty = Utilities.Clamp(position.y, this.Position.y - this.Height / 2, this.Position.y + this.Height / 2);
    
    return new PVector(closestpointinrectx, closestpointinrecty);
  }
  
  @Override
  public void Draw()
  {
    rectMode(CENTER);
    rect(this.Position.x, -this.Position.y, this.Width, this.Height);
  }
  
  @Override
  public Collider Copy()
  {
    RectangleCollider col = new RectangleCollider(this.Position.copy(), this.Width, this.Height);
    return col;
  }
}
