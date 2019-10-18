import java.lang.Math.*;

static class Utilities
{
  public static float Clamp(float value, float min, float max)
  {
    if(value <= min)
    {
      return min;
    }
    else if(value >= max)
    {
      return max;
    }
    else
    {
      return value;  
    }
  }
  
  public static boolean CheckCollision(Collider col1, Collider col2)
  {
    if(col1 instanceof CircleCollider && col2 instanceof CircleCollider)
    {
      CircleCollider circle1 = (CircleCollider) col1;
      CircleCollider circle2 = (CircleCollider) col2;
      
      return PVector.sub(circle1.Position, circle2.Position).mag() <= (circle1.Radius + circle2.Radius);
    }
    else if(col1 instanceof RectangleCollider && col2 instanceof RectangleCollider)
    {
      RectangleCollider rect1 = (RectangleCollider) col1;
      RectangleCollider rect2 = (RectangleCollider) col2;
      
      boolean rect1IntersectRect2 = (    
                                          ( rect1.LowerX() >= rect2.LowerX() && rect1.LowerX() <= rect2.UpperX() ) 
                                               
                                          ||
                                                
                                          ( rect1.UpperX() >= rect2.LowerX() && rect1.UpperX() <= rect2.UpperX() )  
                                          
                                          || 
                                          
                                          ( rect1.LowerX() <= rect2.LowerX() && rect1.UpperX() >= rect2.UpperX() )
                                    )
                                    
                                    
                                    &&
                                      
                                      
                                    (    
                                          ( rect1.LowerY() >= rect2.LowerY() && rect1.LowerY() <= rect2.UpperY() ) 
                                          
                                          ||
                                                
                                          ( rect1.UpperY() >= rect2.LowerY() && rect1.UpperY() <= rect2.UpperY() )
                                          
                                          || 
                                          
                                          ( rect1.LowerY() <= rect2.LowerY() && rect1.UpperY() >= rect2.UpperY() )
                                    );
                                    
                                    
      boolean rect2IntersectRect1 = (    
                                          ( rect2.LowerX() >= rect1.LowerX() && rect2.LowerX() <= rect1.UpperX() ) 
                                                
                                          ||
                                                
                                          ( rect2.UpperX() >= rect1.LowerX() && rect2.UpperX() <= rect1.UpperX() )    
                                          
                                          || 
                                          
                                          ( rect2.LowerX() <= rect1.LowerX() && rect2.UpperX() >= rect1.UpperX() )
                                    )
                                    
                                    
                                    &&
                                      
                                      
                                    (    
                                          ( rect2.LowerY() >= rect1.LowerY() && rect2.LowerY() <= rect1.UpperY() ) 
                                          
                                          ||
                                          
                                          ( rect2.UpperY() >= rect1.LowerY() && rect2.UpperY() <= rect1.UpperY() )    
                                          
                                          || 
                                          
                                          ( rect2.LowerY() <= rect1.LowerY() && rect2.UpperY() >= rect1.UpperY() )
                                    );
      
      return rect1IntersectRect2 || rect2IntersectRect1;
    }
    else
    {
      // make sure col1 is the rectangle and col2 is the circle
      
      if(col1 instanceof CircleCollider)
      {
        Collider temp = col1;
        col1 = col2;
        col2 = temp;
      }
      
      RectangleCollider rect = (RectangleCollider) col1;
      CircleCollider circle = (CircleCollider) col2;
      
      // get the closestpoint within the rectangle to the center of the circle
      // and check if the distance is less than the radius
      
      PVector closestpointinrect = rect.GetClosestPointInRect(circle.Position);
      
      return PVector.sub(closestpointinrect, circle.Position).mag() <= circle.Radius;
    }
  }
  
  public static float SgnStar (float x)
  {
    return x < 0 ? -1 : 1;
  }
  
  public static int GetAmmountRayCircleInterceptionPoints(Ray ray, CircleCollider circle)
  {
    Ray newray = ray.Copy();
    newray.Move(new PVector(-circle.Position.x, -circle.Position.y));
    
    float incidience = (float) Math.pow((float)circle.Radius, 2) * newray.DistanceSquared - (float) Math.pow((float)newray.Determinant, 2);
    
    if(incidience < 0)
    {
      return 0;
    }
    else if(incidience == 0)
    {
      return 1;
    }
    else
    {
      return 2;
    }
  }
  
  public static ArrayList<PVector> GetRayCircleInterceptionPoints(Ray ray, CircleCollider circle)
  {   
    Ray newray = ray.Copy();
    
    // since this method assumes that the circle is in the origin the ray has to be moved there
    
    newray.Move(new PVector(-circle.Position.x, -circle.Position.y));
    
    int countpoints = GetAmmountRayCircleInterceptionPoints(ray, circle);
    
    if(countpoints == 0)
    {
      return null;
    }
    
    ArrayList<PVector> points = new ArrayList<PVector>();
        
    if(countpoints == 1)
    {
      points.add(new PVector(newray.Determinant * newray.dy / newray.DistanceSquared, - newray.Determinant * newray.dx / newray.DistanceSquared)
          .add(circle.Position) // translate by the position since the ray and circle were in the origin
        );
    }
    else
    {
      float constant = (float)Math.sqrt(Math.pow(circle.Radius, 2) * newray.DistanceSquared - Math.pow(newray.Determinant, 2));

      float x1 = (newray.Determinant * newray.dy + SgnStar(newray.dy) * newray.dx * constant) / newray.DistanceSquared;
      float y1 = (- newray.Determinant * newray.dx + (float)Math.abs(newray.dy) * constant) / newray.DistanceSquared;
      float x2 = (newray.Determinant * newray.dy - SgnStar(newray.dy) * newray.dx * constant) / newray.DistanceSquared;
      float y2 = (- newray.Determinant * newray.dx - (float)Math.abs(newray.dy) * constant) / newray.DistanceSquared;
      
      // translate by the position since the ray and circle were in the origin
      
      points.add(new PVector(x1, y1).add(circle.Position));
      points.add(new PVector(x2, y2).add(circle.Position));
    }
    
    return points;
  }
  
  public static ArrayList<PVector> CalculateRayBoxInterceptions(Ray ray, RectangleCollider rect)
  {
    ArrayList<PVector> intersectionpoints = new ArrayList<PVector>();
    
    float upperx = rect.UpperX();
    float uppery = rect.UpperY();
    float lowerx = rect.LowerX();
    float lowery = rect.LowerY();
    
    float factorlowerbounds = (lowery - ray.StartPoint.y) / ray.Direction.y;
    PVector lowerbounds = ray.StartPoint.copy().add(PVector.mult(ray.Direction, factorlowerbounds));
    
    if(lowerbounds.x >= lowerx && lowerbounds.x <= upperx)
    {
      intersectionpoints.add(lowerbounds);
    }
    
    float factorupperbounds = (uppery - ray.StartPoint.y) / ray.Direction.y;
    PVector upperbounds = ray.StartPoint.copy().add(PVector.mult(ray.Direction, factorupperbounds));
    
    if(upperbounds.x >= lowerx && upperbounds.x <= upperx)
    {
      intersectionpoints.add(upperbounds);
    }
    
    float factorleftbounds = (lowerx - ray.StartPoint.x) / ray.Direction.x;
    PVector leftbounds = ray.StartPoint.copy().add(PVector.mult(ray.Direction, factorleftbounds));
    
    if(leftbounds.y >= lowery && leftbounds.y <= uppery)
    {
      intersectionpoints.add(leftbounds);
    }
    
    float factorrightbounds = (upperx - ray.StartPoint.x) / ray.Direction.x;
    PVector rightbounds = ray.StartPoint.copy().add(PVector.mult(ray.Direction, factorrightbounds));
    
    if(rightbounds.y >= lowery && rightbounds.y <= uppery)
    {
      intersectionpoints.add(rightbounds);
    }
    
    return intersectionpoints.size() < 0 ? null : intersectionpoints;
  }
}
