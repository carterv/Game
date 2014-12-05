abstract class Block
{
  PVector position;
  float drawSize;
  float friction;
  
  Block(float x, float y, float scale)
  {
    position = new PVector(x,y);
    drawSize = scale*blockSize;
    friction = 3;
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
  
  float getFriction()
  {
    return friction;
  }
}
