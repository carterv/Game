abstract class System
{
  //standard properties for a particle system
  ArrayList<Particle> particles;
  color systemColor;
  int max;
  
  //particle system setup
  System(int num, color c)
  {
    particles = new ArrayList<Particle>();
    max = num;
    systemColor = c;
  }
  
  //go through the system and update/draw each particle
  //also, add and replentish particles
  void update()
  {
    this.populate();
    for (int i = particles.size()-1; i >= 0; i--)
    {
      Particle p = (Particle)particles.get(i);
      
      p.update();
      p.draw();
      
      this.replentish(p);
    }
  }
  
  //add a particle if there are less than the maximum number
  void populate()
  {
    if (particles.size() < max)
    {
      particles.add(newParticle());
    } 
  }
  
  //replace dead particles
  void replentish(Particle p)
  {
    if (!p.isAlive())
    {
        particles.remove(p);
        particles.add(newParticle());
    }
  }
  
  //replace this with a particle object constructor
  Particle newParticle()
  {
    return null;
  }
  
  //check to see if the system is out of particles
  boolean isAlive()
  {
    return particles.size() > 0;
  }
}
