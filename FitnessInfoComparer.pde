import java.util.Comparator;

class FitnessInfoComparer implements Comparator<FitnessInfo>
{
    public int compare(FitnessInfo x, FitnessInfo y)
    {
        if(x.Fitness > y.Fitness)
        {
            return 1;
        }
        else if(x.Fitness < y.Fitness)
        {
            return -1;
        }
        else
        {
            return 0;
        }
    }
}
