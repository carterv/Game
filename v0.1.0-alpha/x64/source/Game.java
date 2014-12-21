import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Game extends PApplet {

//controller variables
Block[][] blocks;
int[][] lights;
ArrayList<Block> creativeInventory;
ArrayList<Block> survivalInventory;
ArrayList<Emitter> particles;
Player player;
SpriteManager spriteManager;
int timer;

//game options, mostly constants
float blockSize, playerHeight, playerWidth;
int backgroundColor;

//input variables
boolean mouseL, mouseR, jump;
float inventoryIndex;
int keyDown;

public void setup()
{
  //window options
  size(1000,600);
  
  //draw options
  noStroke();
  blockSize = 20;
  playerHeight = 1.8f*blockSize;
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
}

public void draw()
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
  
  timer += 1;
  timer %= 5;
  if (timer == 0) refreshLights();
}

public void mousePressed()
{
  if (mouseButton == LEFT) mouseL = true;
  else if (mouseButton == RIGHT) mouseR = true;
}

public void mouseReleased()
{
  if (mouseButton == LEFT) mouseL = false;
  else if (mouseButton == RIGHT) mouseR = false;
}

public void keyPressed()
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
}

public void mouseWheel(MouseEvent e)
{
  float count = e.getCount();
  float change = count/2;
  inventoryIndex += change;
  if (inventoryIndex < 0) inventoryIndex += creativeInventory.size();
  inventoryIndex %= creativeInventory.size();
}

public void keyReleased()
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

public void renderBlocks()
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

public void renderLights()
{
  for (int i = 0; i < lights.length; i++)
  {
    for (int j = 0; j < lights[0].length; j++)
    {
      if (blocks[i][j] == null)
      {
        int l = lights[i][j];
        fill(0,255*(10-(l > 10 ? 10 : l))/10);
        rect(i*blockSize,j*blockSize,blockSize,blockSize);
      }
    }
  }
}

public void refreshLights()
{
  for (int i = 0; i < blocks.length; i++)
  {
    for (int j = 0; j < blocks[0].length; j++)
    {
      if (blocks[i][j] != null) blocks[i][j].updateLightLevel();
      else// if (!canSeeClearSky(i,j))
      {
        int d = 0;
        if (canSeeSky(i,j))
        {
          d = getBlockDepth(i,j,true);
          if (d > 9) d = 9;
          d = 10-d+1;
        }
        else if ((j > 0) && lights[i][j-1]-1 > d)// && canSeeSky(i,j))
        {
          d = lights[i][j-1]-1;
        }
        if ((i > 0) && lights[i-1][j]-1 > d) d = lights[i-1][j]-1;
        if ((i < lights.length-1) && lights[i+1][j]-1 > d) d = lights[i+1][j]-1;
        if ((j < lights[0].length-1) && lights[i][j+1]-1 > d) d = lights[i][j+1]-1;
        if (d < 1) d = 1;
        lights[i][j] = d;
      }
    }
  }
}

public void renderInventory()
{
  fill(0,128);
  rect(0,0,blockSize+4,(blockSize+4)*creativeInventory.size());
  fill(255,128);
  rect(0,(int)inventoryIndex*(blockSize+4),blockSize+4,blockSize+4);
  for (Block b : creativeInventory)
  {
    b.draw();
  }
}

public void doInput()
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

public boolean canSeeSky(int x, int y)
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

public boolean canSeeClearSky(int x, int y)
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

public int getBlockDepth(int x, int y, boolean includeTransparent)
{
  int count = 0;
  for (; y >= 0; y--)
  {
    if (blocks[x][y] != null)
    {
      if (!(blocks[x][y].isTransparent() && !includeTransparent)) count += 1;
      if (canSeeClearSky(x,y)) break;
    }
  }
  return count;
}

public Block newBlock(String type, float x, float y, float scale)
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
  else return null;
}
abstract class Block
{
  boolean solid;
  boolean transparent;
  float friction;
  float drawSize;
  PImage sprite;
  PVector position;
  String type;

  Block(float xpos, float ypos, float scale)
  {
    position = new PVector(xpos, ypos);
    drawSize = scale*blockSize;
    friction = 3;
    solid = true;
    transparent = false;
    type = "block.null";
    if (xpos%blockSize == 0 && ypos%blockSize == 0) updateLightLevel();
    else setLightLevel(10);
  }

  public void update() 
  {
  }

  public void check()
  {
  }

  public void draw()
  {
    if (sprite != null) image(sprite, position.x, position.y);
    drawLight();
  }
  
  public void drawLight()
  {
    int l = getLightLevel();
    fill(0,255*(10-(l > 10 ? 10 : l))/10);
    rect(position.x,position.y,drawSize,drawSize);
  }

  public void forceCheck()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if (y > 0 && blocks[x][y-1] != null) blocks[x][y-1].check();
    if (x > 0)
    {
      if (y > 0 && blocks[x-1][y-1] != null) blocks[x-1][y-1].check();
      if (blocks[x-1][y] != null) blocks[x-1][y].check();
      if (y < blocks[0].length-1 && blocks[x-1][y+1] != null) blocks[x-1][y+1].check();
    }
    if (y < blocks[0].length-1 && blocks[x][y+1] != null) blocks[x][y+1].check();
    if (x < blocks.length-1)
    {
      if (y > 0 && blocks[x+1][y-1] != null) blocks[x+1][y-1].check();
      if (blocks[x+1][y] != null) blocks[x+1][y].check();
      if (y < blocks[0].length-1 && blocks[x+1][y+1] != null) blocks[x+1][y+1].check();
    }
    for (int i = 0; i < blocks[0].length; i++)
    {
      if (blocks[x][i] != null && i != y) blocks[x][i].updateLightLevel();
      /*else if (blocks[x][i] == null) 
      {
        if (!canSeeSky(x,i))
        {
          int d = 10-getBlockDepth(x,i,true);
          if (d < 1) d = 1;
          lights[x][i] = d;
        }
        else if (canSeeSky(x,i) && !canSeeClearSky(x,i))
        {
          int d = 10-getBlockDepth(x,i,true);
          if (d < 1) d = 1;
          lights[x][i] = d;
        }
        else if (canSeeClearSky(x,i))
        {
          lights[x][i] = 10;
        }
      }*/
    }
  }

  public float getFriction()
  {
    return friction;
  }

  public String getType()
  {
    return type;
  }

  public boolean isSolid()
  {
    return solid;
  }
  
  public boolean isTransparent()
  {
    return !solid || transparent;
  }
  
  public PImage getSprite()
  {
    if (sprite != null) return sprite.get();
    else return null;
  }
  
  public int getLightLevel()
  {
    return lights[(int)(position.x/blockSize)][(int)(position.y/blockSize)];
  }
  
  public void setLightLevel(int i)
  {
    lights[(int)(position.x/blockSize)][(int)(position.y/blockSize)] = i;
  }
  
  public void updateLightLevel()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    int d = 0;
    if (canSeeSky(x,y) && canSeeClearSky(x,y))
    {
      d = 10;
    }
    else if (canSeeSky(x,y) && !canSeeClearSky(x,y))
    {
      d = getBlockDepth(x,y,true);
      if (d > 9) d = 9;
      d = 10-d+1;
    }
    else if ((y > 0) && lights[x][y-1]-1 > d)
    {
      d = lights[x][y-1]-1;
    }
    if ((x > 0) && lights[x-1][y]-2 > d) d = lights[x-1][y]-2;
    if ((x < lights.length-1) && lights[x+1][y]-1 > d) d = lights[x+1][y]-2;
    if ((y < lights[0].length-1) && lights[x][y+1]-1 > d) d = lights[x][y+1]-2;
    if (d < 1) d = 1;
    setLightLevel(d);
  }
}

class BlockDirt extends Block
{
  int timer;
  Block[] surroundings;
  
  BlockDirt(float x, float y, float scale)
  {
    super(x,y,scale);
    
    type = "block.dirt";
    timer = (int)random(90) + 150;
    surroundings = new Block[8];
    sprite = spriteManager.getSprite(type,drawSize);
  }
  
  public void update()
  {
    super.update();
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if (y == 0) return;
    if (surroundings[0] == null)
    {
      this.check();
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
        forceCheck();
      }
    }
    else if (timer < 150)
    {
      timer = (int)random(90) + 150;
    }
  }
  
  public void check()
  {
    super.check();
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if (y > 0) surroundings[0] = blocks[x][y-1];
    else surroundings[0] = null;
    if (x > 0)
    {
      if (y > 0) surroundings[1] = blocks[x-1][y-1];
      else surroundings[1] = null;
      surroundings[2] = blocks[x-1][y];
      if (y < blocks[0].length-1) surroundings[3] = blocks[x-1][y+1];
      else surroundings[3] = null;
    }
    else
    {
      surroundings[1] = null;
      surroundings[2] = null;
      surroundings[3] = null;
    }
    if (y < blocks[0].length-1) surroundings[4] = blocks[x][y+1];
    else surroundings[4] = null;
    if (x < blocks.length-1)
    {
      if (y > 0) surroundings[5] = blocks[x+1][y-1];
      else surroundings[5] = null;
      surroundings[6] = blocks[x+1][y];
      if (y < blocks[0].length-1) surroundings[7] = blocks[x+1][y+1];
      else surroundings[7] = null;
    }
    else
    {
      surroundings[5] = null;
      surroundings[6] = null;
      surroundings[7] = null;
    }
  }
}
class BlockGlass extends Block
{
  BlockGlass(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.glass";
    sprite = spriteManager.getSprite(type,drawSize);
    transparent = true;
  }
}
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
  
  public void update()
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
class BlockLeaf extends Block
{
  boolean shouldDecay;
  int timer;
  
  BlockLeaf(float x, float y, float scale, boolean generated)
  {
    super(x,y,scale);
    
    if (generated) type = "block.leaf.generated";
    else type = "block.leaf.placed";
    
    if ((int)(position.x/blockSize)%2 == (int)(position.y/blockSize)%2) type += ".a";
    else type += ".b";
    
    solid = false;
    friction = 4;
    shouldDecay = false;
    timer = 60 + (int)random(240);
    sprite = spriteManager.getSprite(type,drawSize);
  }
  
  public void update()
  {
    super.update();
    if (type.startsWith("block.leaf.generated"))
    {
      int x = (int)(position.x/blockSize);
      int y = (int)(position.y/blockSize);
      //decay code
      if (shouldDecay)
      {
        timer -= 1;
        if (timer == 0)
        {
          blocks[x][y] = null;
          this.forceCheck();
        }
        check();
      }
      else if (timer <= 60)
      {
        timer = 60 + (int)random(240);
      }
    }
  }
  
  public void check()
  {
    //check for log
    if (type.startsWith("block.leaf.generated"))
    {
      //check for a log
    }
    else
    {
      shouldDecay = false;
    }
  }
}
class BlockLight extends Block
{
  BlockLight(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.light";
    sprite = spriteManager.getSprite(type,drawSize);
    transparent = true;
  }
  
  public void updateLightLevel()
  {
    setLightLevel(12);
  }
}
class BlockLog extends Block
{
  BlockLog(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.log";
    sprite = spriteManager.getSprite(type,drawSize);
  }
}
class BlockSand extends Block
{
  boolean canFall;
  int timer;
  
  BlockSand(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.sand";
    timer = 5;
    sprite = spriteManager.getSprite(type,drawSize);
  }
  
  public void update()
  {
    super.update();
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
      if (timer < 5) timer = 5;
    }
  }
  
  public void check()
  {
    super.check();
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    canFall = (drawSize/blockSize == 1 && y+1 < blocks[0].length && (blocks[x][y+1] == null || (!blocks[x][y+1].isSolid() && !(blocks[x][y+1] instanceof BlockLeaf))));
  }
}
class BlockStone extends Block
{
  BlockStone(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.stone";
    sprite = spriteManager.getSprite(type,drawSize);
  }
}
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
  
  public void draw()
  {
    super.draw();
    if (((int)(life/60))%2 == 1)
    {
      fill(255,75);
      rect(position.x,position.y,drawSize,drawSize);
    }
  }
  
  public void update()
  {
    super.update();
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
  
  public void check()
  {
    super.check();
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    canFall = (drawSize/blockSize == 1 && y+1 < blocks[0].length && (blocks[x][y+1] == null || (!blocks[x][y+1].isSolid() && !(blocks[x][y+1] instanceof BlockLeaf))));
  }
  
  public void updateLightLevel()
  {
    super.updateLightLevel();
    if (getLightLevel() < 4) setLightLevel(4);
  }
  
  public void explode()
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
              blocks[x+i][y+j] = new EmitterBlockDestroy((x+i)*blockSize, (y+j)*blockSize, drawSize/blockSize, b.getSprite(), b.getLightLevel());
              b.check();
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
  
  public void setLife(int i)
  {
    life = i;
  }
}
abstract class Emitter extends Block
{
  ArrayList<Particle> particles;
  int systemColor;
  int max;
  boolean active;
  
  Emitter(float x, float y, float scale, int num, int c)
  {
    super(x,y,scale);
    particles = new ArrayList<Particle>();
    max = num;
    systemColor = c;
    type = "emitter.null";
    friction = 0;
    solid = false;
  }

  Emitter(int num, int c)
  {
    super(0,0,1);
    drawSize = blockSize;
    max = num;
    systemColor = c;
    type = "emitter.null";
    friction = 0;
    solid = false;
  }
  
  public void draw()
  {
    populate();
    for (int i = particles.size()-1; i >= 0; i--)
    {
      Particle p = (Particle)(particles.get(i));
      
      p.update();
      p.draw();
      
      replentish(p);
    }
  }
  
  
  public void populate()
  {
    if (particles.size() < max)
    {
      particles.add(newParticle());
    }
  }
  
  public void replentish(Particle p)
  {
    if (!p.isAlive())
    {
      particles.remove(p);
      particles.add(newParticle());
    }
  }
  
  public Particle newParticle()
  {
    return null;
  }
  
  public boolean isAlive()
  {
    return particles.size() > 0;
  }
  
  public void forceCheck() {}
  public void check() {}
}
class EmitterBlockDestroy extends Emitter
{
  int lightLevel; 
  
  EmitterBlockDestroy(float x, float y, float scale, PImage base, int light)
  {
    super(x,y,scale,10,color(255));
    sprite = base.get();
    type = "emitter.blockdestroyed";
    lightLevel = light;
    for (int i = 0; i < 25; i++)
    {
      particles.add(newParticle());
    }
  }
  
  public void draw()
  {
    for (int i = particles.size()-1; i >= 0; i--)
    {
      Particle p = particles.get(i);
      
      p.update();
      p.draw();
      
      replentish(p);
    }
  }
  
  public void update()
  {
    if (!this.isAlive())
    {
      int x = (int)(position.x/blockSize);
      int y = (int)(position.y/blockSize);
      blocks[x][y] = null;
    }
  }
  
  public void replentish(Particle p)
  {
    if (!p.isAlive())
    {
      particles.remove(p);
    }
  }
  
  public Particle newParticle()
  {
    PVector pos = new PVector((int)random(blockSize),(int)random(blockSize));
    return new ParticleBlockDestroy(new PVector(position.x+pos.x,position.y+pos.y), sprite.pixels[(int)((pos.y)*sprite.width+(pos.x))], lightLevel);
  }
}
class Fluid extends Block
{
  boolean shouldSpread;
  int timer;
  
  Fluid(float x, float y, float scale)
  {
    super(x,y,scale);
    
    type = "fluid.null";
    solid = false;
    shouldSpread = true;
    friction = 4;
    timer = 5;
  }
  
  public void update()
  {
    super.update();
    if (shouldSpread)
    {
      timer -= 1;
      if (timer <= 0)
      {
        int x = (int)(position.x/blockSize);
        int y = (int)(position.y/blockSize);
        if (x > 0 && (blocks[x-1][y] == null || blocks[x-1][y].getType().startsWith("emitter.")) && (y >= blocks[0].length-1 || (blocks[x][y+1] != null && blocks[x][y+1].isSolid()))) 
        {
          blocks[x-1][y] = newBlock(type, (x-1)*blockSize, y*blockSize, 1);
          blocks[x-1][y].forceCheck();
        }
        if (y < blocks[0].length-1 && (blocks[x][y+1] == null || blocks[x][y+1].getType().startsWith("emitter.")))
        {
          blocks[x][y+1] = newBlock(type, x*blockSize, (y+1)*blockSize, 1);
          blocks[x][y+1].forceCheck();
        }
        if (x < blocks.length-1 && (blocks[x+1][y] == null || blocks[x+1][y].getType().startsWith("emitter.")) && (y >= blocks[0].length-1 || (blocks[x][y+1] != null && blocks[x][y+1].isSolid())))
        {
          blocks[x+1][y] = newBlock(type, (x+1)*blockSize, y*blockSize, 1);
          blocks[x+1][y].forceCheck();
        }
        shouldSpread = false;
        timer = 5;
        this.forceCheck();
      }
    }
  }
  
  public void draw() {}
  
  public void check()
  {
    super.check();
    shouldSpread = true;
  }
}
class FluidWater extends Fluid
{
  boolean shouldSpread;
  
  FluidWater(float x, float y, float scale)
  {
    super(x,y,scale);
    
    type = "fluid.water";
  }
  
  public void draw()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    boolean flag = false;
    if (y > 0)
    {
      flag = blocks[x][y-1] != null && !blocks[x][y-1].getType().startsWith("emitter.");
    }
    fill(0,50,200,128);
    if (flag || !(position.x%blockSize == 0 && position.y%blockSize == 0))
    {
      rect(position.x,position.y,drawSize,drawSize);
      int l = getLightLevel();
      fill(0,255*(10-(l > 10 ? 10 : l))/10);
      rect(position.x,position.y,drawSize,drawSize);
    }
    else
    {
      rect(position.x,position.y+drawSize/4,drawSize,3*drawSize/4);
      int l = getLightLevel();
      fill(0,255*(10-(l > 10 ? 10 : l))/10);
      rect(position.x,position.y+drawSize/4,drawSize,3*drawSize/4);
    }
  }
}
abstract class Particle
{
  //basic particle properties
  int drawColor;
  int life;
  PVector position;
  PVector velocity;
  
  //particle setup
  Particle(PVector location, int c)
  {
    position = location.get();
    velocity = new PVector(random(2)-1,random(2)-1);
    drawColor = c;
    life = 100;
  }
  
  //update the particle's postion and velocity, decrease life
  public void update()
  {
    //gravity
    velocity.y += 0.05f;
    //update position
    position.add(velocity);
    //update life countdown
    life -= 1;
  }
  
  //draw the particle
  public void draw()
  {
    fill(drawColor);
    ellipse(position.x,position.y,2,2);
  }
  
  //return particle lifespan
  public boolean isAlive()
  {
    return life > 0;
  }
}
class ParticleBlockDestroy extends Particle
{
  int lightLevel;
  
  ParticleBlockDestroy(PVector location, int c, int light)
  {
    super(location,c);
    velocity = new PVector(random(1)-0.5f,random(2)+0.5f);
    life = 25;
    lightLevel = light;
  }
  
  public void update()
  {
    //fade
    drawColor = (drawColor & 0xffffff) | ((8*life+50) << 24);
    //update position
    float xVel = velocity.x;
    float yVel = velocity.y;
    //x-axis collision detection
    position.x += xVel;
    if (collided())
    {
      float d = abs(xVel)/xVel;
      while (collided())
      {
        position.x -= d;
      }
      velocity.x = -xVel/3;
    }
    //y-axis collision detection
    if (abs(yVel) >= 0.5f) position.y += yVel;
    if (collided())
    {
      float d = abs(yVel)/yVel;
      while (collided())
      {
        position.y -= d;
      }
      velocity.y = -yVel/5;
      velocity.x *= 0.7f;
    }
    //gravity
    velocity.y += 0.05f;
    //update life countdown
    life -= 1;
  }
  
  public void draw()
  {
    super.draw();
    fill(0, 255*(10-lightLevel)/10);
    ellipse(position.x,position.y,2,2);
  }
  
  public boolean collided()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    if (x < 0 || y < 0 || x >= blocks.length || y >= blocks[0].length) return true;
    return (blocks[x][y] != null && blocks[x][y].isSolid());
  }
}
class Player
{
  //draw variables
  PVector hitbox;
  float lightLevel;
  //movement vectors
  PVector position, velocity, acceleration;
  
  Player(PVector location)
  {
    hitbox = new PVector(playerWidth,playerHeight);
    
    position = location.get();
    velocity = new PVector();
    acceleration = new PVector(0,0.5f);
    lightLevel = 10;
  }
  
  public void update()
  {
    float xVel = velocity.x;
    float yVel = velocity.y;
    //try horizontal movement
    position.x += (collidedNonSolid() ? xVel/3 : xVel);
    if (collided() && xVel != 0)
    {
      xVel = xVel/abs(xVel);
      while (collided())
      {
        position.x -= xVel;
      }
      velocity.x = 0;
    }
    //try vertical movement
    float friction = .25f;
    if (collidedNonSolid())
    {
      if (yVel > 0 && abs(yVel/3) >= .5f) position.y += yVel/3;
      else if (yVel < 0 && abs(yVel/3) >= .5f) position.y += yVel/3;
    }
    else if (!collidedNonSolid() && abs(yVel) >= 1) position.y += yVel;
    if (collided() && yVel != 0)
    {
      yVel = yVel/abs(yVel);
      while (collided())
      {
        position.y -= yVel;
      }
      velocity.y = 0;
      //calculate friction
      int x = (int)(position.x/blockSize);
      int y = (int)((position.y + hitbox.y)/blockSize);
      if (y+2 > blocks[0].length) friction = 3;
      else if (blocks[x][y] != null && blocks[x+1][y] != null)
      {
        friction = (blocks[x][y].getFriction() + blocks[x+1][y].getFriction())/2;
      }
      else if (blocks[x][y] != null)
      {
        friction = blocks[x][y].getFriction();
      }
      else if (blocks[x+1][y] != null)
      {
        friction = blocks[x+1][y].getFriction();
      }
    }
    //add block friction
    if (velocity.x > 0) velocity.x = (velocity.x - friction > 0) ? velocity.x - friction : 0;
    else if (velocity.x < 0) velocity.x = (velocity.x + friction < 0) ? velocity.x + friction : 0; 
    if (velocity.y > 0 && collidedNonSolid()) velocity.y = (velocity.y - friction > 0) ? velocity.y-friction : 0;
    //add gravity
    if (velocity.y > -10) velocity.add(acceleration);
    
    updateLightLevel();
    
    this.draw();
  }
  
  public void draw()
  {
    noStroke();
    fill(255);
    rect(position.x+1,position.y+1,hitbox.x-2,hitbox.y-2);
    float l = ((lightLevel > 10 ) ? 10 : ((lightLevel < 2) ? 2 : lightLevel));
    fill(0,255*(10-(l > 10 ? 10 : l))/10);
    rect(position.x,position.y,hitbox.x,hitbox.y);
  }
  
  public boolean collided()
  {
    int i0 = (int)(position.x/blockSize);
    int i1 = (int)((position.x + hitbox.x - 1)/blockSize);
    int j0 = (int)(position.y/blockSize);
    int j1 = (int)((position.y + hitbox.y/2 - 1)/blockSize);
    int j2 = (int)((position.y + hitbox.y - 1)/blockSize);
    if (position.x < 0 || position.y < 0 || position.x + hitbox.x >= width || position.y + hitbox.y >= height) return true;
    if (i1 >= blocks.length || j2 >= blocks.length) return true;
    return ((blocks[i0][j0] != null && blocks[i0][j0].isSolid())
         || (blocks[i1][j0] != null && blocks[i1][j0].isSolid())
         || (blocks[i0][j1] != null && blocks[i0][j1].isSolid())
         || (blocks[i1][j1] != null && blocks[i1][j1].isSolid())
         || (blocks[i0][j2] != null && blocks[i0][j2].isSolid())
         || (blocks[i1][j2] != null && blocks[i1][j2].isSolid()));
  }
  
  public boolean collidedNonSolid()
  {
    int i0 = (int)(position.x/blockSize);
    int i1 = (int)((position.x + hitbox.x - 1)/blockSize);
    int j0 = (int)(position.y/blockSize);
    int j1 = (int)((position.y + hitbox.y/2 - 1)/blockSize);
    int j2 = (int)((position.y + hitbox.y - 1)/blockSize);
    if (position.x < 0 || position.y < 0 || position.x + hitbox.x >= width || position.y + hitbox.y >= height) return false;
    if (i1 >= blocks.length || j2 >= blocks.length) return true;
    return ((blocks[i0][j0] != null && !blocks[i0][j0].isSolid() && !blocks[i0][j0].getType().startsWith("emitter."))
         || (blocks[i1][j0] != null && !blocks[i1][j0].isSolid() && !blocks[i1][j0].getType().startsWith("emitter."))
         || (blocks[i0][j1] != null && !blocks[i0][j1].isSolid() && !blocks[i0][j1].getType().startsWith("emitter."))
         || (blocks[i1][j1] != null && !blocks[i1][j1].isSolid() && !blocks[i1][j1].getType().startsWith("emitter."))
         || (blocks[i0][j2] != null && !blocks[i0][j2].isSolid() && !blocks[i0][j2].getType().startsWith("emitter."))
         || (blocks[i1][j2] != null && !blocks[i1][j2].isSolid() && !blocks[i1][j2].getType().startsWith("emitter.")));
  }
  
  public void updateLightLevel()
  {
    int i0 = (int)(position.x/blockSize);
    int i1 = (int)((position.x + hitbox.x - 1)/blockSize);
    int j0 = (int)(position.y/blockSize);
    int j1 = (int)((position.y + hitbox.y/2 - 1)/blockSize);
    int j2 = (int)((position.y + hitbox.y - 1)/blockSize);
    int sum = lights[i0][j0] + lights[i0][j1];
    int count = 2;
    if (position.y%blockSize != 0 && position.y + hitbox.y < height)
    {
      sum += lights[i0][j2];
      count += 1;
    }
    if (position.x%blockSize != 0 && position.x+hitbox.x < width)
    {
      sum += lights[i1][j0] + lights[i1][j1];
      count += 2;
      if (position.y%blockSize != 0 && position.y + hitbox.y < height)
      {
        sum += lights[i1][j2];
        count += 1;
      }
    }
    lightLevel = sum/count;
  }
  
  //setters and getters
  public void setHSpeed(float s)
  {
    velocity.x = s;
  }
  
  public void setVSpeed(float s)
  {
    velocity.y = s;
  }
  
  public void setLocation(PVector loc)
  {
    position = loc.get();
    setHSpeed(0);
    setVSpeed(0);
  }
  
  public PVector getLocation()
  {
    return position.get();
  }
  
  public PVector getSpeed()
  {
    return velocity.get();
  }
  
  public PVector getHitbox()
  {
    return hitbox.get();
  }
}
class SpriteManager
{
  HashMap<String,PImage> sprites;
  
  SpriteManager()
  {
    sprites = new HashMap<String,PImage>();
    PImage spriteBase = createImage((int)(2*blockSize),(int)(2*blockSize),ARGB);
    PImage sprite = spriteBase.get();
    int w = sprite.width;
    int h = sprite.height;
    
    //block.dirt
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        sprite.pixels[j*w+i] = color(183,112,54); 
      }
    }
    sprites.put("block.dirt",sprite.get());
    sprite = spriteBase.get();
    
    //block.glass
    for (int i = 0; i < w; i++)
    {
      sprite.pixels[i] = color(250,250,250);
      sprite.pixels[sprite.pixels.length-i-1] = color(250,250,250);
    }
    for (int j = 1; j < w-1; j++)
    {
      sprite.pixels[j*w] = color(250,250,255);
      sprite.pixels[j*w+w-1] = color(250,250,255);
      for (int i = 1; i < w-1; i++)
      {
        sprite.pixels[j*w+i] = color(200,200,200,50);
      }
    }
    sprites.put("block.glass",sprite.get());
    sprite = spriteBase.get();
    
    //block.grass
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
    sprites.put("block.grass",sprite.get());
    sprite = spriteBase.get();
    
    //block.leaf.*.a
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        if ((i < w/3 && j < h/3) || (i >= 2*w/3 && j < h/3) || (i >= w/3 && i < 2*w/3 && j >= h/3 && j < 2*h/3) || (i < w/3 && j >= 2*w/3) || (i >= 2*w/3 && j >= 2*w/3))
        {
          sprite.pixels[j*w+i] = color(33,203,31);
        }
        else
        {
          sprite.pixels[j*w+i] = color(44,157,41,128);
        }
      }
    }
    sprites.put("block.leaf.generated.a",sprite.get());
    sprites.put("block.leaf.placed.a",sprite.get());
    sprite = spriteBase.get();
    
    //block.leaf.*.b
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        if ((i < w/3 && j < h/3) || (i >= 2*w/3 && j < h/3) || (i >= w/3 && i < 2*w/3 && j >= h/3 && j < 2*h/3) || (i < w/3 && j >= 2*w/3) || (i >= 2*w/3 && j >= 2*w/3))
        {
          sprite.pixels[j*w+i] = color(44,157,41,128);
        }
        else
        {
          sprite.pixels[j*w+i] = color(33,203,31);
        }
      }
    }
    sprites.put("block.leaf.generated.b",sprite.get());
    sprites.put("block.leaf.placed.b",sprite.get());
    sprite = spriteBase.get();
    
    //block.light
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        sprite.pixels[j*w+i] = color(255); 
      }
    }
    sprites.put("block.light",sprite.get());
    sprite = spriteBase.get();
    
    //block.log
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        if (i < w/5 || (i >= 2*w/5 && i < 3*w/5) || i >= 4*w/5)
        {
          sprite.pixels[j*w+i] = color(142,96,16);
        }
        else
        {
          sprite.pixels[j*w+i] = color(188,133,30);
        }
      }
    }
    sprites.put("block.log",sprite.get());
    sprite = spriteBase.get();
    
    //block.sand
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        sprite.pixels[j*w+i] = color(255,209,80);
      }
    }
    sprites.put("block.sand",sprite.get());
    sprite = spriteBase.get();
    
    //block.stone
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        sprite.pixels[j*w+i] = color(128);
      }
    }
    sprites.put("block.stone",sprite.get());
    sprite = spriteBase.get();
    
    //block.tnt
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        if (i < w/5 || (i >= 2*w/5 && i < 3*w/5) || i >= 4*w/5)
        {
          sprite.pixels[j*w+i] = color(211,6,6);
        }
        else
        {
          sprite.pixels[j*w+i] = color(163,0,0);
        }
      }
    }
    sprites.put("block.tnt",sprite.get());
    sprite = spriteBase.get();
  }
  
  public PImage getSprite(String type, float drawSize)
  {
    PImage temp = sprites.get(type).get();
    temp.resize((int)drawSize,(int)drawSize);
    return temp.get();
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
