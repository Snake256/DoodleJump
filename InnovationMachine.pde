class InnovationMachine
{
  private int innovation;

  public int GetInnovation()
  {
      return this.innovation;
  }

  private ArrayList<Connection> existingconnections;

  private ArrayList<Bias> existingbiases;
  
  // assigns the connection an innovationnumber and adds the connection to the exisitingconnections if it doesnt already exist
  public void GetInnovation(Connection c)
  {
    for(Connection con : this.existingconnections)
    {
      if (con.equals(c))
      {
        c.SetInnovationnumber(con.GetInnovationnumber());
        return;
      }
    }
    c.SetInnovationnumber(this.innovation++);
    this.AddConnection(c.Copy());
  }

  // assigns the bias an innovationnumber and adds the bias to the exisitingbiases if it doesnt already exist
  public void GetInnovation(Bias b)
  {
    for(Bias bias : this.existingbiases)
    {
      if (bias.equals(b))
      {
        b.SetInnovationnumber(bias.GetInnovationnumber());
        return;
      }
    }
    b.SetInnovationnumber(this.innovation++);
    this.AddBias(b.Copy());
  }
  
  public void AddConnection(Connection c)
  {
    if(!this.ContainsConnection(c))
    {
      this.existingconnections.add(c);
    }
  }
  
  public boolean ContainsConnection(Connection contofind)
  {
    for(Connection c : this.existingconnections)
    {
      if(c.equals(contofind))
      {
        return true;
      }
    }
    
    return false;
  }
  
  public void AddBias(Bias b)
  {
    if(!this.ContainsBias(b))
    {
      this.existingbiases.add(b);
    }
  }
  
  public boolean ContainsBias(Bias biastofind)
  {
    for(Bias b : this.existingbiases)
    {
      if(b.equals(biastofind))
      {
        return true;
      }
    }
    
    return false;
  }

  public void Reset()
  {
    this.existingconnections = new ArrayList<Connection>();
    this.existingbiases = new ArrayList<Bias>();
    this.innovation = startinnovation;
  }

  public InnovationMachine()
  {
    this(1);
  }
  
  private int startinnovation;
  
  public InnovationMachine(int startinnovation)
  {
    this.startinnovation = startinnovation;
    Reset();
  }
}
