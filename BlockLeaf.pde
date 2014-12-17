class BlockLeaf extends Block
{
  boolean shouldDecay;
  int timer;
  
  BlockLeaf(float x, float y, float scale, boolean generated)
  {
    super(x,y,scale);
    
    if (generated) type = "block.leaf.generated";
    else type = "block.leaf.placed";
    
    if ((int)(position.x/blockSize)%2 == (int)(position.y/blockSize)%2) type += ".a";
    else type += ".b";
    
    solid = false;
    friction = 4;
    shouldDecay = false;
    timer = 60 + (int)random(240);
    sprite = spriteManager.getSprite(type,drawSize);
  }
  
  void update()
  {
    if (type.startsWith("block.leaf.generated"))
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
    if (type.startsWith("block.leaf.generated"))
    {
      //check for a log
    }
    else
    {
      shouldDecay = false;
    }
  }
}
