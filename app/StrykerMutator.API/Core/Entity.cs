namespace StrykerMutator.API.Core
{
    public class Entity
    {
        public int Id { get; set; }
        public int NumberOne { get; set; }
        public int NumberTwo { get; set; }
                
        public int Sum()
        {
            return NumberOne + NumberTwo;
        }
    }
}
