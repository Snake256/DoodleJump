enum Parent
{
  G1, G2
}
  
static class GenomeHelper
{
  // returns how compatible 2 genomes are, so that they can be placed into species
  public static float GetCompatibilityDistance(Genome g1, Genome g2, float excessimportance, float disjointimportance, float averageweightdifferenceimportance)
  {
    if (g1 == null || g2 == null)
    {
      return Float.MAX_VALUE; // if both are null just return the max possible number because they cannot be compatible at all
    }
    
    // get all of the excess and disjoint genes for their count
    // could be optimised with a getexcess/dijointcount method
    
    ArrayList<Connection> excessconns = GenomeHelper.GetExcessConnections(g1, g2, Parent.G1);
    excessconns.addAll(GenomeHelper.GetExcessConnections(g1, g2, Parent.G2));
    
    ArrayList<Bias> excessbias = GenomeHelper.GetExcessBiases(g1, g2, Parent.G1);
    excessbias.addAll(GenomeHelper.GetExcessBiases(g1, g2, Parent.G2));

    ArrayList<Connection> disjointconns = GenomeHelper.GetDisjointConnections(g1, g2, Parent.G1);
    disjointconns.addAll(GenomeHelper.GetDisjointConnections(g1, g2, Parent.G2));
    
    ArrayList<Bias> disjointbias = GenomeHelper.GetDisjointBiases(g1, g2, Parent.G1);
    disjointbias.addAll(GenomeHelper.GetDisjointBiases(g1, g2, Parent.G2));
    
    int excessgenecount = excessconns.size() + excessbias.size();
    int disjointgenecount = disjointconns.size() + disjointbias.size();
    
    int g1genecount = g1.GetConnections().size() + g1.GetBiases().size();
    int g2genecount = g2.GetConnections().size() + g2.GetBiases().size();

    int N = g1genecount > g2genecount ? g1genecount : g2genecount;

    if (N < 20)
    {
      N = 1; // if the genomes are small 1 can be used for the ammount
    }
    
    //calculate the compatiblity distance
    float temp = excessimportance * (excessgenecount) / N + disjointimportance * (disjointgenecount) / N 
      + averageweightdifferenceimportance * GetAverageWeightDifference(g1, g2);

    return temp;
  }
  
  // returns all of the disjoint connection genes
  public static ArrayList<Connection> GetDisjointConnections(Genome g1, Genome g2, Parent parent)
  {
    ArrayList<Connection> connectiongenes = new ArrayList<Connection>();

    if (g1 == null || g2 == null)
    {
      return connectiongenes;
    }

    // g1 has to be the larger genome
    if (g2.GetMaxinnovation() > g1.GetMaxinnovation())
    {
      Genome temp = g1;
      g1 = g2;
      g2 = temp;
    }

    Genome gtofinddisjointsfrom;
    Genome otherg;
    
    // set what parents to get the disjoint genes from
    
    if (parent == Parent.G1)
    {
      gtofinddisjointsfrom = g1;
      otherg = g2;
    }
    else
    {
      otherg = g1;
      gtofinddisjointsfrom = g2;
    }

    for (Connection c : gtofinddisjointsfrom.GetConnections())
    {
      if (!otherg.ContainsGene(c.GetInnovationnumber()))
      {
        if (c.GetInnovationnumber() <= g2.GetMaxinnovation()) // if a gene is within the innovationrange of the smaller genome and it doesnt exist in the other genome its a disjoint gene
        {
          connectiongenes.add(c);
        }
      }
    }
    
    return connectiongenes;
  }
  
  // returns all of the disjoint bias genes
  public static ArrayList<Bias> GetDisjointBiases(Genome g1, Genome g2, Parent parent)
  {
    ArrayList<Bias> biasgenes = new ArrayList<Bias>();

    if (g1 == null || g2 == null)
    {
      return biasgenes;
    }

    // g1 has to be the larger genome
    if (g2.GetMaxinnovation() > g1.GetMaxinnovation())
    {
      Genome temp = g1;
      g1 = g2;
      g2 = temp;
    }

    Genome gtofinddisjointsfrom;
    Genome otherg;

    // set what parents to get the disjoint genes from

    if (parent == Parent.G1)
    {
      gtofinddisjointsfrom = g1;
      otherg = g2;
    } else
    {
      otherg = g1;
      gtofinddisjointsfrom = g2;
    }

    for (Bias b : gtofinddisjointsfrom.GetBiases())
    {
      if (!otherg.ContainsGene(b.GetInnovationnumber()))
      {
        if (b.GetInnovationnumber() <= g2.GetMaxinnovation()) // if a gene is within the innovationrange of the smaller genome and it doesnt exist in the other genome its a disjoint gene
        {
          biasgenes.add(b);
        }
      }
    }
    
    return biasgenes;
  }

  // returns all of the excess connection genes
  public static ArrayList<Connection> GetExcessConnections(Genome g1, Genome g2, Parent parent)
  {
    ArrayList<Connection> connectiongenes = new ArrayList<Connection>();

    if (g1 == null || g2 == null)
    {
      return connectiongenes;
    }

    // g1 has to be the larger genome
    if (g2.GetMaxinnovation() > g1.GetMaxinnovation())
    {
      Genome temp = g1;
      g1 = g2;
      g2 = temp;
    }

    Genome gtofinddisjointsfrom;
    Genome otherg;

    // set what parents to get the excess genes from

    if (parent == Parent.G1)
    {
      gtofinddisjointsfrom = g1;
      otherg = g2;
    }
    else
    {
      otherg = g1;
      gtofinddisjointsfrom = g2;
    }

    for (Connection c : gtofinddisjointsfrom.GetConnections())
    {
      if (!otherg.ContainsGene(c.GetInnovationnumber()))
      {
        if (c.GetInnovationnumber() > g2.GetMaxinnovation())  // if a gene is outside the innovationrange of the smaller genome and it doesnt exist in the other genome its a disjoint gene
        {
          connectiongenes.add(c);
        }
      }
    }
    
    return connectiongenes;
  }

  // returns all of the excess bias genes
  public static ArrayList<Bias> GetExcessBiases(Genome g1, Genome g2, Parent parent)
  {
    ArrayList<Bias> biasgenes = new ArrayList<Bias>();

    if (g1 == null || g2 == null)
    {
      return biasgenes;
    }

    // g1 has to be the larger genome
    if (g2.GetMaxinnovation() > g1.GetMaxinnovation())
    {
      Genome temp = g1;
      g1 = g2;
      g2 = temp;
    }

    Genome gtofinddisjointsfrom;
    Genome otherg;

    // set what parents to get the excess genes from

    if (parent == Parent.G1)
    {
      gtofinddisjointsfrom = g1;
      otherg = g2;
    }
    else
    {
      otherg = g1;
      gtofinddisjointsfrom = g2;
    }

    for (Bias b : gtofinddisjointsfrom.GetBiases())
    {
      if (!otherg.ContainsGene(b.GetInnovationnumber()))
      {
        if (b.GetInnovationnumber() > g2.GetMaxinnovation()) // if a gene is within the innovationrange of the smaller genome and it doesnt exist in the other genome its a disjoint gene
        {
          biasgenes.add(b);
        }
      }
    }
    
    return biasgenes;
  }

  // returns all of the matching connection genes
  public static ArrayList<Connection> GetMatchingConnections(Genome g1, Genome g2, Parent parent)
  {
    ArrayList<Connection> matchingconns = new ArrayList<Connection>();

    if (g1 == null || g2 == null)
    {
      return matchingconns;
    }

    for(Connection c : g2.GetConnections())
    {
      if (g1.ContainsGene(c.GetInnovationnumber())) // if the gene is in both of the genomes then it is a matching gene
      {
        matchingconns.add(parent == Parent.G1 ? g1.GetConnectionGene(c.GetInnovationnumber()) : c); // depending on what parent specified in the parameter add the matching gene
      }
    }
    
    return matchingconns;
  }
  
  // returns all of the matching bias genes
  public static ArrayList<Bias> GetMatchingBiases(Genome g1, Genome g2, Parent parent)
  {
    ArrayList<Bias> matchingbiases = new ArrayList<Bias>();

    if (g1 == null || g2 == null)
    {
      return matchingbiases;
    }

    for (Bias b : g2.GetBiases())
    {
      if (g1.ContainsGene(b.GetInnovationnumber())) // if the gene is in both of the genomes then it is a matching gene
      {
        matchingbiases.add(parent == Parent.G1 ? g1.GetBiasGene(b.GetInnovationnumber()) : b); // depending on what parent specified in the parameter add the matching gene
      }
    }
    
    return matchingbiases;
  }
  
  // returns the average weight difference
  public static float GetAverageWeightDifference(Genome g1, Genome g2)
  {
    if (g1 == null || g2 == null)
    {
      return 0;
    }

    float weightsum = 0;

    ArrayList<Connection> matchingconns1 = GenomeHelper.GetMatchingConnections(g1, g2, Parent.G1);
    ArrayList<Connection> matchingconns2 = GenomeHelper.GetMatchingConnections(g1, g2, Parent.G2);

    for (int i = 0; i < matchingconns1.size(); i++)
    {
      weightsum += abs(matchingconns1.get(i).Weight - matchingconns2.get(i).Weight);
    }

    return matchingconns1.size() > 0 ? weightsum / matchingconns1.size() : 0; // if there aren't any matchingconnections then return 0, otherwise there would be a 0 division exception
  }

  // returns a childgenome based on the parents
  public static Genome Crossover(Genome g1, Genome g2, float g1fitness, float g2fitness, PApplet p)
  {
    if (g1 == null || g2 == null)
    {
      throw new IllegalArgumentException("G1 and G2 cannot be null.");
    }

    // g1 has to be the !!!fitter!!! genome
    if (g2fitness > g1fitness)
    {
      Genome temp = g1;
      g1 = g2;
      g2 = temp;
    }

    Genome crossover;
    ArrayList<Node> nodes;

    if (g1.GetNodes().size() > g2.GetNodes().size())
    {
      nodes = new ArrayList<Node>();
      for (Node n : g1.GetNodes())
      {
        nodes.add(n.Copy());
      }
    }
    else
    {
      nodes = new ArrayList<Node>();
      for (Node n : g2.GetNodes())
      {
        nodes.add(n.Copy());
      }
    }
    
    DoodleJump n = new DoodleJump();
    crossover = n.new Genome(nodes, g1.GetMaxMutationAttempts());

    ArrayList<Connection> matchingconns1 = GenomeHelper.GetMatchingConnections(g1, g2, Parent.G1);
    ArrayList<Bias>  matchingbiases1 = GenomeHelper.GetMatchingBiases(g1, g2, Parent.G1);
    ArrayList<Connection> matchingconns2 = GenomeHelper.GetMatchingConnections(g1, g2, Parent.G2);
    ArrayList<Bias> matchingbiases2 = GenomeHelper.GetMatchingBiases(g1, g2, Parent.G2);

    for (int i = 0; i < matchingconns1.size(); i++)
    {
      crossover.AddConnection(n.new Connection(matchingconns1.get(i).GetSourceNodeID(), matchingconns1.get(i).GetTargetNodeID(), 
        p.random(0f, 1f) > 0.5 ? matchingconns1.get(i).IsExpressed : matchingconns2.get(i).IsExpressed, matchingconns1.get(i).GetInnovationnumber(),
        p.random(0f, 1f) > 0.5 ? matchingconns1.get(i).Weight : matchingconns2.get(i).Weight));
    }

    for (int i = 0; i < matchingbiases1.size(); i++)
    {
      crossover.AddBias(n.new Bias(matchingbiases1.get(i).GetNode(), p.random(0f, 1f) > 0.5 ? matchingbiases1.get(i).Value
        : matchingbiases2.get(i).Value, matchingbiases1.get(i).GetInnovationnumber()));
    }

    ArrayList<Connection> disjointconns;
    ArrayList<Bias> disjointbias;
    ArrayList<Connection> excessconns;
    ArrayList<Bias> excessbias;

    disjointconns = GetDisjointConnections(g1, g2, Parent.G1);
    disjointbias = GetDisjointBiases(g1, g2, Parent.G1);
    
    excessconns = GetExcessConnections(g1, g2,Parent.G1);
    excessbias = GetExcessBiases(g1, g2, Parent.G1);

    for (Connection c : disjointconns)
    {
      crossover.AddConnection(n.new Connection(c.GetSourceNodeID(), c.GetTargetNodeID(), c.IsExpressed, c.GetInnovationnumber(), c.Weight));
    }

    for (Connection c : excessconns)
    {
      crossover.AddConnection(n.new Connection(c.GetSourceNodeID(), c.GetTargetNodeID(), c.IsExpressed, c.GetInnovationnumber(), c.Weight));
    }

    for (Bias b : disjointbias)
    {
      crossover.AddBias(n.new Bias(b.GetNode(), b.Value, b.GetInnovationnumber()));
    }

    for (Bias b : excessbias)
    {
      crossover.AddBias(n.new Bias(b.GetNode(), b.Value, b.GetInnovationnumber()));
    }

    return crossover;
  }
}
