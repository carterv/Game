abstract class Entity
{
  PVector position, velocity, acceleration, hitbox;
  float health;
  
  Entity(PVector location, PVector hb)
  {
    position = location.get();
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0.5);
    hitbox = hb.get();
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
        if (velocity.y > 2*blockSize/3)
        {
          setHealth(getHealth()-pow(8,(2*velocity.y/blockSize)));
        }
        velocity.y = 0;
        //calculate friction
        int x = (int)(position.x/blockSize);
        int y = (int)((position.y + hitbox.y)/blockSize);
        if (y+2 > blocks[0].length) friction = 3;
        else if (x+1 < blocks.length && blocks[x][y] != null && blocks[x+1][y] != null)
        {
          friction = (blocks[x][y].getFriction() + blocks[x+1][y].getFriction())/2;
        }
        else if (blocks[x][y] != null)
        {
          friction = blocks[x][y].getFriction();
        }
        else if (x+1 < blocks.length && blocks[x+1][y] != null)
        {
          friction = blocks[x+1][y].getFriction();
        }
      }
      //add block friction
      if (velocity.x > 0) velocity.x = (velocity.x - friction > 0) ? velocity.x - friction : 0;
      else if (velocity.x < 0) velocity.x = (velocity.x + friction < 0) ? velocity.x + friction : 0; 
      if (velocity.y > 0 && collidedNonSolid()) velocity.y = (velocity.y - friction > 0) ? velocity.y-friction : 0;
      //add gravity
      velocity.add(acceleration);
      //terminal velocity in water
      if (velocity.y > 10 && collidedNonSolid()) velocity.y = 10;
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
  }
  
  abstract void draw();
  
  abstract boolean collided();
  
  abstract boolean collidedNonSolid();
  
  abstract void updateLightLevel();
  
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
    health = h;
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
