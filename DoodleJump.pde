float GridSize = 60;
float BackgroundGridSize = 20;

float HeightWorldUnits;
float WidthWorldUnits;

float objectscale = 0.85f;

float PlatformWidth = 1.5f * objectscale;
float PlatformHeight = 0.3529411765f * objectscale;
float PlatformVelocity = 1f;

float PlatformBoundIncrease;

float Gravity = -24f;
float PlayerMaxYVelocity = 17f;
float PlayerVelocityX = 7f;

float PlayerWidth = 1.43f * objectscale;
float PlayerHeight = 1.43f * objectscale;

boolean ai = true;
int Populationsize = 175;
NetworkVisualizer NetworkVisualizer;

boolean ShowColliders = false;
boolean ShowSpacialInfo = true;
boolean ShowNetwork = true;
boolean PlayersCanGoOffBounds = true;
boolean left = false;
boolean right = false;

float VerticalCameraOffset;
float VerticalCameraTarget;
float CameraLerpTime = 50;

Level level;

int time;

PImage Platform;
PImage PlatformMoving;
PImage PlatformDisappearing;
PImage Player;

ArrayList<Ray> Rays;
boolean ShowRays = true;

void setup()
{  
  size(480, 720, P2D);
  textFont(createFont("Liberation Sans", 36));
  HeightWorldUnits = height / GridSize;
  WidthWorldUnits = width / GridSize;
  PlatformBoundIncrease = HeightWorldUnits * 2;
  InitializeRays();
  level = new Level();
  LoadImages();  
  time = millis();
}

void InitializeRays()
{
  // Rays that define the player's "vision"
  Rays = new ArrayList<Ray>();
  Rays.add(new Ray(new PVector(0, 1)));
  Rays.add(new Ray(new PVector(1, 1)));
  Rays.add(new Ray(new PVector(1, 0)));
  Rays.add(new Ray(new PVector(1, -1)));
}

void LoadImages()
{
  Platform = loadImage(sketchPath() + "/platform.png");
  Player = loadImage(sketchPath() + "/player.png");
  PlatformMoving = loadImage(sketchPath() + "/platform_moving.png");
  PlatformDisappearing = loadImage(sketchPath() + "/platform_disappearing.png");
}

void draw()
{
  Update();
  Draw();
}

void keyPressed()
{
  if(keyCode == LEFT)
  {
    left = true;
  }
  
  if(keyCode == RIGHT)
  {
    right = true;
  }
}

void keyReleased()
{
  if(keyCode == LEFT)
  {
    left = false;
  }
  
  if(keyCode == RIGHT)
  {
    right = false;
  }
}

void Update()
{
  if(level.AllPlayersDead())
  {
    level.Reset();
  }
  
  int currenttime = millis();
  int deltatime = currenttime - time;
  level.Update(deltatime);
  UpdateVerticalCameraOffset(deltatime);
  time = currenttime;
}

void UpdateVerticalCameraOffset(int deltatime)
{
  if(level.HighestAlivePlayer != null)
  {
    float playerscorescreenpos = level.HighestAlivePlayer.Score * GridSize;
    VerticalCameraTarget = Utilities.Clamp(playerscorescreenpos + height/2, height, Float.MAX_VALUE);
    VerticalCameraOffset = lerp(VerticalCameraOffset, VerticalCameraTarget, deltatime / CameraLerpTime);
  }
}

void Draw()
{
  DrawBackground();
  pushMatrix();
  translate(width/2, VerticalCameraOffset);
  scale(GridSize);
  strokeWeight(2 / GridSize);
  level.Draw();
  DrawHighestPlayerSpacialInfo();  
  popMatrix();
  DrawInfo();
  DrawNetwork();
}

void DrawHighestPlayerSpacialInfo()
{
  if(ShowSpacialInfo)
  {
    Player highestplayer = level.HighestAlivePlayer;
    if(highestplayer != null)
    {
      ArrayList<PVector> intersections = highestplayer.GetRayIntersections(level);
      stroke(0);
      strokeWeight(2 / GridSize);
      for(PVector p : intersections)
      {
        if(p != null)
        {
          line(highestplayer.Position.x, -highestplayer.Position.y, p.x, -p.y);
        }
      }
    }
  }
}

void DrawInfo()
{
  fill(0);
  textSize(36);
  text("Score: " + level.HighestAlivePlayer.Score, 20, 35);
  
  if(ai)
  {
    text("Generation: " + level.Population.GetCurrentgeneration(), 20, height - 35);
  }
}

void DrawNetwork()
{
  if(ai && ShowNetwork)
  {
    if(NetworkVisualizer == null || (level.HighestAlivePlayer instanceof AIPlayer && NetworkVisualizer.GetNVI().GetGenome() != ((AIPlayer) level.HighestAlivePlayer).Brain))
    {
      NetworkVisualizer = new NetworkVisualizer(((AIPlayer)level.HighestAlivePlayer).Brain, 250, 200);
    }
    
    pushMatrix();
    translate(width/2, height/3);
    NetworkVisualizer.Draw();
    popMatrix();
  }
}

void DrawBackground()
{
  background(255);
  stroke(143, 204, 211);
  strokeWeight(2);
  
  // Draw Vertical Lines
  
  for(int i = 0; i <= width; i += BackgroundGridSize)
  {
    line(i, 0, i, height);
  }
  
  // Draw Horizontal Lines
  
  for(int i = 0; i <= height; i += BackgroundGridSize)
  {
    line(0, i, width, i);
  }
}
