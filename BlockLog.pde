class BlockLog extends Block
{
  BlockLog(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.log";
    this.makeSprite();
  }
  
  void makeSprite()
  {
    int w = sprite.width;
    int h = sprite.height;
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
  }
}
