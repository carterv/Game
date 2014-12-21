class BlockLight extends Block
{
  BlockLight(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.light";
    sprite = spriteManager.getSprite(type,drawSize);
    transparent = true;
  }
  
  void updateLightLevel()
  {
    setLightLevel(12);
  }
}
