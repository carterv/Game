class EmitterStream extends Emitter
{
  boolean flag;
  
  EmitterStream(float x, float y, float scale)
  {
    super(x,y,scale,150,color(31,193,252));
    type = "emitter.stream";
    flag = true;
  }
  
  void draw()
  {
    if (this.isAlive()) super.draw();
    fill(systemColor);
    rect(position.x+drawSize/4,position.y+drawSize/4,drawSize/2,drawSize/2);
  }
  
  void populate()
  {
    if (flag) super.populate();
    flag = !flag;
  }
  
  Particle newParticle()
  {
    PVector pos = new PVector((int)random(blockSize/2)+blockSize/4,(int)random(blockSize/2)+blockSize/4);
    return new ParticleStream(new PVector(position.x+pos.x,position.y+pos.y), systemColor);
  }
  
  boolean isAlive()
  {
    return (position.x%blockSize == 0 && position.y%blockSize == 0);
  }
}
