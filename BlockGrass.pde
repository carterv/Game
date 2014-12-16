class BlockGrass extends Block
{
  int timer;
  
  BlockGrass(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.grass";
    timer = 1;
    this.makeSprite();
  }
  
  void update()
  {
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
  
  void makeSprite()
  {
    super.makeSprite();
    int w = sprite.width;
    int h = sprite.height;
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h/4; j++)
      {
        sprite.pixels[j*h+i] = color(30,175,45); 
      }
    }
    for (int i = 0; i < w; i++)
    {
      for (int j = h/4; j < h; j++)
      {
        sprite.pixels[j*w+i] = color(183,112,54); 
      }
    }
  }
}
