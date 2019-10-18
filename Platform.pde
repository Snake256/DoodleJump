enum Platformtype
{
  Regular, Moving, Disappearing
}

class Platform extends UpdatableEntity
{
  public boolean Active;
  
  public Platformtype Platformtype;
  
  public Platform(PVector position, Platformtype platformtype)
  {
    super(position);
    this.Colliders.add(new RectangleCollider(new PVector(0, 0), PlatformWidth, PlatformHeight));
    this.Active = true;
    this.Platformtype = platformtype;
    
    if(this.Platformtype == Platformtype.Moving)
    {
      if(random(0, 1) < 0.5f)
      {
        this.Velocity = new PVector(PlatformVelocity, 0);
      }
      else
      {
        this.Velocity = new PVector(-PlatformVelocity, 0);
      }
    }
  }
  
  @Override
  public void Draw()
  {
    if(this.Active)
    {
      super.Draw();
      imageMode(CENTER);
      
      switch(this.Platformtype)
      {
        case Regular:
          image(Platform, this.Position.x, -this.Position.y, PlatformWidth, PlatformHeight);
          break;
          
        case Moving:
          image(PlatformMoving, this.Position.x, -this.Position.y, PlatformWidth, PlatformHeight);
          break;
          
        case Disappearing:
          image(PlatformDisappearing, this.Position.x, -this.Position.y, PlatformWidth, PlatformHeight);
          break;
      }
    }
  }
  
  @Override
  public void Update(Level level, int deltatime) 
  {
    if(this.Platformtype == Platformtype.Moving)
    {
      UpdatePosition(deltatime);
      CheckVelocityChange();
    }
  }
  
  private void CheckVelocityChange()
  {
    if(this.Position.x - PlatformWidth/2 < -WidthWorldUnits/2)
    {
      this.Position.x = -WidthWorldUnits/2 + PlatformWidth/2;
      this.Velocity.x = PlatformVelocity;
    }
    else if(this.Position.x + PlatformWidth/2 > WidthWorldUnits/2)
    {
      this.Position.x = WidthWorldUnits/2 - PlatformWidth/2;
      this.Velocity.x = -PlatformVelocity;
    }
  }
}
