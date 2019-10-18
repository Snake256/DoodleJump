class Level
{
  ArrayList<Entity> Entities;
  
  float PlatformsTopBound;
  float PlatformsBottomBound;
  
  Player HighestAlivePlayer;
  Player LowestAlivePlayer;
  
  Population Population;
  
  public Level()
  {
    Reset();
  }
  
  public void Add(Entity entity)
  {
    if(entity != null)
    {
      this.Entities.add(entity);
    }
    else
    {
      throw new IllegalArgumentException("Can't add null to Entity List.");
    }
  }
  
  public Player HighestAlivePlayer()
  {
    Player highestaliveplayer = null;
    
    for(Entity entity : this.Entities)
    {
      if(entity instanceof Player)
      {
        if((highestaliveplayer == null || entity.Position.y > highestaliveplayer.Position.y) && ((Player)entity).Alive)
        {
          highestaliveplayer = (Player) entity;
        }
      }
    }
    
    return highestaliveplayer;
  }
  
  public Player LowestAlivePlayer()
  {
    Player lowestaliveplayer = null;
    
    for(Entity entity : this.Entities)
    {
      if(entity instanceof Player)
      {
        if((lowestaliveplayer == null || entity.Position.y < lowestaliveplayer.Position.y) && ((Player)entity).Alive)
        {
          lowestaliveplayer = (Player) entity;
        }
      }
    }
    
    return lowestaliveplayer;
  }
  
  private void SpawnNextPlatforms()
  {
    float nextplatformpositiony = PlatformsTopBound + random(1, 2);
    PlatformsTopBound += PlatformBoundIncrease;

    do
    {
      float platformtospawn = random(0, 1);
      
      if(platformtospawn < 0.9)
      {
        this.Add(new Platform(new PVector(random(-WidthWorldUnits / 2 + PlatformWidth / 2, WidthWorldUnits / 2 - PlatformWidth / 2), nextplatformpositiony), Platformtype.Regular));
      }
      else if(platformtospawn < 0.95)
      {
        this.Add(new Platform(new PVector(random(-WidthWorldUnits / 2 + PlatformWidth / 2, WidthWorldUnits / 2 - PlatformWidth / 2), nextplatformpositiony), Platformtype.Moving));
      }
      else
      {
        this.Add(new Platform(new PVector(random(-WidthWorldUnits / 2 + PlatformWidth / 2, WidthWorldUnits / 2 - PlatformWidth / 2), nextplatformpositiony), Platformtype.Disappearing));
      }
      
      nextplatformpositiony += random(1.2f, 1.7f);
    } while (PlatformsTopBound - nextplatformpositiony >= 0.5f);
  }
  
  private void CheckNextPlatformSpawn()
  {
    if(HighestAlivePlayer != null && HighestAlivePlayer.Score >= PlatformsTopBound - PlatformBoundIncrease)
    {
      SpawnNextPlatforms();
    }
  }
  
  private void DespawnBottomPlatforms()
  {
    PlatformsBottomBound += PlatformBoundIncrease;
    
    for(int i = 0; i < this.Entities.size(); i++)
    {
      Entity e = this.Entities.get(i);
      
      if(e instanceof Platform && e.Position.y < PlatformsBottomBound)
      {
        this.Entities.remove(i--);
      }
    }
  }
  
  private void CheckNextPlatformDespawn()
  {
    if(LowestAlivePlayer != null && LowestAlivePlayer.ScreenBottomWorldPosition() > PlatformsBottomBound + PlatformBoundIncrease)
    {
      DespawnBottomPlatforms();
    }
  }
  
  public void Reset()
  {
    PlatformsBottomBound = 0;
    PlatformsTopBound = 0;
    
    if(ai)
    {
      if(this.Population == null)
      {
        Genome startgenome = new Genome(1 + Rays.size() * 2, 3, 5); // inputs, outputs, maxmutationattempts
        
        HashMap<Chance, Float> chances = new HashMap<Chance, Float>();
        //chances.put(Chance.AdjustWeight, 0.6f);
        //chances.put(Chance.AddConnection, 0.07f);
        //chances.put(Chance.AddNode, 0.6f);
        this.Population = new Population(Populationsize, startgenome, 3f, 1f, 1f, 0.4f, chances);
      }
      else
      {
        for(Entity e : this.Entities)
        {
          if(e instanceof AIPlayer)
          {
            AIPlayer aiplayer = (AIPlayer) e;
            this.Population.SetFitness(aiplayer.Brain, pow(2, aiplayer.Score / 50));
          }
        }
        
        this.Population.NextGeneration(new PApplet());
      }
      
      this.Entities = new ArrayList<Entity>();
      
      for(int i = 1; i <= Populationsize; i++)
      {
        this.Add(new AIPlayer(new PVector(0, 0), this.Population.NextGenome()));
      }
    }
    else
    {
      this.Entities = new ArrayList<Entity>();
      this.Add(new ControlledPlayer(new PVector(0, 0)));
    }
    
    SpawnNextPlatforms();
  }
  
  public void Update(int deltatime)
  {
    HighestAlivePlayer = HighestAlivePlayer();
    LowestAlivePlayer = LowestAlivePlayer();
    
    CheckNextPlatformSpawn();
    CheckNextPlatformDespawn();
    
    for(Entity entity : this.Entities)
    {
      if(entity instanceof UpdatableEntity)
      {
        ((UpdatableEntity)entity).Update(this, deltatime);
      }
    }
  }
  
  public void Draw()
  {
    DrawPlatforms();
    DrawOtherEntities();
  }
  
  private void DrawPlatforms()
  {
    for(Entity entity : this.Entities)
    {
      if(entity instanceof Platform)
      {
        entity.Draw();
      }
    }
  }
  
  private void DrawOtherEntities()
  {
    for(Entity entity : this.Entities)
    {
      if(!(entity instanceof Platform))
      {
        entity.Draw();
      }
    }
  }
  
  public boolean AllPlayersDead()
  {
    for(Entity e : this.Entities)
    {
      if(e instanceof Player && ((Player)e).Alive)
      {
        return false;
      }
    }
    
    return true;
  }
}
