enum Chance
{
    AddNode, AddConnection, EnableDisableConenction, AdjustBias, AddBias, AdjustWeight, Mutate
}

class Population
{
    public HashMap<Integer, FitnessInfo> FittestGenome;
    
    private HashMap<Integer, ArrayList<Genome>> fittestgenomesingeneration;
  
    public HashMap<Integer, ArrayList<Genome>> GetFittestGenomesInGeneration()
    {
        return this.fittestgenomesingeneration;
    }
  
    private ArrayList<Species> species;
  
    public ArrayList<Species> GetSpecies()
    {
        return this.species;
    }
  
    private int currentgeneration;
    
    public int GetCurrentgeneration()
    {
      return this.currentgeneration;
    }
  
    private int currentspecies;
  
    private int currentgenome;
  
    private int populationsize;
    
    public void ResetGenomePointer()
    {
      this.currentspecies = 0;
      this.currentgenome = 0;
    }
  
    private HashMap<Chance, Float> chances;
  
    public HashMap<Chance, Float> GetChances()
    {
      return this.chances;
    }
  
    public int GetPopulationsize()
    {
      return this.populationsize;
    }
  
    private int inputnodes;
  
    public int GetInputnodes()
    {
        return this.inputnodes;
    }
    
    public void SetInputnodes(int value) throws IllegalArgumentException
    {
      if(value > 0)
      {
          this.inputnodes = value;
      }
      else
      {
          throw new IllegalArgumentException("Cannot set a value smaller than 1 as the ammount of input nodes.");
      }
    }
  
    private int outputnodes;
  
    public int GetOutputnodes()
    {
        return this.outputnodes;
    }
    
    private void SetOutputnodes(int value) throws IllegalArgumentException
    {
      if (value > 0)
      {
          this.outputnodes = value;
      }
      else
      {
          throw new IllegalArgumentException("Cannot set a value smaller than 1 as the ammount of output nodes.");
      }      
    }
    
    private int maxmutationattempts;
    
    public int GetMaxmutationAttempts()
    {
      return this.maxmutationattempts;
    }
    
    public void SetMaxmutationattempts(int value) throws IllegalArgumentException
    {
      if (value > 0)
      {
          this.maxmutationattempts = value;
      }
      else
      {
          throw new IllegalArgumentException("Cannot set a value smaller than 1 as the ammount of Max Mutation Attempts.");
      }
    }
  
    private float threshold;
    
    public float GetThreshold()
    {
      return this.threshold;
    }
    
    public void SetThreshold(float value) throws IllegalArgumentException
    {
      if (value > -1)
      {
        this.threshold = value;
      }
      else
      {
        throw new IllegalArgumentException("Cannot set a value smaller than 0 as the Threshold.");
      }
    }
  
    private float excessimportance;
    
    public float GetExcessImportance()
    {
      return this.excessimportance;
    }
    
    public void SetExcessImportance(float value)
    {
      if(value >= 0)
      {
        this.excessimportance = value;
      }
      else
      {
        throw new IllegalArgumentException("ExcessImportance has to be greater than or equal to 0.");
      }
    }
  
    private float disjointimportance;
    
    public float GetDisjointImportance()
    {
      return this.disjointimportance;
    }
    
    public void SetDisjointImportance(float value) throws IllegalArgumentException
    {
      if (value >= 0)
      {
          this.disjointimportance = value;
      }
      else
      {
          throw new IllegalArgumentException("DisjointImportance has to be greater than or equal to 0.");
      }
    }
    
    private float deltaweightimportance;
    
    public float GetDeltaWeightImportance()
    {
      return this.deltaweightimportance;
    }
    
    public void SetDeltaWeightImportance(float value) throws IllegalArgumentException
    {
      if (value >= 0)
      {
          this.deltaweightimportance = value;
      }
      else
      {
          throw new IllegalArgumentException("DeltaWeightImportance has to be greater than or equal to 0.");
      }
    }
  
    private Genome startgenome;
  
    private InnovationMachine innovationmachine;
  
    public InnovationMachine GetInnovationMachine()
    {
        return this.innovationmachine;
    }
  
    public Population(int populationsize, int inputnodes, int outputnodes, int maxmutationattempts, float threshold, float excessimportance, 
        float disjointimportance, float averageweightdiffimportance, HashMap<Chance, Float> chances)
    {
        this(populationsize, new Genome(inputnodes, outputnodes, maxmutationattempts), threshold, excessimportance, disjointimportance,
              averageweightdiffimportance, chances);
    }
  
    public Population(int populationsize, Genome startgenome, float threshold, float excessimportance, float disjointimportance,
        float averageweightdiffimportance, HashMap<Chance, Float> chances)
    {
        SetupChances(chances);
        this.maxmutationattempts = startgenome.GetMaxMutationAttempts();
        this.populationsize = populationsize;
        this.SetInputnodes(startgenome.GetInputs());
        this.SetOutputnodes(startgenome.GetOutputs());
        this.SetThreshold(threshold);
        this.SetDeltaWeightImportance(averageweightdiffimportance);
        this.SetDisjointImportance(disjointimportance);
        this.SetExcessImportance(excessimportance);
        this.startgenome = startgenome;
        this.innovationmachine = new InnovationMachine(this.startgenome.GetMaxinnovation() + 1);
        ResetPopulation();
    }
  
    private void SetupChances(HashMap<Chance, Float> chances)
    {
        // Set up the default chances
        this.chances = new HashMap<Chance, Float>();
        this.GetChances().put(Chance.Mutate, 1f);
        this.GetChances().put(Chance.AddBias, 0.05f);
        this.GetChances().put(Chance.AddConnection, 0.05f);
        this.GetChances().put(Chance.AddNode, 0.03f);
        this.GetChances().put(Chance.AdjustBias, 0.8f);
        this.GetChances().put(Chance.AdjustWeight, 0.8f);
        this.GetChances().put(Chance.EnableDisableConenction, 0f);
  
        // If other chances are specified override the default ones
        if(chances != null)
        {
          Object[] keys = chances.keySet().toArray();
          for(int i = 0; i < chances.size(); i++)
          {
            Chance _key = (Chance) keys[i];
            this.GetChances().put(_key, chances.get(_key));
          }
        }
    }
    
    public void ResetPopulation()
    {
        this.GetInnovationMachine().Reset();
        for(Connection c : this.startgenome.GetConnections())
        {
            this.GetInnovationMachine().AddConnection(c);
        }
        for(Bias b : this.startgenome.GetBiases())
        {
            this.GetInnovationMachine().AddBias(b);
        }
        this.species = new ArrayList<Species>();
        this.currentgeneration = 1;
        ResetGenomePointer();
  
        this.fittestgenomesingeneration = new HashMap<Integer, ArrayList<Genome>>();
        this.FittestGenome = new HashMap<Integer, FitnessInfo>();
        ArrayList<Genome> population = new ArrayList<Genome>();
        while (population.size() < this.GetPopulationsize())
        {
            Genome genometoadd = startgenome.Copy();
            genometoadd.AddConnectionMutation(this.GetInnovationMachine());
            population.add(genometoadd);
        }
        this.Speciate(population);
    }
  
    public int SharingFunction(float i)
    {
        if(i >= this.GetThreshold())
        {
            return 1;
        }
        else
        {
            return 0;
        }
    }
  
    public void SetFitness(Genome g, float fitness)
    {
        for(Species s : this.GetSpecies())
        {
            for(FitnessInfo fi : s.GetGenomes())
            {
                if (fi.Genome == g)
                {
                    fi.Fitness = fitness;
                    fi.SharedFitness = fitness / s.GetGenomes().size();
                    return;
                }
            }
        }
    }
  
    public Genome NextGenome()
    {
        Genome nextgenome = this.GetSpecies().get(this.currentspecies).GetGenomes().get(this.currentgenome).Genome;
        this.currentgenome++;
        if(this.GetSpecies().get(this.currentspecies).GetGenomes().size() <= this.currentgenome)
        {
            this.currentgenome = 0;
            this.currentspecies++;
            this.currentspecies %= this.GetSpecies().size();
        }
        return nextgenome;
    }
  
    public void NextGeneration(PApplet p)
    {
        ArrayList<Genome> population = new ArrayList<Genome>();
        float totalfitness = 0;
        this.GetFittestGenomesInGeneration().put(this.GetCurrentgeneration(), new ArrayList<Genome>());
  
        for (int i = 0; i < this.GetSpecies().size(); i++)
        {
            this.GetSpecies().get(i).CheckStaleness();
            if (this.GetSpecies().get(i).GetStaleness() >= 15)
            {
                if (this.GetSpecies().size() > 1)
                {
                    this.GetSpecies().remove(i--);
                    continue;
                }
            }
            this.GetSpecies().get(i).KillOffWorst();
            totalfitness += this.GetSpecies().get(i).GetTotalSharedFitness();
            FitnessInfo fittestgenomeinfo = this.GetSpecies().get(i).GetFittestGenome();
            if(this.FittestGenome.get(this.GetCurrentgeneration()) == null || this.FittestGenome.get(this.GetCurrentgeneration()).Fitness < fittestgenomeinfo.Fitness)
            {
              this.FittestGenome.put(this.GetCurrentgeneration(), fittestgenomeinfo);
            }
            this.GetFittestGenomesInGeneration().get(this.GetCurrentgeneration()).add(fittestgenomeinfo.Genome.Copy());
            population.add(fittestgenomeinfo.Genome.Copy());
        }
        this.currentgeneration++;
        while (population.size() < this.GetPopulationsize())
        {
            Genome offspring = this.CreateOffspring(random(0, 1) * totalfitness, p);
            this.Mutate(offspring);
            population.add(offspring);
        }
        Speciate(population);
    }
  
    public void Mutate(Genome g)
    {
        if (random(0, 1) <= this.GetChances().get(Chance.Mutate))
        {
            if (random(0, 1) <= this.GetChances().get(Chance.AddBias))
            {
                g.AddBiasMutation(this.GetInnovationMachine());
            }
            if (random(0, 1) <= this.GetChances().get(Chance.AddConnection))
            {
                g.AddConnectionMutation(this.GetInnovationMachine());
            }
            if (random(0, 1) <= this.GetChances().get(Chance.AddNode))
            {
                g.AddNodeMutation(this.GetInnovationMachine());
            }
            if (random(0, 1) <= this.GetChances().get(Chance.AdjustBias))
            {
                g.AdjustBiasMutation();
            }
            if (random(0, 1) <= this.GetChances().get(Chance.AdjustWeight))
            {
                g.AdjustWeightMutation();
            }
            if (random(0, 1) <= this.GetChances().get(Chance.EnableDisableConenction))
            {
                g.EnableDisableConnectionMutation();
            }
        }
    }
  
    private Genome CreateOffspring(float fitness, PApplet p)
    {
        Genome offspring = null;
        int speciescount = this.GetSpecies().size();
        for (Species s : this.GetSpecies())
        {
            if (fitness - s.GetTotalSharedFitness() <= 0 || s == this.GetSpecies().get(speciescount - 1))
            {
                offspring = s.CreateOffspring(p);
                return offspring;
            }
            else
            {
                fitness -= s.GetTotalSharedFitness();
            }
        }
        
        return offspring;
    }
  
    private void Speciate(ArrayList<Genome> population)
    {
        for(Species s : this.GetSpecies())
        {
            s.Representative = s.GetGenomes().get(round(random(0, 1) * (s.GetGenomes().size() - 1))).Genome;
            s.Clear();
        }
  
        for(Genome g : population)
        {
            boolean wasadded = false;
  
            for(Species s : this.GetSpecies())
            {
                if (GenomeHelper.GetCompatibilityDistance(s.Representative, g, this.GetExcessImportance(), this.GetDisjointImportance(), 
                    this.GetDeltaWeightImportance()) <= this.GetThreshold())
                {
                    s.AddGenome(g);
                    wasadded = true;
                    break;
                }
            }
  
            if(!wasadded)
            {
                this.GetSpecies().add(new Species(g));
            }
        }
  
        for(int i = 0; i < this.GetSpecies().size(); i++)
        {
            if (this.GetSpecies().get(i).GetGenomes().size() == 0)
            {
                this.GetSpecies().remove(i--);
            }
        }
    }
}
