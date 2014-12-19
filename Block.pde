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
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    int i0 = (x-10 >= 0 ? -10 : 0);
    int i1 = (x+10 < blocks.length ? 10 : blocks.length-x-1);
    int j0 = (y-10 >= 0 ? -10 : 0);
    int j1 = (y+10 < blocks[0].length ? 10 : blocks[0].length-y-1);
    for (int i = i0; i < i1; i++)
    {
      for (int j = j0; j < j1; j++)
      {
        if (blocks[x+i][y+j] != null)
        {
           if (sqrt(sq(i)+sq(j)) <= 10) blocks[x+i][y+j].updateLightLevel();
        } 
      }
    }
    //updateLightLevel();
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
    for (int i = 0; i < blocks[0].length; i++)
    {
      if (blocks[x][i] != null && i != y) blocks[x][i].check();
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
      if (blocks[x][y] != null && !blocks[x][y].isTransparent())
      {
        return false;
      }
    }
    return true;
  }
  
  boolean canSeeSky(int x, int y)
  {
    for (; y >= 0; y--)
    {
      if (blocks[x][y] != null && !blocks[x][y].isTransparent())
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
        if (blocks[x][y].isTransparent()) count -= 1;
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
      int[] i = new int[4];
      for (int j = 0; j < 4; j++) i[j] = 0;
      int count = 0;
      if (x > 0 && blocks[x-1][y] != null)
      {
        count += 1;
        i[0] = blocks[x-1][y].getLightLevel()-1;
        if (i[0] > d) d = i[0];
      }
      else if (canSeeSky(x-1,y))
      {
        if (9 > d) d = 9;
      }
      if (y > 0 && blocks[x][y-1] != null)
      {
        count += 1;
        i[1] = blocks[x][y-1].getLightLevel()-1;
        if (i[1] > d) d = i[1];
      }
      else if (canSeeSky(x,y-1))
      {
        if (9 > d) d = 9;
      }
      if (x < blocks.length-1 && blocks[x+1][y] != null) 
      {
        count += 1;
        i[2] = blocks[x+1][y].getLightLevel()-1;
        if (i[2] > d) d = i[2];
      }
      else if (canSeeSky(x+1,y))
      {
        if (9 > d) d = 9;
      }
      if (y > blocks[0].length-1 && blocks[x][y+1] != null) 
      {
        count += 1;
        i[3] = blocks[x][y+1].getLightLevel()-1;
        if (i[3] > d) d = i[3];
      }
      if (d > 2) lightLevel = d;
      else lightLevel = 2;
    }
  }
}

