class EmitterTest extends Emitter
{
  EmitterTest(float x, float y, float scale)
  {
    super(x,y,scale,50,color(255));
    type = "emitter.test";
  }
  
  void draw()
  {
    super.draw();
    if (drawSize/blockSize != 1)
    {
      fill(systemColor);
      rect(position.x+drawSize/4,position.y+drawSize/4,drawSize/2,drawSize/2);
    }
  }
  
  Particle newParticle()
  {
    return new ParticleTest(new PVector(position.x+drawSize/2,position.y+drawSize/2), systemColor);
  }
}
