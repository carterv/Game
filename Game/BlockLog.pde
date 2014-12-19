class BlockLog extends Block
{
  BlockLog(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.log";
    sprite = spriteManager.getSprite(type,drawSize);
  }
}
