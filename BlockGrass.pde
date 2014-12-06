class BlockGrass extends Block
{
  int timer;
  
  BlockGrass(float x, float y, float scale)
  {
    super(x,y,scale);
    timer = (int)random(90) + 60;
  }
  
  void update()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if (y == 0) return;
    if (blocks[x][y-1] != null)
    {
      timer -= 1;
      if (timer <= 0)
      {
        blocks[x][y] = newBlock("block.dirt",position.x,position.y,drawSize/blockSize);
        this.forceCheck();
      }
    }
    else if (timer < 60)
    {
      timer = (int)random(90) + 60;
    }
  }
  
  void draw()
  {
    fill(30,175,45);
    rect(position.x,position.y,drawSize,drawSize/4);
    fill(183,112,54);
    rect(position.x,position.y+drawSize/4,drawSize,3*drawSize/4);
  }
  
  String getType()
  {
    return "block.grass";
  }
}
