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
    position.x += (collidedNonSolid() ? xVel/3 : xVel);
    if (collided() && xVel != 0)
    {
      xVel = xVel/abs(xVel);
      while (collided())
      {
        position.x -= xVel;
      }
      velocity.x = 0;
    }
    //try vertical movement
    float friction = .25; 
    if (abs(yVel) >= 1) position.y += (collidedNonSolid() ? yVel/3 : yVel);
    if (collided() && yVel != 0)
    {
      yVel = yVel/abs(yVel);
      while (collided())
      {
        position.y -= yVel;
      }
      velocity.y = 0;
      //calculate friction
      int x = (int)(position.x/blockSize);
      int y = (int)((position.y + hitbox.y)/blockSize);
      if (y+2 > blocks[0].length) friction = 3;
      else if (blocks[x][y] != null && blocks[x+1][y] != null)
      {
        friction = (blocks[x][y].getFriction() + blocks[x+1][y].getFriction())/2;
      }
      else if (blocks[x][y] != null)
      {
        friction = blocks[x][y].getFriction();
      }
      else if (blocks[x+1][y] != null)
      {
        friction = blocks[x+1][y].getFriction();
      }
    }
    //add block friction
    if (velocity.x > 0) velocity.x = (velocity.x - friction > 0) ? velocity.x - friction : 0;
    else if (velocity.x < 0) velocity.x = (velocity.x + friction < 0) ? velocity.x + friction : 0; 
    if (velocity.y > 0 && collidedNonSolid()) velocity.y = (velocity.y - friction > 0) ? velocity.y-friction : 0;
    //add gravity
    if (velocity.y > -10) velocity.add(acceleration);
    
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
    return ((blocks[i0][j0] != null && blocks[i0][j0].isSolid())
         || (blocks[i1][j0] != null && blocks[i1][j0].isSolid())
         || (blocks[i0][j1] != null && blocks[i0][j1].isSolid())
         || (blocks[i1][j1] != null && blocks[i1][j1].isSolid())
         || (blocks[i0][j2] != null && blocks[i0][j2].isSolid())
         || (blocks[i1][j2] != null && blocks[i1][j2].isSolid()));
  }
  
  boolean collidedNonSolid()
  {
    int i0 = (int)(position.x/blockSize);
    int i1 = (int)((position.x + hitbox.x - 1)/blockSize);
    int j0 = (int)(position.y/blockSize);
    int j1 = (int)((position.y + hitbox.y/2 - 1)/blockSize);
    int j2 = (int)((position.y + hitbox.y - 1)/blockSize);
    if (position.x < 0 || position.y < 0 || position.x + hitbox.x >= width || position.y + hitbox.y >= height) return true;
    if (i1 >= blocks.length || j2 >= blocks.length) return true;
    return ((blocks[i0][j0] != null && !blocks[i0][j0].isSolid())
         || (blocks[i1][j0] != null && !blocks[i1][j0].isSolid())
         || (blocks[i0][j1] != null && !blocks[i0][j1].isSolid())
         || (blocks[i1][j1] != null && !blocks[i1][j1].isSolid())
         || (blocks[i0][j2] != null && !blocks[i0][j2].isSolid())
         || (blocks[i1][j2] != null && !blocks[i1][j2].isSolid()));
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
  
  PVector getHitbox()
  {
    return hitbox.get();
  }
}
