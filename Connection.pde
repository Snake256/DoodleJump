class Connection
{
  // Value represents the Weight of the Connection.
  public float Weight;

  private int sourcenodeid;
  
  // Indicates where the Connection starts.
  public int GetSourceNodeID()
  {
    return this.sourcenodeid;
  }

  private int targetnodeid;
  
  // Indicates where the Connection ends.
  public int GetTargetNodeID()
  {
    return this.targetnodeid;
  }
  
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

  // Gives information about whether or not the connection is enabled
  public boolean IsExpressed;

  public Connection()
  {
      this(-1, -2, false, -1, 0f);
  }

  public Connection(int sourcenodeid, int targetnodeid, boolean isexpressed, int innovationnumber, float value) throws IllegalArgumentException
  {
    if (sourcenodeid == targetnodeid)
    {
      throw new IllegalArgumentException("Connection cannot have the same source and target.");
    }

    this.sourcenodeid = sourcenodeid;
    this.targetnodeid = targetnodeid;
    this.IsExpressed = isexpressed;
    this.innovationnumber = innovationnumber;
    this.Weight = value;
  }

  @Override
  public boolean equals(Object obj)
  {
    if (obj instanceof Connection)
    {
      Connection conToCompareTo = (Connection)obj;
      return (this.GetSourceNodeID() == conToCompareTo.GetSourceNodeID())
        && (this.GetTargetNodeID() == conToCompareTo.GetTargetNodeID());
    }

    return false;
  }

  public Connection Copy()
  {
    return new Connection(this.GetSourceNodeID(), this.GetTargetNodeID(), this.IsExpressed, this.GetInnovationnumber(), this.Weight);
  }

  @Override
  public String toString()
  {
    return " SourcenodeID: " + this.GetSourceNodeID() + " TargetnodeID: " + this.GetTargetNodeID() +
      " IsExpressed: " + this.IsExpressed + " Innovationnumber: " + this.GetInnovationnumber() + " Value: " + this.Weight + System.lineSeparator();
  }
}
