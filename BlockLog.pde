class BlockLog extends Block
{
  BlockLog(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.log";
  }
  
  void draw()
  {
    fill(142,98,16);
    rect(position.x,position.y,drawSize/5,drawSize);
    fill(188,133,30);
    rect(position.x+drawSize/5,position.y,drawSize/5,drawSize);
    fill(142,98,16);
    rect(position.x+2*drawSize/5,position.y,drawSize/5,drawSize);
    fill(188,133,30);
    rect(position.x+3*drawSize/5,position.y,drawSize/5,drawSize);
    fill(142,98,16);
    rect(position.x+4*drawSize/5,position.y,drawSize/5,drawSize);
  }
}
