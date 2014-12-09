class BlockSand extends Block
{
  boolean canFall;
  int timer;
  
  BlockSand(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.sand";
    timer = 7;
  }
  
  void update()
  {
    if (canFall)
    {
      timer -= 1;
      solid = false;
      if (timer == 0)
      {
        int x = (int)(position.x/blockSize);
        int y = (int)(position.y/blockSize);
        blocks[x][y] = null;
        this.forceCheck();
        blocks[x][y+1] = newBlock("block.sand",position.x,position.y+blockSize,drawSize/blockSize);
        blocks[x][y+1].check();
        blocks[x][y+1].forceCheck();
      }
      check();
    }
    else 
    {
      solid = true;
      if (timer < 7) timer = 7;
    }
  }
  
  void check()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    canFall = (drawSize/blockSize == 1 && y+1 < blocks[0].length && (blocks[x][y+1] == null || (!blocks[x][y+1].isSolid() && !(blocks[x][y+1] instanceof BlockLeaf))));
  }
  
  void draw()
  {
    fill(255,209,80);
    rect(position.x,position.y,drawSize,drawSize);
  }
}
