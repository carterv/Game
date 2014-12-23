abstract class Emitter extends Block
{
  ArrayList<Particle> particles;
  color systemColor;
  int max;
  boolean active;
  
  Emitter(float x, float y, float scale, int num, color c)
  {
    super(x,y,scale);
    particles = new ArrayList<Particle>();
    max = num;
    systemColor = c;
    type = "emitter.null";
    friction = 0;
    solid = false;
    earlyDraw = true;
  }

  Emitter(int num, color c)
  {
    super(0,0,1);
    drawSize = blockSize;
    max = num;
    systemColor = c;
    type = "emitter.null";
    friction = 0;
    solid = false;
  }
  
  void draw()
  {
    populate();
    for (int i = particles.size()-1; i >= 0; i--)
    {
      Particle p = (Particle)(particles.get(i));
      
      p.update();
      p.draw();
      
      replentish(p);
    }
  }
  
  
  void populate()
  {
    if (particles.size() < max)
    {
      particles.add(newParticle());
    }
  }
  
  void replentish(Particle p)
  {
    if (!p.isAlive())
    {
      particles.remove(p);
      particles.add(newParticle());
    }
  }
  
  Particle newParticle()
  {
    return null;
  }
  
  boolean isAlive()
  {
    return particles.size() > 0;
  }
  
  void forceCheck() {}
  void check() {}
}
