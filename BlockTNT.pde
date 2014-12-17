class BlockTNT extends Block
{
  int life;
  boolean primed;
  
  BlockTNT(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.tnt";
    sprite = spriteManager.getSprite(type,drawSize);
    life = 299;
    primed = true;
  }
  
  void draw()
  {
    super.draw();
    if (((int)(life/60))%2 == 1)
    {
      fill(255,75);
      rect(position.x,position.y,drawSize,drawSize);
    }
  }
  
  void update()
  {
    if (primed == true)
    {
      life -= 1;
    }
    if (life == 0)
    {
      explode();
    }
  }
  
  void explode()
  {
    int x = (int)(position.x/drawSize);
    int y = (int)(position.y/drawSize);
    for (int i = -5; i <= 5; i++)
    {
      for (int j = -5; j <= 5; j++)
      {
        if (sqrt(sq(i)+sq(j)) <= 5)
        {
          Block b = blocks[x+i][y+j];
          if (b != null && !b.getType().startsWith("emitter"))
          {
            if (b.getSprite() != null) blocks[x+i][y+j] = new EmitterBlockDestroy((x+i)*blockSize, (y+j)*blockSize, drawSize/blockSize, b.getSprite());
            else blocks[x+i][y+j] = null;
            b.forceCheck();
          }
        }
      }
    }
  }
}
