class Network
{
  private Genome genome;

  public Genome GetGenome()
  {
      return this.genome;
  }

  private HashMap<Integer, Float> outputDataAtNode;

  private HashMap<Integer, Boolean> hasBeenCalculatedAtNode;

  public Network()
  {
    this(new Genome());
  }

  public Network(Genome genome)
  {
    this.genome = genome;
  }

  // Feeds all of the Input into the Network and calculates all of the Output at the Output Node.
  public float[] FeedForward(float[] input)
  {
    hasBeenCalculatedAtNode = new HashMap<Integer, Boolean>();
    outputDataAtNode = new HashMap<Integer, Float>();

    int currentinput = 0;
    for (Node ng : this.GetGenome().GetNodes())
    {
      if (ng.GetType() == Nodetype.Input)
      {
        outputDataAtNode.put(ng.GetID(), input[currentinput++]);
        Bias b = this.GetGenome().GetBias(ng.GetID());
        if (b != null)
        {
          outputDataAtNode.put(ng.GetID(), outputDataAtNode.get(ng.GetID()) + b. Value); // ---------
        }
        hasBeenCalculatedAtNode.put(ng.GetID(), true);
      }
    }

    ArrayList<Node> outputnodes = this.GetGenome().FindNodesOfType(Nodetype.Output);
    float[] output = new float[outputnodes.size()];

    for (int i = 0; i < outputnodes.size(); i++)
    {
      // Calculates the output of the specified node.

      output[i] = CalculateOutputAtNode(outputnodes.get(i).GetID(), input);
    }

    return output;
  }

  // Calculates the Output at the specified Node.
  private float CalculateOutputAtNode(int number, float[] input)
  {
    // if the input has already been calculated and saved it can just be returned.

    if (hasBeenCalculatedAtNode.containsKey(number) && hasBeenCalculatedAtNode.get(number))
    {
      return outputDataAtNode.get(number);
    }

    ArrayList<Connection> connectionsToNode = this.GetGenome().FindConnectionsToNode(number);

    // Add a new Entry into the dictionary for the input data if it doesn't alreay exist

    if (!outputDataAtNode.containsKey(number))
    {
      outputDataAtNode.put(number, 0f);
    }

    for (Connection con : connectionsToNode)
    {
      //Adds up all of the inputs that go into this node. This can be done recursively.
      if (con.IsExpressed)
      {
        outputDataAtNode.put(number, outputDataAtNode.get(number) + CalculateOutputAtNode(con.GetSourceNodeID(), input) * con.Weight);
      }
    }

    Bias b = this.GetGenome().GetBias(number);

    if (b != null)
    {
      outputDataAtNode.put(number, outputDataAtNode.get(number) + b.Value);
    }

    outputDataAtNode.put(number, Sigmoid(outputDataAtNode.get(number)));

    // For efficiency this keeps track of if we already calculated the value at the given node.

    if (!hasBeenCalculatedAtNode.containsKey(number))
    {
      hasBeenCalculatedAtNode.put(number, true);
    }

    return outputDataAtNode.get(number);
  }

  // Sigmoid is the activation function

  private float Sigmoid(float x)
  {
    return (float)1 / (float)(1 + (float)exp(-4.9f * x));
  }
}
