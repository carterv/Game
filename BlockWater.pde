class BlockWater extends Block
{
  boolean shouldSpread;
  
  BlockWater(float x, float y, float scale)
  {
    super(x,y,scale);
    
    type = "block.water";
    solid = false;
    shouldSpread = true;
    friction = 4;
    this.check();
  }
  
  void update()
  {
    if (shouldSpread)
    {
      int x = (int)(position.x/blockSize);
      int y = (int)(position.y/blockSize);
      if (x > 0 && blocks[x-1][y] == null) 
      {
        blocks[x-1][y] = newBlock("block.water", (x-1)*blockSize, y*blockSize, 1);
      }
      if (y < blocks[0].length-1 && blocks[x][y+1] == null)
      {
        blocks[x][y+1] = newBlock("block.water", x*blockSize, (y+1)*blockSize, 1);
      }
      if (x < blocks.length-1 && blocks[x+1][y] == null)
      {
        blocks[x+1][y] = newBlock("block.water", (x+1)*blockSize, y*blockSize, 1);
      }
      
      shouldSpread = false;
      this.forceCheck();
    }
  }
  
  void draw()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    boolean flag = false;
    if (y > 0 && drawSize/blockSize == 1)
    {
      flag = blocks[x][y-1] != null;
    }
    fill(0,50,200,128);
    if (flag || drawSize/blockSize != 1)
    {
      rect(position.x,position.y,drawSize,drawSize);
    }
    else
    {
      rect(position.x,position.y+drawSize/4,drawSize,3*drawSize/4);
    }
  }
  
  void check()
  {
    shouldSpread = true;
  }
}
