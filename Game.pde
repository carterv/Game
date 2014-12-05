//controller variables
Block[][] blocks;
Player player;

//game options, mostly constants
float blockSize, playerHeight, playerWidth;
color backgroundColor;

//input variables
boolean mouseL, mouseR, moveL, moveR;

void setup()
{
  //window options
  size(1000,600);
  frameRate(30);
  
  //draw options
  noStroke();
  blockSize = 20;
  playerHeight = 1.8*blockSize;
  playerWidth = blockSize;
  backgroundColor = color(0,128);
  
  //input variables
  mouseL = mouseR = moveL = moveR = false;
  
  //controller variables
  blocks = new Block[(int)(width/blockSize)][(int)(height/blockSize)];
  player = new Player(new PVector(width/2-blockSize/2,0));
}

void draw()
{
  fill(backgroundColor);
  rect(0,0,width,height);

  //check input
  doInput();
    
  //draw the blocks
  renderBlocks();
  
  //draw and update the player
  player.update();
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
    moveL = true;
  }
  else if (key == 'w' || key == 'W')
  {
    int px = (int)(player.getLocation().x/blockSize);
    int py = (int)(player.getLocation().y/blockSize);
    if (py+2 >= blocks[0].length || (blocks[px][py+2] != null || (px+1 < blocks.length ? blocks[px+1][py+2] != null : false)))
    {
      player.setVSpeed(-7);
    }
  }
  else if (key == 'd' || key == 'D')
  {
    moveR = true;
  }
  else if (key == ' ')
  {
    player.setLocation(new PVector(mouseX - mouseX%blockSize, mouseY - mouseY%blockSize));
  }
}

void keyReleased()
{
  if (key == 'a' || key == 'A')
  {
    moveL = false;
  }
  else if(key == 'd' || key == 'D')
  {
    moveR = false;
  }
}

void renderBlocks()
{
  for (int i = 0; i < blocks.length; i++)
  {
    for (int j = 0; j < blocks[i].length; j++)
    {
      if (blocks[i][j] != null) 
      {
        blocks[i][j].draw();
      }
    }
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
      if ((blocks[mx][my] == null))
      {
        blocks[mx][my] = new BlockStone(mx*blockSize,my*blockSize,1);
      }
    }
  }
  else if (mouseR)
  {
    int mx = (int)(mouseX/blockSize);
    int my = (int)(mouseY/blockSize);
    if (!(mx < 0 || mx >= blocks.length || my < 0 || my >= blocks[0].length))
    {
      if ((blocks[mx][my] != null))
      {
        blocks[mx][my].destroy();
        blocks[mx][my] = null;
      }
    }
  }
  if (moveL)
  {
    player.setHSpeed(-4);
  }
  else if (moveR)
  {
    player.setHSpeed(4);
  }
}
