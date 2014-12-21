abstract class Block
{
  boolean solid;
  boolean transparent;
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
    if (xpos%blockSize == 0 && ypos%blockSize == 0) updateLightLevel();
    else setLightLevel(10);
  }

  void update() 
  {
  }

  void check()
  {
  }

  void draw()
  {
    if (sprite != null) image(sprite, position.x, position.y);
    drawLight();
  }
  
  void drawLight()
  {
    int l = getLightLevel();
    fill(0,255*(10-(l > 10 ? 10 : l))/10);
    rect(position.x,position.y,drawSize,drawSize);
  }

  void forceCheck()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if (y > 0 && blocks[x][y-1] != null) blocks[x][y-1].check();
    if (x > 0)
    {
      if (y > 0 && blocks[x-1][y-1] != null) blocks[x-1][y-1].check();
      if (blocks[x-1][y] != null) blocks[x-1][y].check();
      if (y < blocks[0].length-1 && blocks[x-1][y+1] != null) blocks[x-1][y+1].check();
    }
    if (y < blocks[0].length-1 && blocks[x][y+1] != null) blocks[x][y+1].check();
    if (x < blocks.length-1)
    {
      if (y > 0 && blocks[x+1][y-1] != null) blocks[x+1][y-1].check();
      if (blocks[x+1][y] != null) blocks[x+1][y].check();
      if (y < blocks[0].length-1 && blocks[x+1][y+1] != null) blocks[x+1][y+1].check();
    }
    for (int i = 0; i < blocks[0].length; i++)
    {
      if (blocks[x][i] != null && i != y) blocks[x][i].updateLightLevel();
      /*else if (blocks[x][i] == null) 
      {
        if (!canSeeSky(x,i))
        {
          int d = 10-getBlockDepth(x,i,true);
          if (d < 1) d = 1;
          lights[x][i] = d;
        }
        else if (canSeeSky(x,i) && !canSeeClearSky(x,i))
        {
          int d = 10-getBlockDepth(x,i,true);
          if (d < 1) d = 1;
          lights[x][i] = d;
        }
        else if (canSeeClearSky(x,i))
        {
          lights[x][i] = 10;
        }
      }*/
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
    return lights[(int)(position.x/blockSize)][(int)(position.y/blockSize)];
  }
  
  void setLightLevel(int i)
  {
    lights[(int)(position.x/blockSize)][(int)(position.y/blockSize)] = i;
  }
  
  void updateLightLevel()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    int d = 0;
    if (canSeeSky(x,y) && canSeeClearSky(x,y))
    {
      d = 10;
    }
    else if (canSeeSky(x,y) && !canSeeClearSky(x,y))
    {
      d = getBlockDepth(x,y,true);
      if (d > 9) d = 9;
      d = 10-d+1;
    }
    else if ((y > 0) && lights[x][y-1]-1 > d)
    {
      d = lights[x][y-1]-1;
    }
    if ((x > 0) && lights[x-1][y]-2 > d) d = lights[x-1][y]-2;
    if ((x < lights.length-1) && lights[x+1][y]-1 > d) d = lights[x+1][y]-2;
    if ((y < lights[0].length-1) && lights[x][y+1]-1 > d) d = lights[x][y+1]-2;
    if (d < 1) d = 1;
    setLightLevel(d);
  }
}

