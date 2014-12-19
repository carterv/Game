class EmitterBlockDestroy extends Emitter
{
  int lightLevel; 
  
  EmitterBlockDestroy(float x, float y, float scale, PImage base, int light)
  {
    super(x,y,scale,10,color(255));
    sprite = base.get();
    type = "emitter.blockdestroyed";
    lightLevel = light;
    for (int i = 0; i < 25; i++)
    {
      particles.add(newParticle());
    }
  }
  
  void draw()
  {
    for (int i = particles.size()-1; i >= 0; i--)
    {
      Particle p = particles.get(i);
      
      p.update();
      p.draw();
      
      replentish(p);
    }
  }
  
  void update()
  {
    if (!this.isAlive())
    {
      int x = (int)(position.x/blockSize);
      int y = (int)(position.y/blockSize);
      blocks[x][y] = null;
    }
  }
  
  void replentish(Particle p)
  {
    if (!p.isAlive())
    {
      particles.remove(p);
    }
  }
  
  Particle newParticle()
  {
    PVector pos = new PVector((int)random(blockSize),(int)random(blockSize));
    return new ParticleBlockDestroy(new PVector(position.x+pos.x,position.y+pos.y), sprite.pixels[(int)((pos.y)*sprite.width+(pos.x))], lightLevel);
  }
}
