class Fluid extends Block
{
  boolean shouldSpread;
  
  Fluid(float x, float y, float scale)
  {
    super(x,y,scale);
    
    type = "fluid.null";
    solid = false;
    shouldSpread = true;
    friction = 4;
  }
  
  void update()
  {
    if (shouldSpread)
    {
      int x = (int)(position.x/blockSize);
      int y = (int)(position.y/blockSize);
      if (x > 0 && (blocks[x-1][y] == null || blocks[x-1][y].getType().startsWith("emitter.")) && (y >= blocks[0].length-1 || (blocks[x][y+1] != null && blocks[x][y+1].isSolid()))) 
      {
        blocks[x-1][y] = newBlock(type, (x-1)*blockSize, y*blockSize, 1);
      }
      if (y < blocks[0].length-1 && (blocks[x][y+1] == null || blocks[x][y+1].getType().startsWith("emitter.")))
      {
        blocks[x][y+1] = newBlock(type, x*blockSize, (y+1)*blockSize, 1);
      }
      if (x < blocks.length-1 && (blocks[x+1][y] == null || blocks[x+1][y].getType().startsWith("emitter.")) && (y >= blocks[0].length-1 || (blocks[x][y+1] != null && blocks[x][y+1].isSolid())))
      {
        blocks[x+1][y] = newBlock(type, (x+1)*blockSize, y*blockSize, 1);
      }
      
      shouldSpread = false;
      this.forceCheck();
    }
  }
  
  void draw() {}
  
  void check()
  {
    shouldSpread = true;
  }
}
