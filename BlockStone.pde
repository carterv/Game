class BlockStone extends Block
{
  BlockStone(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.stone";
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
        sprite.pixels[j*w+i] = color(128);
      }
    }
  }
}
