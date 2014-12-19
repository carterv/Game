class BlockStone extends Block
{
  BlockStone(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.stone";
    sprite = spriteManager.getSprite(type,drawSize);
  }
}
