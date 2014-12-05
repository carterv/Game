abstract class Block
{
  PVector position;
  float drawSize;
  
  Block(float x, float y, float scale)
  {
    position = new PVector(x,y);
    drawSize = scale*blockSize;
  }
  
  void update()
  {
    
  }
  
  void draw()
  {
    
  }
  
  void destroy()
  {
    
  }
}
