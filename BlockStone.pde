class BlockStone extends Block
{
  BlockStone(float x, float y, float scale)
  {
    super(x,y,scale);
  }
  
  void draw()
  {
    fill(128);
    rect(position.x,position.y,drawSize,drawSize);
  }
}
