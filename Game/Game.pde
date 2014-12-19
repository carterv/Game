//controller variables
Block[][] blocks;
int[][] lights;
ArrayList<Block> creativeInventory;
ArrayList<Block> survivalInventory;
ArrayList<Emitter> particles;
Player player;
SpriteManager spriteManager;

//game options, mostly constants
float blockSize, playerHeight, playerWidth;
color backgroundColor;

//input variables
boolean mouseL, mouseR, jump;
float inventoryIndex;
int keyDown;

void setup()
{
  //window options
  size(1000,600);
  
  //draw options
  noStroke();
  blockSize = 20;
  playerHeight = 1.8*blockSize;
  playerWidth = blockSize;
  backgroundColor = color(0,128);
  
  //input variables
  mouseL = mouseR = jump = false;
  keyDown = 0;
  
  //controller variables
  blocks = new Block[(int)(width/blockSize)][(int)(height/blockSize)];
  lights = new int[(int)(width/blockSize)][(int)(height/blockSize)];
  for (int i = 0; i < lights.length; i++)
  {
    for (int j = 0; j < lights[0].length; j++)
    {
      lights[i][j] = 10;
    }
  }
  player = new Player(new PVector(width/2-blockSize/2,0));
  particles = new ArrayList<Emitter>();
  spriteManager = new SpriteManager();
  
  //inventory
  inventoryIndex = 0;
  //creative inventory blocklist
  creativeInventory = new ArrayList<Block>();
  creativeInventory.add(newBlock("block.stone",2,2,1));
  creativeInventory.add(newBlock("block.grass",2,(blockSize+4)+2,1));
  creativeInventory.add(newBlock("block.dirt",2,2*(blockSize+4)+2,1));
  creativeInventory.add(newBlock("block.leaf.placed",2,3*(blockSize+4)+2,1));
  creativeInventory.add(newBlock("block.log",2,4*(blockSize+4)+2,1));
  creativeInventory.add(newBlock("block.sand",2,5*(blockSize+4)+2,1));
  creativeInventory.add(newBlock("block.glass",2,6*(blockSize+4)+2,1));
  creativeInventory.add(newBlock("fluid.water",2,7*(blockSize+4)+2,1));
  creativeInventory.add(newBlock("block.tnt",2,8*(blockSize+4)+2,1));
  creativeInventory.add(newBlock("block.light",2,9*(blockSize+4)+2,1));
  creativeInventory.add(newBlock("emitter.stream",2,10*(blockSize+4)+2,1));
  creativeInventory.add(newBlock("emitter.mouse",2,11*(blockSize+4)+2,1));
}

void draw()
{
  fill(backgroundColor);
  rect(0,0,width,height);

  //check input
  doInput();
  
  //draw and update the player
  player.update();
  
  //DEBUG: render the light levels
  //renderLights();
    
  //draw the blocks
  renderBlocks();
  
  //draw the inventory
  renderInventory();
}

void mousePressed()
{
  if (mouseButton == LEFT) mouseL = true;
  else if (mouseButton == RIGHT) mouseR = true;
}

void mouseReleased()
{
  if (mouseButton == LEFT) mouseL = false;
  else if (mouseButton == RIGHT) mouseR = false;
}

void keyPressed()
{
  if (key == 'a' || key == 'A')
  {
    keyDown = 1;
  }
  else if (key == 'w' || key == 'W')
  {
    jump = true;
  }
  else if (key == 'd' || key == 'D')
  {
    keyDown = 2;
  }
  else if (key == ' ')
  {
    int x = (int)(mouseX/blockSize);
    int y = (int)(mouseY/blockSize);
    if (x >= 0 && y >= 0 && x < blocks.length-1 && y < blocks[0].length-1)
    { 
      if ((blocks[x][y] == null || !blocks[x][y].isSolid()) && (blocks[x][y+1] == null || !blocks[x][y+1].isSolid())) player.setLocation(new PVector(blockSize*x,blockSize*y));
    }
  }
  else if (key == CODED && keyCode == ALT)
  {
    for (int i = 0; i < blocks.length; i++)
    {
      for (int j = 0; j < blocks[0].length; j++)
      {
        if (blocks[i][j] != null) blocks[i][j].updateLightLevel();
      }
    }
  }
}

void mouseWheel(MouseEvent e)
{
  float count = e.getCount();
  float change = count/2;
  inventoryIndex += change;
  if (inventoryIndex < 0) inventoryIndex += creativeInventory.size();
  inventoryIndex %= creativeInventory.size();
}

void keyReleased()
{
  if (key == 'a' || key == 'A')
  {
    if (keyDown == 1) keyDown = 0;
  }
  else if (key == 'w' || key == 'W')
  {
    jump = false;
  }
  else if (key == 'd' || key == 'D')
  {
    if (keyDown == 2) keyDown = 0;
  }
}

void renderBlocks()
{
  for (Emitter e : particles)
  {
    e.draw();
    e.update();
  }
  particles = new ArrayList<Emitter>();
  for (int i = 0; i < blocks.length; i++)
  {
    for (int j = 0; j < blocks[i].length; j++)
    {
      if (blocks[i][j] != null) 
      {
        if (blocks[i][j].getType().startsWith("emitter."))
        {
          particles.add((Emitter)blocks[i][j]);
        }
        else
        {
          blocks[i][j].draw();
          blocks[i][j].update();
        }
      }
    }
  }
}

void renderLights()
{
  for (int i = 0; i < lights.length; i++)
  {
    for (int j = 0; j < lights[0].length; j++)
    {
      int l = lights[i][j];
      fill(0,255*(10-(l > 10 ? 10 : l))/10);
      rect(i*blockSize,j*blockSize,blockSize,blockSize);
    }
  }
}

void renderInventory()
{
  fill(0,128);
  rect(0,0,blockSize+4,(blockSize+4)*creativeInventory.size()+2);
  fill(255,128);
  rect(0,(int)inventoryIndex*(blockSize+4),blockSize+4,blockSize+4);
  for (Block b : creativeInventory)
  {
    b.draw();
  }
}

void doInput()
{
  if (mouseL)
  {
    int mx = (int)(mouseX/blockSize);
    int my = (int)(mouseY/blockSize);
    if (!(mx < 0 || mx >= blocks.length || my < 0 || my >= blocks[0].length))
    {
      if (blocks[mx][my] == null || !blocks[mx][my].isSolid())
      {
        PVector location = player.getLocation();
        PVector hitbox = player.getHitbox();
        int i0 = (int)(location.x/blockSize);
        int i1 = (int)((location.x+hitbox.x-1)/blockSize);
        int j0 = (int)(location.y/blockSize);
        int j1 = (int)((location.y + hitbox.y/2-1)/blockSize);
        int j2 = (int)((location.y + hitbox.y-1)/blockSize);
        if (!((i0 == mx && (my == j0 || my == j1 || my == j2)) || (i1 == mx && (my == j0 || my == j1 || my == j2))))
        {
          blocks[mx][my] = newBlock(creativeInventory.get((int)inventoryIndex).getType(),mx*blockSize,my*blockSize,1);
          blocks[mx][my].check();
          blocks[mx][my].forceCheck();
        }
      }
    }
  }
  else if (mouseR)
  {
    int mx = (int)(mouseX/blockSize);
    int my = (int)(mouseY/blockSize);
    if (!(mx < 0 || mx >= blocks.length || my < 0 || my >= blocks[0].length))
    {
      if (blocks[mx][my] != null && !blocks[mx][my].getType().startsWith("emitter.blockdestroyed"))
      {
        Block b = blocks[mx][my];
        PImage sprite = b.getSprite();
        if (sprite != null)
        {
          blocks[mx][my] = new EmitterBlockDestroy(mx*blockSize,my*blockSize,1,sprite, b.getLightLevel());
        }
        else blocks[mx][my] = null;
        b.forceCheck();
      }
    }
  }
  if (keyDown == 1)
  {
    player.setHSpeed(-3);
  }
  else if (keyDown == 2)
  {
    player.setHSpeed(3);
  }
  if (jump)
  {
    int px = (int)(player.getLocation().x/blockSize);
    int py = (int)(player.getLocation().y/blockSize);
    //check if at lower bound or if the block under the player 
    if (py+2 >= blocks[0].length || (blocks[px][py+2] != null && blocks[px][py+2].isSolid()))
    {
      player.setVSpeed(-7);
    }
    //check for non-solid blocks
    else if ((blocks[px][py] != null && !blocks[px][py].isSolid() && !blocks[px][py].getType().startsWith("emitter.")) || (blocks[px][py+1] != null && !blocks[px][py+1].isSolid() && !blocks[px][py+1].getType().startsWith("emitter."))) 
    {
      player.setVSpeed(-7);
    }
    //check check to see if the player is not aligned to the grid
    else if ((px+1)*blockSize+1 < player.getLocation().x+player.getHitbox().x && px+1 < blocks.length)
    {
      //check for block under player, check for non-solid blocks
      if ((blocks[px+1][py+2] != null && blocks[px+1][py+2].isSolid()))
      {
        player.setVSpeed(-7);
      }
      else if ((blocks[px+1][py] != null && !blocks[px+1][py].isSolid() && !blocks[px+1][py].getType().startsWith("emitter.")))
      {
        player.setVSpeed(-7);
      }
      else if ((blocks[px+1][py+1] != null && !blocks[px+1][py+1].isSolid() && !blocks[px+1][py+1].getType().startsWith("emitter.")))
      {
        player.setVSpeed(-7);
      }
    }
  }
}

boolean canSeeSky(int x, int y)
{
  for (y -= 1; y >= 0; y--)
  {
    if (blocks[x][y] != null && !blocks[x][y].isTransparent())
    {
      return false;
    }
  }
  return true;
}

boolean canSeeClearSky(int x, int y)
{
  for (y -= 1; y >=0; y--)
  {
    if (blocks[x][y] != null && !blocks[x][y].getType().startsWith("emitter."))
    {
      return false;
    }
  }
  return true;
}

int getBlockDepth(int x, int y, boolean includeTransparent)
{
  int count = 0;
  for (; y >= 0; y--)
  {
    if (blocks[x][y] != null)
    {
      count += 1;
      if (blocks[x][y].isTransparent() && !includeTransparent) count -= 1;
      if (canSeeClearSky(x,y)) break;
    }
  }
  return count;
}

Block newBlock(String type, float x, float y, float scale)
{
  if (type.equals("block.stone")) return new BlockStone(x,y,scale);
  else if (type.equals("block.dirt")) return new BlockDirt(x,y,scale);
  else if (type.equals("block.glass")) return new BlockGlass(x,y,scale);
  else if (type.equals("block.grass")) return new BlockGrass(x,y,scale);
  else if (type.startsWith("block.leaf.generated")) return new BlockLeaf(x,y,scale,true);
  else if (type.startsWith("block.leaf.placed")) return new BlockLeaf(x,y,scale,false);
  else if (type.equals("block.log")) return new BlockLog(x,y,scale);
  else if (type.equals("block.sand")) return new BlockSand(x,y,scale);
  else if (type.equals("block.tnt")) return new BlockTNT(x,y,scale);
  else if (type.equals("block.light")) return new BlockLight(x,y,scale);
  else if (type.equals("fluid.water")) return new FluidWater(x,y,scale);
  else if (type.equals("emitter.stream")) return new EmitterStream(x,y,scale);
  else if (type.equals("emitter.mouse")) return new EmitterMouse(x,y,scale);
  else return null;
}
