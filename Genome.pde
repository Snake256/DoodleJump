class Genome
{  
  private ArrayList<Connection> connections;
  
  // Contains all of the Connection Genes.
  public ArrayList<Connection> GetConnections()
  {
    return this.connections;
  }
  
  private ArrayList<Node> nodes;
  
  // Contains all of the Node Genes.
  public ArrayList<Node> GetNodes()
  {
    return this.nodes;
  }
  
  private ArrayList<Bias> biases;
  
  // Contains all of the Bias Genes.
  public ArrayList<Bias> GetBiases()
  {
    return this.biases;
  }
  
  private int inputs;
  
  // Contains the Number of Input Nodes.
  public int GetInputs()
  {
    return this.inputs;
  }

  private int outputs;
  
  // Contains the Number of Output Nodes.
  public int GetOutputs()
  {
    return this.outputs;
  }

  private int maxmutationattempts;

  public void SetMaxMutationAttempts(int value) throws IllegalArgumentException
  {
    if (value < 1)
    {
      throw new IllegalArgumentException("MaxMutationAttempts has to be greater than 1.");
    } else
    {
      this.maxmutationattempts = value;
    }
  }
  
  // Just in case Mutation is impossible in one Network, there are a limited ammount of attempts so it doesn't keep trying infinitely.
  public int GetMaxMutationAttempts()
  {
    return this.maxmutationattempts;
  }
  
  // Returns the biggest innovationnumber in the genome
  public int GetMaxinnovation()
  {
    int maxinnovation = 0;
    
    // look through all of the connections
    for(Connection c : this.GetConnections())
    {
      if (c.GetInnovationnumber() > maxinnovation)
      {
        maxinnovation = c.GetInnovationnumber();
      }
    }
    
    // look through all the biases
    for (Bias b : this.GetBiases())
    {
      if (b.GetInnovationnumber() > maxinnovation)
      {
        maxinnovation = b.GetInnovationnumber();
      }
    }

    return maxinnovation;
  }

  public Genome()
  {
    this.connections = new ArrayList<Connection>();
    this.biases = new ArrayList<Bias>();
    this.nodes = new ArrayList<Node>();
    this.nextnodenumber = 1;
  }

  public Genome(int inputs, int outputs, int maxmutationattempts) throws IllegalArgumentException
  {
    if (inputs < 1)
    {
      throw new IllegalArgumentException("There has to be at least one input node.");
    }
    if (outputs < 1)
    {
      throw new IllegalArgumentException("There has to be at least one ouput node.");
    }
    if (maxmutationattempts < 1)
    {
      throw new IllegalArgumentException("Genome needs at least one mutation attempt.");
    }

    this.connections = new ArrayList<Connection>();
    this.biases = new ArrayList<Bias>();

    this.nodes = new ArrayList<Node>();

    for (int i = 0; i < inputs; i++)
    {
      this.AddNode(Nodetype.Input);
    }

    for (int i = 0; i < outputs; i++)
    {
      this.AddNode(Nodetype.Output);
    }

    this.SetMaxMutationAttempts(maxmutationattempts);
  }

  public Genome(ArrayList<Node> nodes, int maxmutationattempts)
  {
    if (nodes != null)
    {
      this.nodes = nodes;
      for (Node n : this.GetNodes())
      {
        if (n.GetType() == Nodetype.Input)
        {
          this.inputs++;
        }
        else if (n.GetType() == Nodetype.Output)
        {
          this.outputs++;
        }
      }
    }
    else
    {
      this.nodes = new ArrayList<Node>();
    }
    this.connections = new ArrayList<Connection>();
    this.biases = new ArrayList<Bias>();
    this.nextnodenumber = this.GetNodes().size() + 1;
    this.SetMaxMutationAttempts(maxmutationattempts);
  }

  // Represents the ID the node that is next added receives.
  private int nextnodenumber = 1;

  // Adds a Node and gives it an incremental ID and returns the ID. Warning: It is usually not a good idea to add an input or output node outside the constructor using this method.
  public int AddNode(Nodetype type)
  {
    this.GetNodes().add(new Node(this.nextnodenumber, type));
    if(type == Nodetype.Input)
    {
      this.inputs++;
    }
    else if (type == Nodetype.Output)
    {
      this.outputs++;
    }
    return this.nextnodenumber++;
  }

  // Gets the node with the specified ID.
  public Node GetNode(int id)
  {
    for(Node wn : this.GetNodes())
    {
      if (wn.GetID() == id)
      {
        return wn;
      }
    }

    return null;
  }
  
  public boolean CanAddConnection(Connection contoadd)
  {
    if (this.ContainsGene(contoadd.GetInnovationnumber())) // if a gene with the same innovationnumber already exists the connection cannot be added
    {
      return false;
    }

    Node node1 = this.GetNode(contoadd.GetSourceNodeID());
    Node node2 = this.GetNode(contoadd.GetTargetNodeID()); 

    if (node1 == null | node2 == null) // node/s don't exist
    {
      return false;
    } 

    // There can't be a connection from one node to itself.
    if (node1 == node2)
      return false;

    // An input node can't go into another input node
    // Same applies for output nodes.
    if ((node1.GetType() == Nodetype.Input || node1.GetType() == Nodetype.Output) && node1.GetType() == node2.GetType())
    {
      return false;
    }
    
    // Check if the new connection would cause a circular feed
    if (this.CheckDependency(node1.GetID(), node2.GetID()))
    {
      return false;
    }
    
    // A hidden or output node cannot connect back to the input layer
    if (node2.GetType() == Nodetype.Input)
    {
      return false;
    }
    
    //An output node cannot connect back to the input or hidden layer
    if (node1.GetType() == Nodetype.Output)
    {
      return false;
    }

    if (!this.ContainsConnection(contoadd.GetSourceNodeID(), contoadd.GetTargetNodeID())) // if the connection to be added doesn't already exit it can be added
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  // Adds a new Connection if allowed. This Method should only be used for modifying the start genome/copying a genome/other uses...
  public boolean AddConnection(Connection contoadd)
  {
    if(this.CanAddConnection(contoadd))
    {
      this.GetConnections().add(contoadd);
      return true;
    }
    else
    {
      return false;
    }
  }
  
  // Adds a new Connection and assigns an incremental innovationnumber. For this to work the Innovationnumber in contoadd has to be set to 0.
  public boolean AddConnection(Connection contoadd, InnovationMachine im)
  {
    im.GetInnovation(contoadd); //assigns the connection an innovationnumber
    if(this.CanAddConnection(contoadd))
    {
      this.GetConnections().add(contoadd);
      return true;
    }
    else
    {
      return false;
    }
  }
  
  // Returns true if the specified node already has a bias
  public boolean ContainsBias(int nodeid)
  {
    for(Bias b : this.GetBiases())
    {
      if (b.GetNode() == nodeid) // if there is already a bias on the specified node
      {
        return true;
      }
    }

    return false;
  }
  
  // Gets the bias from the specified node
  public Bias GetBias(int nodeid)
  {
    for (Bias b : this.GetBiases())
    {
      if (b.GetNode() == nodeid)
      {
        return b;
      }
    }

    return null;
  }
  
  // Gets the Bias with the specified innovation number
  public Bias GetBiasGene(int innovationnumber)
  {
    for (Bias b : this.GetBiases())
    {
      if (b.GetInnovationnumber() == innovationnumber)
      {
        return b;
      }
    }

    return null;
  }
  
  // Checks if it is possible to add the bias
  public boolean CanAddBias(Bias biastoadd)
  {
    return !this.ContainsBias(biastoadd.GetNode()) && !this.ContainsGene(biastoadd.GetInnovationnumber());
  }
  
  // Adds a new Bias. This method should only be used for creating a startgenome/copying a genome/...
  public boolean AddBias(Bias b)
  {
    if (this.CanAddBias(b))
    {
      this.GetBiases().add(b);
      return true;
    }
    else
    {
      return false;
    }
  }
  
  // Adds a bias and assigns an incremental innovationnumber. For this to work b has to have an innovationnumber of 0.
  public boolean AddBias(Bias b, InnovationMachine im)
  {
    im.GetInnovation(b);
    if(this.CanAddBias(b))
    {
      this.GetBiases().add(b);
      return true;
    }
    else
    {
      return false;
    }
  }

  // Checks if there is already an existing connection with matching source and target node
  public boolean ContainsConnection(int source, int target)
  {
    Connection connectionToCompareTo = new Connection(source, target, true, 0, 0);

    for(Connection c : this.GetConnections())
    {
      if (c.equals(connectionToCompareTo))
      {
        return true;
      }
    }

    return false;
  }

  // Returns true if node1 directly or indirectly received input from node2.
  public boolean CheckDependency(int node1, int node2)
  {
    boolean isDependantOnNode2 = false;

    // Find all the connections to node1...
    ArrayList<Connection> connectionsToNode1 = FindConnectionsToNode(node1);

    for (Connection cg : connectionsToNode1)
    {
      if (cg.IsExpressed)
      {
        // ...find the source/neighbour nodes from that connection
        Node neighbourNode = GetNode(cg.GetSourceNodeID());

        if (neighbourNode.GetID() == node2) // ...if one of those nodes has node2 as their id, then node1 is dependant on node2
        {
          return true;
        }

        isDependantOnNode2 = CheckDependency(neighbourNode.GetID(), node2); // do this recursively so indirect dependencies can be found

        if (isDependantOnNode2)
        {
          return true;
        }
      }
    }

    return isDependantOnNode2;
  }

  // Finds all the Connections that go into the specified Node.
  public ArrayList<Connection> FindConnectionsToNode(int id)
  {
    ArrayList<Connection> connectionsToNode = new ArrayList<Connection>();

    for (Connection cg : this.GetConnections())
    {
      if (cg.GetTargetNodeID() == id)
      {
        connectionsToNode.add(cg);
      }
    }

    return connectionsToNode;
  }

  // Finds all the Connections that go out of the specified Node.
  public ArrayList<Connection> FindConnectionsFromNode(int number)
  {
    ArrayList<Connection> connectionsFromNode = new ArrayList<Connection>();

    for (Connection cg : this.GetConnections())
    {
      if (cg.GetSourceNodeID() == number)
      {
        connectionsFromNode.add(cg);
      }
    }

    return connectionsFromNode;
  }

  /// Returns a ArrayList of all Nodes that belong to the same Nodetype as specified.
  public ArrayList<Node> FindNodesOfType(Nodetype type)
  {
    ArrayList<Node> ngs = new ArrayList<Node>();

    for (Node ng : this.GetNodes())
    {
      if (ng.GetType() == type)
      {
        ngs.add(ng);
      }
    }

    return ngs;
  }

  /// Replaces an existing connection with a new node and adds two connections.
  public void AddNodeMutation(InnovationMachine im)
  {
    if (this.GetConnections().size() == 0)
    {
      // no connections to replace
      return;
    }

    // Whenever a new Node is added, a previous Connection is replaced.

    int attemptcount = 1;
    Connection connectionToReplace = null;

    do
    {
      Connection randomConnection = this.GetConnections().get(round(random(0, 1) * (this.GetConnections().size() - 1)));

      if (randomConnection != null && randomConnection.IsExpressed)
      {
        connectionToReplace = randomConnection;
      }
    } while (connectionToReplace != null && attemptcount++ < this.GetMaxMutationAttempts());

    if (connectionToReplace == null)
    {
      return; // no connection to replace found
    }

    int newNodeID = this.AddNode(Nodetype.Hidden);

    // The connection leading into the new node has a weight of 1, and the on out a weight the weight of the old connection

    ArrayList<Connection> connectionstoadd = new ArrayList<Connection>();

    connectionstoadd.add(new Connection(connectionToReplace.GetSourceNodeID(), newNodeID, true, 0, 1));
    connectionstoadd.add(new Connection(newNodeID, connectionToReplace.GetTargetNodeID(), true, 0, connectionToReplace.Weight));

    for (Connection connectiontoadd : connectionstoadd)
    {
      this.AddConnection(connectiontoadd, im); // Add the new connections
    }

    connectionToReplace.IsExpressed = false;
  }

  // Randomly adjusts the weights of the genome
  public void AdjustWeightMutation()
  {
    for(Connection c : this.GetConnections())
    {
      float adjustionType = random(0, 1);

      if (adjustionType < 0.1f)
      {
        // Assign the connection a random value between -1 and 1

        c.Weight = random(0, 1) * 2 - 1;
      }
      else
      {
        // Nudge the existing value
        
        c.Weight += randomGaussian() / 10;

        if (c.Weight > 1)
        {
          c.Weight = 1;
        }
        else if (c.Weight < -1)
        {
          c.Weight = -1;
        }
      }
    }
  }
  
  // Adds a new random connection
  public void AddConnectionMutation(InnovationMachine im)
  {
    if (this.GetNodes().size() <= 0)
    {
      // not enough nodes to add a connection
      return;
    }

    int attempts = 1;
    do
    {
      // find random nodes for the connection
      int from = round(random(0, 1) * (this.GetNodes().size() - 1)) + 1;
      int to = round(random(0, 1) * (this.GetNodes().size() - 1)) + 1;
      if (from == to)
      {
        continue;
      }
      Connection conToAdd = new Connection(from, to, true, 0, random(0, 1) * 2 - 1);
      if(this.AddConnection(conToAdd, im))
      {
        return; // if a connection was succesfully added then return
      }
    } 
    while (attempts++ < this.GetMaxMutationAttempts());
  }
  
  // adds a new random bias
  public void AddBiasMutation(InnovationMachine im)
  {
    if (this.GetNodes().size() == 0)
    {
      return; // no nodes to add biases to
    }

    int attempts = 1;
    do
    {
      int node = round(random(0, 1) * (this.GetNodes().size() - 1)) + 1; // find a random node
      Bias biastoadd = new Bias(node, random(0, 1) * 2 - 1, 0);
      if(this.AddBias(biastoadd, im))
      {
        return; // if the bias was added succesfully then return
      }
    } 
    while (attempts++ < this.GetMaxMutationAttempts());
  }

  // adjusts the existing biases
  public void AdjustBiasMutation()
  {
    for(Bias biastoadjust : this.GetBiases())
    {                
      float adjustionType = random(0, 1);

      if (adjustionType < 0.1f)
      {
        // Assign the bias a random value between -1 and 1 10% of the time

        biastoadjust.Value = random(0, 1) * 2 - 1;
      }
      else
      {
        // Nudge the existing value 90% of the time

        biastoadjust.Value += randomGaussian() / 10;
        
        // keep the value within a certain range
        if (biastoadjust.Value > 1)
        {
          biastoadjust.Value = 1;
        }
        else if (biastoadjust.Value < -1)
        {
          biastoadjust.Value = -1;
        }
      }
    }
  }

  // enables/disables a random connection
  public void EnableDisableConnectionMutation()
  {
    if (this.GetConnections().size() == 0)
    {
      return; // no connections to enable/disable
    }

    Connection connectionToToggle;

    connectionToToggle = this.GetConnections().get(round(random(0, 1) * (this.GetConnections().size() - 1)));
    if(connectionToToggle != null)
    {
      // if a connection was found then toggle isexpressed
      connectionToToggle.IsExpressed = !connectionToToggle.IsExpressed;
    }
  }

  // returns if there is already a connection or bias gene with the specified innovationnumber
  public boolean ContainsGene(int innovationnumber)
  {
    for(Connection c : this.GetConnections())
    {
      if (c.GetInnovationnumber() == innovationnumber)
      {
        return true;
      }
    }

    for(Bias b : this.GetBiases())
    {
      if (b.GetInnovationnumber() == innovationnumber)
      {
        return true;
      }
    }

    return false;
  }

  // gets the connectiongene with the specified innovationnumber
  public Connection GetConnectionGene(int innovationnumber)
  {
    for(Connection c : this.GetConnections())
    {
      if (c.GetInnovationnumber() == innovationnumber)
      {
        return c;
      }
    }

    return null;
  }

  // returns a copy of the genome
  public Genome Copy()
  {
    ArrayList<Node> nodescopy = new ArrayList<Node>();
    for(Node n : this.GetNodes())
    {
      nodescopy.add(n.Copy());
    }
    Genome g = new Genome(nodescopy, this.GetMaxMutationAttempts());
    for(Connection c : this.GetConnections())
    {
      g.AddConnection(new Connection(c.GetSourceNodeID(), c.GetTargetNodeID(), c.IsExpressed, c.GetInnovationnumber(), c.Weight));
    }
    for(Bias b : this.GetBiases())
    {
      g.AddBias(new Bias(b.GetNode(), b.Value, b.GetInnovationnumber()));
    }
    return g;
  }

  @Override
  public String toString()
  {
    StringBuilder sb = new StringBuilder();
    sb.append("Input Nodes: " + this.GetInputs() + " Output Nodes: " + this.GetOutputs() + System.lineSeparator());
    sb.append("Max Mutation Attempts: " + this.GetMaxMutationAttempts() + System.lineSeparator());
    sb.append("Nodes:\n");
    for (Node wn : this.GetNodes())
    {
      sb.append(wn.toString());
    }
    sb.append(System.lineSeparator() + "Connections:\n");
    for(Connection con : this.GetConnections())
    {
      sb.append(con.toString());
    }
    sb.append(System.lineSeparator() + "Biases:\n");
    for(Bias b : this.GetBiases())
    {
      sb.append(b.toString());
    }
    return sb.toString();
  }
}
