class EmitterMouse extends Emitter
{
  boolean flag;
  
  EmitterMouse(float x, float y, float scale)
  {
    super(x,y,scale,150,color(33,203,31));
    type = "emitter.mouse";
    flag = true;
  }
  
  void draw()
  {
    super.draw();
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
    float mx = mouseX;
    float my = mouseY;
    if (mx >= width) mx = width-1;
    else if (mx < 0) mx = 0;
    if (my >= height) my = height-1;
    else if (my < 0) my = 0;
    return new ParticleStream(new PVector(mx,my), systemColor);
  }
  
  boolean isAlive()
  {
    return true;
  }
}
