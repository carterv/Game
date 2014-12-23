class BlockSpawnpoint extends Block
{
  boolean firstRun;
  boolean collided;
  
  BlockSpawnpoint(float x, float y, float scale, boolean base)
  {
    super(x,y,scale);
    if (base) type = "block.toggle.spawnpoint.base.";
    else type = "block.toggle.spawnpoint.top.";
    
    int bx = (int)(position.x/blockSize);
    int by = (int)(position.y/blockSize);
    int sx = (int)(player.getSpawn().x/blockSize);
    int sy = (int)(player.getSpawn().y/blockSize);
    if ((base && bx == sx && by == sy+1) || (!base && bx == sx && by == sy)) type += "active";
    else type += "inactive";
    sprite = spriteManager.getSprite(type,drawSize);
    firstRun = true;
    solid = false;
    transparent = true;
    earlyDraw = true;
    collided = false;
  }
  
  void update()
  {
    if (firstRun) check();
    if (type.equals("block.toggle.spawnpoint.base.inactive"))
    {
      float px = player.getLocation().x+player.getHitbox().x/2;
      float py = player.getLocation().y+player.getHitbox().y;
      if (px > position.x && px < position.x + drawSize && py > position.y && py < position.y + drawSize && !collided)
      {
        PVector oldSpawn = player.getSpawn();
        player.setSpawn(new PVector(position.x,position.y-player.getHitbox().y+blockSize));
        int x = (int)(position.x/blockSize);
        int y = (int)(position.y/blockSize);
        this.toggleActive();
        ((BlockSpawnpoint)blocks[x][y-1]).toggleActive();
        x = (int)(oldSpawn.x/blockSize);
        y = (int)((oldSpawn.y)/blockSize);
        if (y < width/blockSize && blocks[x][y] != null && blocks[x][y].getType().startsWith("block.toggle.spawnpoint.top"))
        {
          ((BlockSpawnpoint)blocks[x][y]).toggleActive();
          ((BlockSpawnpoint)blocks[x][y+1]).toggleActive();
        }
        collided = true;
      }
      else if (!(px > position.x && px < position.x + drawSize && py > position.y && py < position.y + drawSize))
      {
        collided = false;
      }
    }
  }
  
  void check()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    
    if (firstRun)
    {
      int sx = (int)(player.getSpawn().x/blockSize);
      int sy = (int)(player.getSpawn().y/blockSize)+1;
      if (type.startsWith("block.toggle.spawnpoint.base"))
      {
        if (y <= 0 || (blocks[x][y-1] != null && !blocks[x][y-1].getType().startsWith("block.toggle.spawnpoint.top") && blocks[x][y-1].isSolid()))
        {
          blocks[x][y] = null;
          forceCheck();
        }
        else
        {
          blocks[x][y-1] = newBlock("block.toggle.spawnpoint.top", position.x, position.y-blockSize, drawSize/blockSize);
        }
      }
      else if (type.startsWith("block.toggle.spawnpoint.top"))
      {
        if (x == sx && y == sy)
         {
           type = "block.toggle.spawnpoint.top.active";
           sprite = spriteManager.getSprite(type,drawSize);
         }
        if (y == (int)(height/blockSize)-1 || blocks[x][y+1] == null || !blocks[x][y+1].getType().startsWith("block.toggle.spawnpoint.base"))
        {
          blocks[x][y] = null;
          forceCheck();
        }
      }
      firstRun = false;
    }
    else
    {
      if (type.startsWith("block.toggle.spawnpoint.base"))
      {
        if (blocks[x][y-1] == null || !blocks[x][y-1].getType().startsWith("block.toggle.spawnpoint.top"))
        {
          blocks[x][y] = new EmitterBlockDestroy(x*blockSize,y*blockSize,1,sprite,getLightLevel());
          forceCheck();
        }
      }
      else if (type.startsWith("block.toggle.spawnpoint.top"))
      {
        if (blocks[x][y+1] == null || !blocks[x][y+1].getType().startsWith("block.toggle.spawnpoint.base"))
        {
          blocks[x][y] = new EmitterBlockDestroy(x*blockSize,y*blockSize,1,sprite,getLightLevel());
          forceCheck();
        }
      }
    }
  }
  
  void updateLightLevel()
  {
    setLightLevel(12);
  }
  
  void toggleActive()
  {
    if (type.startsWith("block.toggle.spawnpoint.top.active"))
    {
      type = "block.toggle.spawnpoint.top.inactive";
    }
    else if (type.startsWith("block.toggle.spawnpoint.top.inactive"))
    {
      type = "block.toggle.spawnpoint.top.active";
    }
    else if (type.startsWith("block.toggle.spawnpoint.base.active"))
    {
      type = "block.toggle.spawnpoint.base.inactive";
    }
    else if (type.startsWith("block.toggle.spawnpoint.base.inactive"))
    {
      type = "block.toggle.spawnpoint.base.active";
    }
    sprite = spriteManager.getSprite(type,drawSize);
  }
}
