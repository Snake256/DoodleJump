class ControlledPlayer extends Player
{
  public ControlledPlayer(PVector position)
  {
    super(position);
  }
  
  @Override
  public void Update(Level level, int deltatime)
  {
    super.Update(level, deltatime);
    
    if(this.Alive)
    {
      if(left && !right)
      {
        this.Velocity.x = -PlayerVelocityX;
      }
      else if(!left && right)
      {
        this.Velocity.x = PlayerVelocityX;
      }
      else
      {
        this.Velocity.x = 0;
      }
    }
  }
}
