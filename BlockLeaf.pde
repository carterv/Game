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
  
  void draw()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if ((x%2 == 0 && y%2 == 0) || (x%2 == 1 && y%2 == 1))
    {
      fill(33,203,31);
      rect(position.x,position.y,drawSize/3,drawSize/3);
      rect(position.x+2*drawSize/3,position.y,drawSize/3,drawSize/3);
      rect(position.x+drawSize/3,position.y+drawSize/3,drawSize/3,drawSize/3);
      rect(position.x,position.y+2*drawSize/3,drawSize/3,drawSize/3);
      rect(position.x+2*drawSize/3,position.y+2*drawSize/3,drawSize/3,drawSize/3);
      fill(44,157,41,128);
      rect(position.x,position.y+drawSize/3,drawSize/3,drawSize/3);
      rect(position.x+drawSize/3,position.y,drawSize/3,drawSize/3);
      rect(position.x+drawSize/3,position.y+2*drawSize/3,drawSize/3,drawSize/3);
      rect(position.x+2*drawSize/3,position.y+drawSize/3,drawSize/3,drawSize/3);
    }
    else
    {
      fill(33,203,31);
      rect(position.x,position.y+drawSize/3,drawSize/3,drawSize/3);
      rect(position.x+drawSize/3,position.y,drawSize/3,drawSize/3);
      rect(position.x+drawSize/3,position.y+2*drawSize/3,drawSize/3,drawSize/3);
      rect(position.x+2*drawSize/3,position.y+drawSize/3,drawSize/3,drawSize/3);
      fill(44,157,41,128);
      rect(position.x,position.y,drawSize/3,drawSize/3);
      rect(position.x+2*drawSize/3,position.y,drawSize/3,drawSize/3);
      rect(position.x+drawSize/3,position.y+drawSize/3,drawSize/3,drawSize/3);
      rect(position.x,position.y+2*drawSize/3,drawSize/3,drawSize/3);
      rect(position.x+2*drawSize/3,position.y+2*drawSize/3,drawSize/3,drawSize/3);
    }
  }
}
