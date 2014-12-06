class BlockDirt extends Block
{
  int timer;
  Block[] surroundings;
  
  BlockDirt(float x, float y, float scale)
  {
    super(x,y,scale);
    
    timer = (int)random(90) + 150;
    surroundings = new Block[8];
    this.check();
  }
  
  void update()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if (y == 0) return;
    if (surroundings[0] == null)
    {
      this.forceCheck();
      for (Block b : surroundings)
      {
        if (b != null && b instanceof BlockGrass)
        {
          timer -= 1;
        }
      }
      if (timer <= 0)
      {
        blocks[x][y] = newBlock("block.grass",position.x,position.y,drawSize/blockSize);
        this.forceCheck();
      }
    }
    else if (timer < 150)
    {
      timer = (int)random(90) + 150;
    }
  }
  
  void draw()
  {
    fill(183,112,54);
    rect(position.x,position.y,drawSize,drawSize);
  }
  
  void check()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if (y > 0) surroundings[0] = blocks[x][y-1];
    if (x > 0)
    {
      if (y > 0)surroundings[1] = blocks[x-1][y-1];
      surroundings[2] = blocks[x-1][y];
      if (y < blocks[0].length-1) surroundings[3] = blocks[x-1][y+1];
    }
    if (y < blocks[0].length-1) surroundings[4] = blocks[x][y+1];
    if (x < blocks.length-1)
    {
      if (y > 0) surroundings[5] = blocks[x+1][y-1];
      surroundings[6] = blocks[x+1][y];
      if (y < blocks[0].length-1) surroundings[7] = blocks[x+1][y+1];
    }
  }
  
  String getType()
  {
    return "block.dirt";
  }
}
