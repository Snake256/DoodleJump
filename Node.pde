public enum Nodetype
{
  Input, Hidden, Output
}

class Node
{  
  private int id;
  
  // Identification number of the node
  public int GetID()
  {
    return this.id;
  }

  private Nodetype type;

  // Gives Info about what the node is used for.
  public Nodetype GetType()
  {
    return this.type;
  }

  public Node(int id, Nodetype type)
  {
    this.id = id;
    this.type = type;
  }

  public Node Copy()
  {
    return new Node(this.GetID(), this.GetType());
  }

  @Override
  public String toString()
  {
    return "ID: " + this.GetID() + "\nNodetype: " + this.GetType() + System.lineSeparator();
  }
}
