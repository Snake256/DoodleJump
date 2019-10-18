class NetworkVisualizer
{
  private PGraphics NetworkGraphic;
  
  private NetworkVisualizationInfo nvi;
  
  public NetworkVisualizationInfo GetNVI()
  {
    return this.nvi;  
  }
  
  private int _width;
  
  public int GetWidth()
  {
    return this._width;
  }
  
  public void Draw()
  {
    imageMode(CENTER);
    image(NetworkGraphic, 0, 0);
  }
  
  private void DrawConnections()
  {
    HashMap<Node, PVector> positionmap = this.GetNVI().GetPositionmap();
    Genome genometodraw = this.GetNVI().GetGenome();
    NetworkGraphic.strokeWeight(3);
    for(Connection contodraw : genometodraw.GetConnections())
    {
      NetworkGraphic.strokeWeight(map(abs(contodraw.Weight), 0, 1, 4, 5.5f)); // connections with a higher abs value are drawn thicker
      if(contodraw.IsExpressed)
      {
        if(contodraw.Weight > 0)
        {
          NetworkGraphic.stroke(102, 255, 0);
        }
        else if(contodraw.Weight < 0)
        {
          NetworkGraphic.stroke(254, 27, 7);
        }
        else
        {
          NetworkGraphic.stroke(105, 105, 105);
        }
      }
      else
      {
        NetworkGraphic.stroke(105, 105, 105);
      }
      Node n1 = genometodraw.GetNode(contodraw.GetSourceNodeID());
      Node n2 = genometodraw.GetNode(contodraw.GetTargetNodeID());
      PVector n1pos = positionmap.get(n1);
      PVector n2pos = positionmap.get(n2);
      
      if(n1pos != null && n2pos != null)
      {
        NetworkGraphic.line(n1pos.x, n1pos.y, n2pos.x, n2pos.y);
      }
    }
  }
  
  private void DrawNodes()
  {
    NetworkGraphic.stroke(0);
    NetworkGraphic.textAlign(CENTER, CENTER);
    HashMap<Node, PVector> positionmap = this.GetNVI().GetPositionmap();
    NetworkGraphic.fill(255);
    NetworkGraphic.strokeWeight(3);
    for(Node _key : positionmap.keySet())
    {
       PVector nodeposition = positionmap.get(_key);
       NetworkGraphic.ellipse(nodeposition.x, nodeposition.y, 30, 30);
    }
    NetworkGraphic.fill(0);
    for(Node _key : positionmap.keySet())
    {
       PVector nodeposition = positionmap.get(_key);
       NetworkGraphic.text(_key.GetID(), nodeposition.x , nodeposition.y);
    }
    NetworkGraphic.strokeWeight(1);
    NetworkGraphic.noFill();
  }
  
  private void CreateNetworkGraphic()
  {
    NetworkGraphic.beginDraw();
    NetworkGraphic.clear();
    this.DrawConnections();
    this.DrawNodes();
    NetworkGraphic.endDraw();
  }
  
  public void SetWidth(int value) throws IllegalArgumentException
  {
    if(value > 99)
    {
      this._width = value;
    }
    else
    {
      throw new IllegalArgumentException("Visualizer has to be at least 100 px. wide.");
    }  
  }
  
  private int _height;
  
  public int GetHeight()
  {
    return this._height; 
  }
  
  public void SetHeight(int value) throws IllegalArgumentException
  {
    if(value > 99)
    {
      this._height = value;
    }
    else
    {
      throw new IllegalArgumentException("Visualizer has to be at least 100 px. high.");
    }  
  }
  
  public NetworkVisualizer(Genome genome, int _width, int _height)
  {
    this.SetWidth(_width);
    this.SetHeight(_height);
    this.nvi = new NetworkVisualizationInfo(genome, this.GetWidth(), this.GetHeight());
    this.NetworkGraphic = createGraphics(this.GetWidth(), this.GetHeight());
    CreateNetworkGraphic();
  }
}
