class Species
{
  private int staleness;

  public int GetStaleness()
  {
    return this.staleness;
  }

  public Genome Representative;

  private float bestfitness;

  public float GetTotalSharedFitness()
  {
    float totalfitness = 0;

    for(FitnessInfo fi : this.GetGenomes())
    {
        totalfitness += fi.SharedFitness;
    }

    return totalfitness;
  }

  public FitnessInfo GetFittestGenome()
  {
      if (this.GetGenomes().size() > 0)
      {
        FitnessInfo fittest = this.GetGenomes().get(0);

        for (FitnessInfo fg : this.GetGenomes())
        {
            if (fg.Fitness > fittest.Fitness)
            {
                fittest = fg;
            }
        }

        return fittest;
      }
      else
      {
          return null;
      }
  }

  private ArrayList<FitnessInfo> genomes;

  public ArrayList<FitnessInfo> GetGenomes()
  {
    return this.genomes;
  }

  public Species(Genome representative)
  {
    this(representative, new ArrayList<FitnessInfo>());
  }

  public void AddGenome(Genome genometoadd)
  {
      if(genometoadd != null)
      {
          for(FitnessInfo fg : this.GetGenomes())
          {
              if(fg.Genome == genometoadd)
              {
                  return;
              }
          }
          this.GetGenomes().add(new FitnessInfo(genometoadd, 0f, 0f));
      }
  }

  public Genome CreateOffspring(PApplet p)
  {
      FitnessInfo[] parents = new FitnessInfo[2];
      int genomecount = this.GetGenomes().size();
      for(int i = 0; i < parents.length; i++)
      {
          float randomfitness = random(0, 1) * this.GetTotalSharedFitness();

          for(FitnessInfo fg : this.GetGenomes())
          {
              randomfitness -= fg.SharedFitness;
              if(randomfitness <= 0 || fg == this.GetGenomes().get(genomecount -1 ))
              {
                  parents[i] = fg;
                  break;
              }
          }
      }

      return GenomeHelper.Crossover(parents[0].Genome, parents[1].Genome, parents[0].Fitness, parents[1].Fitness, p);
  } 

  public Species(Genome representative, ArrayList<FitnessInfo> genomes)
  {
      this.Representative = representative;
      if(genomes != null)
      {
          this.genomes = genomes;
          for (FitnessInfo fg : this.GetGenomes())
          {
              if (fg.Genome == representative)
              {
                  return;
              }
          }
          this.GetGenomes().add(new FitnessInfo(representative, 0f, 0f));
      }
      else
      {
          this.genomes = new ArrayList<FitnessInfo>();
      }
  }

  public void KillOffWorst()
  {
      this.GetGenomes().sort(new FitnessInfoComparer());
      while(this.GetGenomes().size() > 5)
      {
          this.GetGenomes().remove(0);
      }
  }

  public void CheckStaleness()
  {
      if(this.GetTotalSharedFitness()  <= this.bestfitness)
      {
          this.staleness++;
      }
      else
      {
          this.bestfitness = this.GetTotalSharedFitness();
          if(staleness != 0)
          {
              staleness = 0;
          }
      }
  }

  public Species Copy()
  {
      Species copy = new Species(this.Representative.Copy());
      for(FitnessInfo fg : this.GetGenomes())
      {
          copy.AddGenome(fg.Genome.Copy());
      }
      return copy;
  }

  public void Clear()
  {
      this.GetGenomes().clear();
  }
}
