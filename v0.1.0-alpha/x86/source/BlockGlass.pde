class BlockGlass extends Block
{
  BlockGlass(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.glass";
    sprite = spriteManager.getSprite(type,drawSize);
    transparent = true;
  }
}
