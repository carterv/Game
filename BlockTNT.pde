class BlockTNT extends Block
{
  int timer, life;
  boolean primed, canFall;
  
  BlockTNT(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.tnt";
    sprite = spriteManager.getSprite(type,drawSize);
    life = 299;
    timer = 5;
    primed = true;
    solid = false;
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
    if (life <= 0)
    {
      explode();
      return;
    }
    if (canFall)
    {
      timer -= 1;
      solid = false;
      if (timer <= 0)
      {
        int x = (int)(position.x/blockSize);
        int y = (int)(position.y/blockSize);
        blocks[x][y] = null;
        this.forceCheck();
        blocks[x][y+1] = newBlock("block.tnt",position.x,position.y+blockSize,drawSize/blockSize);
        ((BlockTNT)blocks[x][y+1]).setLife(life);
        blocks[x][y+1].check();
        blocks[x][y+1].forceCheck();
      }
      check();
    }
    else 
    {
      solid = true;
      if (timer < 5) timer = 5;
    }
  }
  
  void check()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    canFall = (drawSize/blockSize == 1 && y+1 < blocks[0].length && (blocks[x][y+1] == null || (!blocks[x][y+1].isSolid() && !(blocks[x][y+1] instanceof BlockLeaf))));
  }
  
  void explode()
  {
    int x = (int)(position.x/drawSize);
    int y = (int)(position.y/drawSize);
    for (int i = -3; i <= 3; i++)
    {
      if (x+i < 0 || x+i >= blocks.length) continue;
      for (int j = -3; j <= 3; j++)
      {
        if (y+j < 0 || y+j >= blocks[0].length) continue;
        if (sqrt(sq(i)+sq(j)) <= 3)
        {
          Block b = blocks[x+i][y+j];
          if (b != null && !b.getType().startsWith("emitter"))
          {
            if (b.getType().equals("block.tnt") && !(i == 0 && j == 0)) 
            {
              ((BlockTNT)b).setLife(1);
            }
            else if (b.getSprite() != null)
            {
              blocks[x+i][y+j] = new EmitterBlockDestroy((x+i)*blockSize, (y+j)*blockSize, drawSize/blockSize, b.getSprite());
            }
            else 
            {
              blocks[x+i][y+j] = null;
            }
            b.forceCheck();
          }
        }
      }
    }
  }
  
  void setLife(int i)
  {
    life = i;
  }
}
