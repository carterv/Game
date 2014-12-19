abstract class Block
{
  boolean solid;
  boolean transparent;
  int lightLevel;
  float friction;
  float drawSize;
  PImage sprite;
  PVector position;
  String type;

  Block(float xpos, float ypos, float scale)
  {
    position = new PVector(xpos, ypos);
    drawSize = scale*blockSize;
    friction = 3;
    solid = true;
    transparent = false;
    type = "block.null";
    updateLightLevel();
  }

  void update() 
  {
    //updateLightLevel();
  }

  void check()
  {
    updateLightLevel();
  }

  void draw()
  {
    if (sprite != null) image(sprite, position.x, position.y);
    drawLight();
  }
  
  void drawLight()
  {
    fill(0,255*(10-lightLevel)/10);
    rect(position.x,position.y,drawSize,drawSize);
  }

  void forceCheck()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if (y > 0 && blocks[x][y-1] != null) blocks[x][y-1].check();
    if (x > 0)
    {
      //if (y > 0 && blocks[x-1][y-1] != null) blocks[x-1][y-1].check();
      if (blocks[x-1][y] != null) blocks[x-1][y].check();
      //if (y < blocks[0].length-1 && blocks[x-1][y+1] != null) blocks[x-1][y+1].check();
    }
    if (y < blocks[0].length-1 && blocks[x][y+1] != null) blocks[x][y+1].check();
    if (x < blocks.length-1)
    {
      //if (y > 0 && blocks[x+1][y-1] != null) blocks[x+1][y-1].check();
      if (blocks[x+1][y] != null) blocks[x+1][y].check();
      //if (y < blocks[0].length-1 && blocks[x+1][y+1] != null) blocks[x+1][y+1].check();
    }
    for (; y < blocks[0].length; y++)
    {
      if (blocks[x][y] != null) blocks[x][y].check();
    }
  }

  float getFriction()
  {
    return friction;
  }

  String getType()
  {
    return type;
  }

  boolean isSolid()
  {
    return solid;
  }
  
  boolean isTransparent()
  {
    return !solid || transparent;
  }
  
  PImage getSprite()
  {
    if (sprite != null) return sprite.get();
    else return null;
  }
  
  int getLightLevel()
  {
    return lightLevel;
  }
  
  void setLightLevel(int i)
  {
    if (i > 10) lightLevel = 10;
    else if (i < 0) lightLevel = 0;
    else lightLevel = i;
  }
  
  boolean canSeeSky()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize)-1;
    for (; y >= 0; y--)
    {
      if (blocks[x][y] != null)
      {
        return false;
      }
    }
    return true;
  }
  
  int getDepth()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    int count = 0;
    for (; y >= 0; y--)
    {
      count += 1;
      if (blocks[x][y] != null)
      {
        if (blocks[x][y].isTransparent()) count -= 0.5;
        if (blocks[x][y].canSeeSky()) break;
      }
    }
    return count;
  }
  
  void updateLightLevel()
  {
    if (canSeeSky())
    {
      lightLevel = 10;
    }
    else
    {
      int x = (int)(position.x/blockSize);
      int y = (int)(position.y/blockSize);
      int d = 10-getDepth();
      int u, b, l, r;
      u = b = l = r = -1;
      if (x > 0 && blocks[x-1][y] != null) l = blocks[x-1][y].getLightLevel();
      if (y > 0 && blocks[x][y-1] != null) u = blocks[x][y-1].getLightLevel()-1;
      if (x < blocks.length-1 && blocks[x+1][y] != null) r = blocks[x+1][y].getLightLevel();
      if (y > blocks[0].length-1 && blocks[x][y+1] != null) b = blocks[x][y+1].getLightLevel()+1;
      int a = (int)((u+b+l+r)/r);
      if (a > d) d = a;
      if (d > 2) lightLevel = d;
      else lightLevel = 2;
      //lightLevel = d > 2 ? d : 2;
    }
  }
}

