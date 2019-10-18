class AIPlayer extends Player
{
  Genome Brain;
  Network Network;
  
  public AIPlayer(PVector position, Genome brain)
  {
    super(position);
    this.Brain = brain;
    this.Network = new Network(this.Brain);
  }
  
  public void Update(Level level, int deltatime)
  {
    super.Update(level, deltatime);
    Think(level);
  }
  
  private void Think(Level level)
  {
    ArrayList<PVector> rayintersections = GetRayIntersections(level);
    
    float[] nninput = new float[1 + (Rays.size() * 2)];
    nninput[0] = this.Velocity.y/PlayerMaxYVelocity;
    
    for(int i = 0; i < rayintersections.size(); i++)
    {
      PVector intersection = rayintersections.get(i);
      
      if(intersection != null)
      {
        nninput[1 + i] = 1 / PVector.sub(intersection, this.Position).mag();
      }
      else
      {
        nninput[1 + i] = 0;
      }
    }
    
    float[] outputs = this.Network.FeedForward(nninput);
    int biggestoutput = 1;
    float outputval = outputs[0];
    
    for(int i = 0; i < outputs.length; i++)
    {
      float output = outputs[i];
      
      if(output > outputval)
      {
        outputval = output;
        biggestoutput = i + 1;
      }
    }
    
    switch(biggestoutput)
    {
      case 1:
        this.Velocity.x = 0;
        break;
        
      case 2:
        this.Velocity.x = -PlayerVelocityX;
        break;
        
      case 3:
        this.Velocity.x = PlayerVelocityX;
        break;
        
      default:
        throw new IllegalStateException("No biggest output determined.");
    }
  }
}
