class ParticleBlockDestroy extends Particle
{
  int lightLevel;
  
  ParticleBlockDestroy(PVector location, color c, int light)
  {
    super(location,c);
    velocity = new PVector(random(1)-0.5,random(2)+0.5);
    life = 25;
    lightLevel = light;
  }
  
  void update()
  {
    //fade
    drawColor = (drawColor & 0xffffff) | ((8*life+50) << 24);
    //update position
    float xVel = velocity.x;
    float yVel = velocity.y;
    PVector start = position.get();
    if (collided())
    {
      life = 0;
      return;
    }
    //x-axis collision detection
    position.x += xVel;
    if (collided())
    {
      float d = abs(xVel)/xVel;
      while (collided() && position.x != start.x)
      {
        position.x -= d;
      }
      velocity.x = -xVel/3;
    }
    //y-axis collision detection
    if (abs(yVel) >= 0.5) position.y += yVel;
    if (collided())
    {
      float d = abs(yVel)/yVel;
      while (collided() && position.y != start.y)
      {
        position.y -= d;
      }
      velocity.y = -yVel/5;
      velocity.x *= 0.7;
    }
    //gravity
    velocity.y += 0.05;
    //update life countdown
    if (collided()) life = 0;
    else life -= 1;
  }
  
  void draw()
  {
    super.draw();
    fill(0, 255*(10-lightLevel)/10);
    ellipse(position.x,position.y,2,2);
  }
  
  boolean collided()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if (x < 0 || y < 0 || x >= blocks.length || y >= blocks[0].length) return true;
    return (blocks[x][y] != null && blocks[x][y].isSolid());
  }
}
