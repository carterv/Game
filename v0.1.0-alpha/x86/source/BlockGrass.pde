class BlockGrass extends Block
{
  int timer;
  
  BlockGrass(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.grass";
    timer = 1;
    sprite = spriteManager.getSprite(type,drawSize);
    x = (int)(position.x/blockSize);
    y = (int)(position.y/blockSize);
    if (y != 0 && blocks[(int)x][(int)y-1] != null && !blocks[(int)x][(int)y-1].getType().startsWith("emitter."))
    {
      timer -= 1;
      if (timer <= 0)
      {
        blocks[(int)x][(int)y] = newBlock("block.dirt",position.x,position.y,drawSize/blockSize);
        blocks[(int)x][(int)y].forceCheck();
      }
    }
  }
  
  void update()
  {
    super.update();
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if (y == 0) return;
    if (blocks[x][y-1] != null && !blocks[x][y-1].getType().startsWith("emitter."))
    {
      timer -= 1;
      if (timer <= 0)
      {
        blocks[x][y] = newBlock("block.dirt",position.x,position.y,drawSize/blockSize);
        blocks[x][y].forceCheck();
      }
    }
  }
}
