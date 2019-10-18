import java.util.Comparator;

class SpeciesComparer implements Comparator<Species>
{
    public int compare(Species x, Species y)
    {
        if (x.GetTotalSharedFitness() > y.GetTotalSharedFitness())
        {
            return 1;
        }
        else if (x.GetTotalSharedFitness() < y.GetTotalSharedFitness())
        {
            return -1;
        }
        else
        {
            return 0;
        }
    }
}
