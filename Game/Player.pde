class Player
{
  //draw variables
  PVector hitbox;
  float lightLevel;
  //movement vectors
  PVector position, velocity, acceleration;
  //health
  float health;
  color drawColor;
  int colorStep;
  
  Player(PVector location)
  {
    hitbox = new PVector(playerWidth,playerHeight);
    
    position = location.get();
    velocity = new PVector();
    acceleration = new PVector(0,0.5);
    lightLevel = 10;
    health = 100;
    drawColor = color(255);
  }
  
  void update()
  {
    float xVel = velocity.x;
    float yVel = velocity.y;
    PVector start = position.get();
    if (!collided())
    {
      //try horizontal movement
      position.x += (collidedNonSolid() ? xVel/3 : xVel);
      if (collided() && xVel != 0)
      {
        xVel = xVel/abs(xVel);
        while (collided() && position.x != start.x)
        {
          position.x -= xVel;
        }
        velocity.x = 0;
      }
      //try vertical movement
      float friction = .25;
      if (collidedNonSolid())
      {
        if (yVel > 0 && abs(yVel/3) >= .5) position.y += yVel/3;
        else if (yVel < 0 && abs(yVel/3) >= .5) position.y += yVel/3;
      }
      else if (!collidedNonSolid() && abs(yVel) >= 1) position.y += yVel;
      if (collided() && yVel != 0)
      {
        yVel = yVel/abs(yVel);
        while (collided() && position.y != start.y)
        {
          position.y -= yVel;
        }
        //fall damage
        if (velocity.y > blockSize/2)
        {
          setHealth(getHealth()-pow(8,(2*velocity.y/blockSize)));
          drawColor = color(255,0,0);
          colorStep = 0;
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
    }
    else
    {
      int i = 1;
      while(collided())
      {
        position.y -= i;
        if (!collided()) break;
        position.y = start.y;
        position.x -= i;
        if (!collided()) break;
        position.x = start.x;
        position.x += i;
        if (!collided()) break;
        position.x = start.x;
        i += 1;
      }
    }
    
    updateLightLevel();
    
    if (drawColor != color(255))
    {
      drawColor = (drawColor & 0xffff0000) | (255*colorStep/30 << 8 | 255*colorStep/30);
      //if (drawColor > color(255)) drawColor = color(255);
      colorStep += 1;
    }
    this.draw();
  }
  
  void draw()
  {
    noStroke();
    fill(drawColor);
    rect(position.x,position.y,hitbox.x,hitbox.y);
    float l = ((lightLevel > 10 ) ? 10 : ((lightLevel < 2) ? 2 : lightLevel));
    fill(0,255*(10-(l > 10 ? 10 : l))/10);
    rect(position.x-1,position.y-1,hitbox.x+2,hitbox.y+2);
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
    if (position.x < 0 || position.y < 0 || position.x + hitbox.x >= width || position.y + hitbox.y >= height) return false;
    if (i1 >= blocks.length || j2 >= blocks.length) return true;
    return ((blocks[i0][j0] != null && !blocks[i0][j0].isSolid() && !blocks[i0][j0].getType().startsWith("emitter."))
         || (blocks[i1][j0] != null && !blocks[i1][j0].isSolid() && !blocks[i1][j0].getType().startsWith("emitter."))
         || (blocks[i0][j1] != null && !blocks[i0][j1].isSolid() && !blocks[i0][j1].getType().startsWith("emitter."))
         || (blocks[i1][j1] != null && !blocks[i1][j1].isSolid() && !blocks[i1][j1].getType().startsWith("emitter."))
         || (blocks[i0][j2] != null && !blocks[i0][j2].isSolid() && !blocks[i0][j2].getType().startsWith("emitter."))
         || (blocks[i1][j2] != null && !blocks[i1][j2].isSolid() && !blocks[i1][j2].getType().startsWith("emitter.")));
  }
  
  void updateLightLevel()
  {
    int i0 = (int)(position.x/blockSize);
    int i1 = (int)((position.x + hitbox.x - 1)/blockSize);
    int j0 = (int)(position.y/blockSize);
    int j1 = (int)((position.y + hitbox.y/2 - 1)/blockSize);
    int j2 = (int)((position.y + hitbox.y - 1)/blockSize);
    int sum = lights[i0][j0] + lights[i0][j1];
    int count = 2;
    if (position.y%blockSize != 0 && position.y + hitbox.y < height)
    {
      sum += lights[i0][j2];
      count += 1;
    }
    if (position.x%blockSize != 0 && position.x+hitbox.x < width)
    {
      sum += lights[i1][j0] + lights[i1][j1];
      count += 2;
      if (position.y%blockSize != 0 && position.y + hitbox.y < height)
      {
        sum += lights[i1][j2];
        count += 1;
      }
    }
    lightLevel = sum/count;
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
  
  void setHealth(float h)
  {
    if (h > 100) health = 100;
    else if (h < 0) health = 0;
    else health = h;
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
  
  float getHealth()
  {
    return health;    
  }
}
