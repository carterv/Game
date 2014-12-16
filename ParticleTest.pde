class ParticleTest extends Particle
{
  int life;
  
  ParticleTest(PVector location, color c)
  {
    super(location,c);
    life = 50;
  }
  
  void update()
  {
    super.update();
    life -= 1;
  }
  
  boolean isAlive()
  {
    return life > 0;
  }
}
