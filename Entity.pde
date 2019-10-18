abstract class Entity
{
  PVector Position;
  
  ArrayList<Collider> Colliders;
  
  public Entity(PVector position)
  {
    if(position == null)
    {
      throw new IllegalArgumentException("Position cannot be null.");
    }
    
    this.Position = position;
    this.Colliders = new ArrayList<Collider>();
  }
  
  public ArrayList<Collider> GetTranslatedColliders()
  {
    if(this.Colliders != null)
    {
      ArrayList<Collider> translatedcolliders = new ArrayList<Collider>();
      
      for(Collider col : this.Colliders)
      {
        Collider copy = col.Copy();
        copy.Position.add(this.Position);
        translatedcolliders.add(copy);
      }
      
      return translatedcolliders;
    }
    else
    {
      return null;
    }
  }
  
  public ArrayList<Entity> GetIntersectingEntities(Level level)
  {
    ArrayList<Entity> intersectingentities = new ArrayList<Entity>();
    ArrayList<Collider> translatedcolliders = this.GetTranslatedColliders();
    
    for(Entity entity : level.Entities)
    {
      if(entity == this)
      {
        continue;
      }
      
      ArrayList<Collider> entitycolliders = entity.GetTranslatedColliders();
      
      for(Collider colentity : entitycolliders)
      {
        boolean collides = false;
        
        for(Collider col : translatedcolliders)
        {
          collides = Utilities.CheckCollision(col, colentity);
          if(collides)
          {
            intersectingentities.add(entity);
            break;
          }
        }
        
        if(collides)
        {
          break;
        }
      }
    }
    
    return intersectingentities;
  }
  
  public void Draw()
  {
    if(ShowColliders)
    {
      ArrayList<Collider> colliders = this.GetTranslatedColliders();
      noFill();
      stroke(0, 0, 255);
      for(Collider col : colliders)
      {
        col.Draw();
      }
    }
  }
}
