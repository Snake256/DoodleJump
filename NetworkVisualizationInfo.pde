class NetworkVisualizationInfo
{
  private ArrayList<ArrayList<Node>> layers;
  
  public ArrayList<ArrayList<Node>> GetLayers()
  {
    return this.layers;
  }
  
  private HashMap<Node, PVector> positionmap;
  
  public HashMap<Node, PVector> GetPositionmap()
  {
    return this.positionmap;
  }
  
  private Genome genome;
  
  public Genome GetGenome()
  {
    return this.genome;
  }
  
  public void SetGenome(Genome g)
  {
    this.genome = g;
    this.Recalculate();
  }
  
  public void Recalculate()
  {
    if(this.genome != null)
    {
      this.layers = new ArrayList<ArrayList<Node>>();
      
      // seperating all of the nodes into layers starting from the inputlayer
      
      ArrayList<Node> inputnodes = this.genome.FindNodesOfType(Nodetype.Input);
      
      HashMap<Node, Integer> layermap = new HashMap<Node, Integer>();
      
      for(Node node : inputnodes)
      {
        InsertNode(layermap, node, 1);
      }
      
      ArrayList<Node> outputnodes = this.genome.FindNodesOfType(Nodetype.Output);
      int layercount = 0;
      
      for(Node key_ : layermap.keySet())
      {
        int layer = layermap.get(key_);
        if(layer > layercount)
        {
          layercount = layer;
        }
      }
      
      layercount++;
      
      for(Node node : outputnodes)
      {
        InsertNode(layermap, node, layercount);
      }
            
      for(int i = 0; i < layercount; i++)
      {
        this.layers.add(new ArrayList<Node>());
      }
      
      for(Node key_ : layermap.keySet())
      {
        int index = layermap.get(key_) - 1;
        ArrayList<Node> nodelayer = this.layers.get(index);
        nodelayer.add(key_);
      }
      
      CalculateNodePositions();
    }
  }
  
  private void InsertNode(HashMap<Node, Integer> layermap, Node nodetoinsert, int layer)
  {
    if(layermap.containsKey(nodetoinsert))
    {
      int layerofnode = layermap.get(nodetoinsert);
      if(layerofnode <= layer)
      {
        InsertNode2(layermap, nodetoinsert, layer);
      }
    }
    else
    {
      InsertNode2(layermap, nodetoinsert, layer);
    }
  }
  
  private void InsertNode2(HashMap<Node, Integer> layermap, Node nodetoinsert, int layer)
  {
    layermap.put(nodetoinsert, layer);
    ArrayList<Connection> connections = this.genome.FindConnectionsFromNode(nodetoinsert.GetID());
    for(Connection connection : connections)
    {
      Node nodenextlayer = this.genome.GetNode(connection.GetTargetNodeID());
      if(nodenextlayer.GetType() == Nodetype.Hidden) // Output Nodes are added last
      {
        InsertNode(layermap, nodenextlayer, layer + 1);  
      }
    }
  }
  
  public void CalculateNodePositions()
  {
    if(this.GetLayers() != null)
    {
      this.positionmap = new HashMap<Node, PVector>();
      
      float gapx = this.GetWidth() / (float) (this.GetLayers().size() + 1);
      float gapy;
      int currentlayer = 1;
      int currentnode = 1;
      
      for(ArrayList<Node> layer : this.GetLayers())
      {
        gapy = this.GetHeight() / (float) (layer.size() + 1);
        for(Node node : layer) 
        {
          this.positionmap.put(node, new PVector(currentlayer * gapx, currentnode * gapy, 0));
          currentnode++;
        }
        currentnode = 1;
        currentlayer++;
      }
    }
  }
  
  private int _width;
  
  public int GetWidth()
  {
    return this._width;
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
  
  public NetworkVisualizationInfo(Genome g, int _width, int _height)
  {
    this.SetGenome(g);
    this.SetWidth(_width);
    this.SetHeight(_height);
    this.Recalculate();
  }
  
  @Override
  public String toString()
  {
    String str = "";
    int layer = 1;
    for(ArrayList<Node> list : this.layers)
    {      
      str += "---------------------------------------------\n";
      str += "Layer: " + layer + "\n";
      
      for(Node n : list)
      {
        str += n;
      }
      
      layer++;
    }
    
    return str == "" ? "no data" : str + "---------------------------------------------\n";
  }
}
