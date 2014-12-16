class BlockLeaf extends Block
{
  boolean shouldDecay;
  int timer;
  
  BlockLeaf(float x, float y, float scale, boolean generated)
  {
    super(x,y,scale);
    if (generated) type = "block.leaf.generated";
    else type = "block.leaf.placed";
    solid = false;
    friction = 4;
    shouldDecay = false;
    timer = 60 + (int)random(240);
    this.makeSprite();
  }
  
  void update()
  {
    if (type.equals("block.leaf.generated"))
    {
      int x = (int)(position.x/blockSize);
      int y = (int)(position.y/blockSize);
      //decay code
      if (shouldDecay)
      {
        timer -= 1;
        if (timer == 0)
        {
          blocks[x][y] = null;
          this.forceCheck();
        }
        check();
      }
      else if (timer <= 60)
      {
        timer = 60 + (int)random(240);
      }
    }
  }
  
  void check()
  {
    //check for log
    if (type.equals("block.leaf.generated"))
    {
      //check for a log
    }
    else
    {
      shouldDecay = false;
    }
  }
  
  void makeSprite()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    int w = sprite.width;
    int h = sprite.height;
    if (x%2 == y%2)
    {
      for (int i = 0; i < w; i++)
      {
        for (int j = 0; j < h; j++)
        {
          if ((i < w/3 && j < h/3) || (i >= 2*w/3 && j < h/3) || (i >= w/3 && i < 2*w/3 && j >= h/3 && j < 2*h/3) || (i < w/3 && j >= 2*w/3) || (i >= 2*w/3 && j >= 2*w/3))
          {
            sprite.pixels[j*w+i] = color(33,203,31);
          }
          else
          {
            sprite.pixels[j*w+i] = color(44,157,41,128);
          }
        }
      }
    }
    else
    {
      for (int i = 0; i < w; i++)
      {
        for (int j = 0; j < h; j++)
        {
          if ((i < w/3 && j < h/3) || (i >= 2*w/3 && j < h/3) || (i >= w/3 && i < 2*w/3 && j >= h/3 && j < 2*h/3) || (i < w/3 && j >= 2*w/3) || (i >= 2*w/3 && j >= 2*w/3))
          {
            sprite.pixels[j*w+i] = color(44,157,41,128);
          }
          else
          {
            sprite.pixels[j*w+i] = color(33,203,31);
          }
        }
      }
    }
  }
}
