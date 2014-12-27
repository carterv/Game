class Player extends Entity
{
  //draw variables
  float lightLevel;
  //spawn
  PVector spawn;
  //health
  color drawColor;
  int colorStep;
  
  Player(PVector location, PVector hb)
  {
    super(location,hb);
    setSpawn(location);
    lightLevel = 10;
    health = 100;
    drawColor = color(255);
  }
  
  void update()
  {
    if (getHealth() == 0)
    {
      respawn();
      return;
    }
    
    super.update();
    
    if (drawColor != color(255))
    {
      drawColor = (drawColor & 0xffff0000) | (255*colorStep/30 << 8 | 255*colorStep/30);
      //if (drawColor > color(255)) drawColor = color(255);
      colorStep += 1;
    }
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
    return ((blocks[i0][j0] != null && !blocks[i0][j0].isSolid() && !blocks[i0][j0].getType().startsWith("emitter.") && !blocks[i0][j0].getType().startsWith("block.toggle."))
         || (blocks[i1][j0] != null && !blocks[i1][j0].isSolid() && !blocks[i1][j0].getType().startsWith("emitter.") && !blocks[i1][j0].getType().startsWith("block.toggle."))
         || (blocks[i0][j1] != null && !blocks[i0][j1].isSolid() && !blocks[i0][j1].getType().startsWith("emitter.") && !blocks[i0][j1].getType().startsWith("block.toggle."))
         || (blocks[i1][j1] != null && !blocks[i1][j1].isSolid() && !blocks[i1][j1].getType().startsWith("emitter.") && !blocks[i1][j1].getType().startsWith("block.toggle."))
         || (blocks[i0][j2] != null && !blocks[i0][j2].isSolid() && !blocks[i0][j2].getType().startsWith("emitter.") && !blocks[i0][j2].getType().startsWith("block.toggle."))
         || (blocks[i1][j2] != null && !blocks[i1][j2].isSolid() && !blocks[i1][j2].getType().startsWith("emitter.") && !blocks[i1][j2].getType().startsWith("block.toggle.")));
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
  
  void respawn()
  {
    velocity = new PVector(0,0);
    int x = (int)(spawn.x/blockSize);
    int y = (int)(spawn.y/blockSize);
    if (blocks[x][y] == null || !blocks[x][y].getType().startsWith("block.toggle.spawnpoint.top"))
    {
      setSpawn(new PVector(width/2-blockSize/2,height-1.8*blockSize));
    }
    position = spawn.get();
    setHealth(100);
    drawColor = color(255);
  }
  
  void setVSpeed(float s)
  {
    //fall damage when jumping
    if (s == -7 && velocity.y > 2*blockSize/3 && drawColor != color(255,0,0))
    {
      setHealth(getHealth()-pow(8,(2*velocity.y/blockSize)));
      drawColor = color(255,0,0);
      colorStep = 0;
    }
    super.setVSpeed(s);
  }
  
  void setHealth(float h)
  {
    if (h < health)
    {
      drawColor = color(255,0,0);
      colorStep = 0;
    }
    if (h > 100) health = 100;
    else if (h < 0) health = 0;
    else health = h;
  }
  
  void setSpawn(PVector loc)
  {
    spawn = loc.get();
  }
  
  PVector getSpawn()
  {
    return spawn.get();
  }
}
