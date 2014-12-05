//controller variables
Block[][] blocks;

//game options, mostly constants
float blockSize, playerHeight, playerWidth;
color backgroundColor;

//input variables
boolean mouseL, mouseR;

void setup()
{
  //window and background color
  size(1000,600);
  
  //draw options
  noStroke();
  blockSize = 20;
  playerHeight = 1.8*blockSize;
  playerWidth = blockSize;
  backgroundColor = 0;
  
  //input variables
  mouseL = mouseR = false;
  
  //terrain
  blocks = new Block[(int)(width/blockSize)][(int)(height/blockSize)];
}

void draw()
{
  background(backgroundColor);

  //check input
  doInput();
    
  //draw the blocks
  renderBlocks();
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
  if (mouseR)
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
}
