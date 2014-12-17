class ParticleBlockDestroy extends Particle
{
  ParticleBlockDestroy(PVector location, color c)
  {
    super(location,c);
    velocity = new PVector(random(1)-0.5,random(2)+0.5);
    life = 50;
  }
  
  void update()
  {
    //fade
    drawColor = (drawColor & 0xffffff) | ((4*life+50) << 24);
    //update position
    float xVel = velocity.x;
    float yVel = velocity.y;
    //x-axis collision detection
    position.x += xVel;
    if (collided())
    {
      float d = abs(xVel)/xVel;
      while (collided())
      {
        position.x -= d;
      }
      velocity.x = -xVel/3;
    }
    //y-axis collision detection
    if (abs(yVel) >= 1) position.y += yVel;
    if (collided())
    {
      float d = abs(yVel)/yVel;
      while (collided())
      {
        position.y -= d;
      }
      velocity.y = -yVel/5;
      velocity.x *= 0.7;
    }
    //gravity
    velocity.y += 0.05;
    //update life countdown
    life -= 1;
  }
  
  boolean collided()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if (x < 0 || y < 0 || x >= blocks.length || y >= blocks[0].length) return true;
    return (blocks[x][y] != null && blocks[x][y].isSolid());
  }
}
