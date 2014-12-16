class SystemTest extends System
{
  PVector position;
  
  SystemTest(int num, color c, PVector location)
  {
    super(num,c);
    position = location.get();
  }
  
  Particle newParticle()
  {
    return new ParticleTest(position,systemColor);
  }
}
