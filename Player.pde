class Player
{
  //draw size
  PVector hitbox;
  //movement vectors
  PVector position, velocity, acceleration;
  
  Player(PVector location)
  {
    hitbox = new PVector(playerWidth,playerHeight);
    
    position = location.get();
    velocity = new PVector();
    acceleration = new PVector(0,0.5);
  }
  
  void update()
  {
    float xVel = velocity.x;
    float yVel = velocity.y;
    //try horizontal movement
    position.x += xVel;
    if (collided() && xVel != 0)
    {
      xVel = xVel/abs(xVel);
      while (collided())
      {
        position.x -= xVel;
      }
      velocity.x = 0;
    }
    //try verticle movement
    if (abs(yVel) >= 1) position.y += yVel;
    if (collided() && yVel != 0)
    {
      yVel = yVel/abs(yVel);
      while (collided())
      {
        position.y -= yVel;
      }
      velocity.y = 0;
    }
    //add gravity
    velocity.add(acceleration);
    //add block friction
    
    this.draw();
  }
  
  void draw()
  {
    fill(255);
    rect(position.x,position.y,hitbox.x,hitbox.y);
  }
  
  boolean collided()
  {
    int i0 = (int)(position.x/blockSize);
    int i1 = (int)((position.x + hitbox.x - 1)/blockSize);
    int j0 = (int)(position.y/blockSize);
    int j1 = (int)((position.y + hitbox.y/2 - 1)/blockSize);
    int j2 = (int)((position.y + hitbox.y - 1)/blockSize);
    if (position.x < 0 || position.y < 0 || position.x + hitbox.x >= width || position.y + hitbox.y >= height) return true;
    if (i1 >= blocks.length || j2 >= blocks.length) return true;
    return !(blocks[i0][j0] == null && blocks[i1][j0] == null & blocks[i0][j1] == null && blocks[i1][j1] == null && blocks[i0][j2] == null && blocks[i1][j2] == null);
  }
  
  //setters and getters
  void setHSpeed(float s)
  {
    velocity.x = s;
  }
  
  void setVSpeed(float s)
  {
    velocity.y = s;
  }
  
  void setLocation(PVector loc)
  {
    position = loc.get();
    setHSpeed(0);
    setVSpeed(0);
  }
  
  PVector getLocation()
  {
    return position.get();
  }
  
  PVector getSpeed()
  {
    return velocity.get();
  }
}
