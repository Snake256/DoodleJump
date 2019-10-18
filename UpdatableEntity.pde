abstract class UpdatableEntity extends Entity
{
  PVector Velocity;
  
  public UpdatableEntity(PVector position)
  {
    super(position);
  }
  
  public abstract void Update(Level level, int deltatime);
  
  protected void UpdatePosition(int deltatime)
  {
    if(this.Velocity != null)
    {
      PVector positionchange = this.Velocity.copy();
      positionchange.mult(deltatime / (float) 1000);
      this.Position.add(positionchange);
    }
  }
  
  protected void AddGravityPull(int deltatime)
  {
    if(this.Velocity != null)
    {
      this.Velocity.y += Gravity * deltatime / (float) 1000;
      
      if(this.Velocity.y < -PlayerMaxYVelocity)
      {
        this.Velocity.y = -PlayerMaxYVelocity;
      }
    }
  }
}
