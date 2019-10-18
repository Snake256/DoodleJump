enum PlayerOrientation
{
  Normal,
  Flipped
}

abstract class Player extends UpdatableEntity
{
  boolean Alive;
  float Score;
  PlayerOrientation PlayerOrientation;
  
  public Player(PVector position)
  {
    super(position);
    this.Alive = true;
    this.Colliders.add(new RectangleCollider(new PVector(0, 0), PlayerWidth, PlayerHeight));
    this.Velocity = new PVector(0, PlayerMaxYVelocity);
    this.Position.z = -3;
    this.PlayerOrientation = PlayerOrientation.Normal;
  }
  
  public float ScreenBottomWorldPosition()
  {
    return Utilities.Clamp(this.Score - (HeightWorldUnits/2), 0, Float.MAX_VALUE);
  }
  
  public float ScreenTopWorldPosition()
  {
    return Utilities.Clamp(this.Score + (HeightWorldUnits/2), HeightWorldUnits, Float.MAX_VALUE);
  }
  
  protected void CheckPlatformCollisions(Level level)
  {
    if(this.Velocity.y <= 0)
    {    
      ArrayList<Entity> intersectingentities = GetIntersectingEntities(level);
      ArrayList<Platform> intersectingplatforms = new ArrayList<Platform>();      
      float screenbottom = this.ScreenBottomWorldPosition();
      float screentop = this.ScreenTopWorldPosition();
      
      for(Entity entity : intersectingentities)
      {
        if(entity instanceof Platform)
        {
          // If the platform is out of view the player can no longer jump on it
          if(!(entity.Position.y + (PlatformHeight / 2) < screenbottom) && entity.Position.y - (PlatformHeight / 2) < screentop)
          {
            // Check if the Player is roughly above the platform
            if(this.Position.y - entity.Position.y >= PlayerHeight/3f)
            {
              if(((Platform)entity).Active)
              {
                intersectingplatforms.add((Platform)entity);
              }
            }
          }
        }
      }
      
      if(intersectingplatforms.size() > 0)
      {
        Platform collidingplatform = intersectingplatforms.get(0);
        
        for(Platform p : intersectingplatforms)
        {
          if(p == collidingplatform)
          {
            continue;
          }
          
          if(p.Position.y > collidingplatform.Position.y)
          {
            collidingplatform = p;
          }
        }
        
        this.Position.y = collidingplatform.Position.y + PlatformHeight/2 + PlayerHeight/2;
        this.Velocity.y = PlayerMaxYVelocity;
        
        if(collidingplatform.Platformtype == Platformtype.Disappearing)
        {
          collidingplatform.Active = false;
        }
      }
    }
  }
  
  protected void UpdateScore()
  {
    if(this.Position.y > this.Score)
    {
      this.Score = this.Position.y;
    }
  }
  
  private void CheckIfStillAlive()
  {
    if(this.Position.y < ScreenBottomWorldPosition())
    {
      this.Alive = false;
    }
  }
  
  @Override
  public void Update(Level level, int deltatime)
  {
    UpdatePosition(deltatime);
    UpdatePlayerOrientation();
    AddGravityPull(deltatime);
    CheckIfStillAlive();
    
    if(this.Alive)
    {
      UpdateScore();
      CheckPlatformCollisions(level);
    }
  }
  
  @Override
  protected void UpdatePosition(int deltatime)
  {
    super.UpdatePosition(deltatime);
    
    if(PlayersCanGoOffBounds)
    {
      if(this.Position.x < -WidthWorldUnits/2)
      {
        this.Position.x = WidthWorldUnits/2;
      }
      else if(this.Position.x > WidthWorldUnits/2)
      {
        this.Position.x = -WidthWorldUnits/2;
      }
    }
  }
  
  public ArrayList<PVector> GetRayIntersections(Level level)
  {
    ArrayList<PVector> intersections = new ArrayList<PVector>();
    float screenbottom = this.ScreenBottomWorldPosition();
    float screentop = this.ScreenTopWorldPosition();
    
    for(Ray ray : Rays)
    {
      // Move the ray startposition to the player
      ray.Move(PVector.sub(this.Position, ray.StartPoint));
      
      ArrayList<PVector> allintersections = new ArrayList<PVector>();
      
      for(Entity e : level.Entities)
      {
        if(e == this || !(e instanceof Platform) || !((Platform)e).Active)
        {
          continue;
        }
        
        // Only get the intersections for the platforms that are still on the screen
        if(!(e.Position.y + (PlatformHeight / 2) < screenbottom) && e.Position.y - (PlatformHeight / 2) < screentop)
        {
          for(Collider c : e.GetTranslatedColliders())
          {
            if(c instanceof CircleCollider)
            {
              allintersections.addAll(Utilities.GetRayCircleInterceptionPoints(ray, (CircleCollider) c));
            }
            else if (c instanceof RectangleCollider)
            {
              allintersections.addAll(Utilities.CalculateRayBoxInterceptions(ray, (RectangleCollider) c));
            }
          }
        }
      }
      
      // add the closest intersections
      PVector int1 = null;
      float distint1 = 0;
      PVector int2 = null;
      float distint2 = 0;
      
      for(PVector p : allintersections)
      {
        PVector dir = PVector.sub(p, this.Position);
        float dist = dir.mag();
        
        // get the first ray intersections (one along the ray and one in the opposite direction of the ray)
        if(((ray.dx == 0 && dir.x == 0) || dir.x / ray.dx > 0) && ((ray.dy == 0 && dir.y == 0) || dir.y / ray.dy > 0))
        {
          if(int1 != null)
          {
            if(distint1 > dist)
            {
              int1 = p;
              distint1 = dist;
            }
          }
          else
          {
            int1 = p;
            distint1 = dist;
          }
        }
        else
        {
          if(int2 != null)
          {
            if(distint2 > dist)
            {
              int2 = p;
              distint2 = dist;
            }
          }
          else
          {
            int2 = p;
            distint2 = dist;
          }
        }
      }
      
      intersections.add(int1);
      intersections.add(int2);
    }
    
    return intersections;
  }
  
  protected void UpdatePlayerOrientation()
  {
    if(this.Velocity.x > 0)
    {
      this.PlayerOrientation = PlayerOrientation.Normal;
    }
    else if(this.Velocity.x < 0)
    {
      this.PlayerOrientation = PlayerOrientation.Flipped;
    }
  }
  
  @Override
  public void Draw()
  {
    super.Draw();
    imageMode(CENTER);
    
    pushMatrix();    
    switch(this.PlayerOrientation)
    {
      case Normal:
        scale(1, 1);
        image(Player, this.Position.x, -this.Position.y, PlayerWidth, PlayerHeight);
        break;
        
      case Flipped:
        scale(-1, 1);
        image(Player, -this.Position.x, -this.Position.y, PlayerWidth, PlayerHeight);
        break;
    }
    
    popMatrix();
  }
}
