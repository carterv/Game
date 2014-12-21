class BlockLamp extends Block
{
  BlockLamp(float x, float y, float scale)
  {
    super(x,y,scale);
    type = "block.lamp";
    sprite = spriteManager.getSprite(type,drawSize);
    transparent = true;
  }
  
  void updateLightLevel()
  {
    setLightLevel(12);
  }
}
