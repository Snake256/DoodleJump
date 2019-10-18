class Bias
{
  private int innovationnumber;
  
  public void SetInnovationnumber(int value)
  {
    this.innovationnumber = value;
  }

  // Provides Info about the historical origion of the connection.
  public int GetInnovationnumber()
  {
    return this.innovationnumber;
  }
  
  // Value of the Bias
  public float Value;

  private int node;
  
  // Node the bias is atteched to
  public int GetNode()
  {
    return this.node;
  }

  public Bias(int node, float value, int innovationnumber)
  {
    this.node = node;
    this.Value = value;
    this.innovationnumber = innovationnumber;
  }
  
  // Creates a copy of the bias
  public Bias Copy()
  {
    return new Bias(this.GetNode(), this.Value, this.GetInnovationnumber());
  }

  @Override
  public String toString()
  {
    return "Node: " + this.GetNode() + " Innovationnumber: " + this.GetInnovationnumber() + "Value: " + this.Value + System.lineSeparator();
  }

  @Override
  public boolean equals(Object obj)
  {
    if (obj instanceof Bias)
    {
      Bias biasToCompareTo = (Bias)obj;
      return (this.GetNode() == biasToCompareTo.GetNode());
    }

    return false;
  }
}
