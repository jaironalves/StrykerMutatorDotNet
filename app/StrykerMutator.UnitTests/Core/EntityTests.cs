using StrykerMutator.API.Core;

namespace StrykerMutator.UnitTests.Core
{    
    public class EntityTests
    {
        //Create a test method to test the Sum method
        [Fact]
        public void SumTest()
        {
            //Arrange
            var entity = new Entity { NumberOne = 1, NumberTwo = 2 };

            //Act
            var result = entity.Sum();

            //Assert
            Assert.Equal(3, result);
        }
    }

    
}
