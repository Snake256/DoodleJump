class FitnessInfo
{
    public Genome Genome;
    
    public float Fitness;

    public float SharedFitness;

    public FitnessInfo(Genome genome, float fitness, float sharedfitness)
    {
        this.Genome = genome;
        this.Fitness = fitness;
        this.SharedFitness = sharedfitness;
    }
}
