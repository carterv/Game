class FluidWater extends Fluid
{
  boolean shouldSpread;
  
  FluidWater(float x, float y, float scale)
  {
    super(x,y,scale);
    
    type = "fluid.water";
  }
  
  void draw()
  {
    int x = (int)(position.x/blockSize);
    int y = (int)(position.y/blockSize);
    boolean flag = false;
    if (y > 0 && drawSize/blockSize == 1)
    {
      flag = blocks[x][y-1] != null && !blocks[x][y-1].getType().startsWith("emitter.");
    }
    fill(0,50,200,128);
    if (flag || drawSize/blockSize != 1)
    {
      rect(position.x,position.y,drawSize,drawSize);
    }
    else
    {
      rect(position.x,position.y+drawSize/4,drawSize,3*drawSize/4);
    }
  }
}
