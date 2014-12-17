abstract class Block
{
  boolean solid;
  float friction;
  float drawSize;
  PImage sprite;
  PVector position;
  String type;

  Block(float xpos, float ypos, float scale)
  {
    position = new PVector(xpos, ypos);
    drawSize = scale*blockSize;
    friction = 3;
    solid = true;
    type = "block.null";
    this.forceCheck();
  }

  void update() {}

  void check() {}

  void draw()
  {
    if (sprite != null) image(sprite, position.x, position.y);
  }

  void forceCheck()
  {
    if (drawSize/blockSize == 1)
    {
      int x = (int)(position.x/blockSize);
      int y = (int)(position.y/blockSize);
      if (y > 0 && blocks[x][y-1] != null) blocks[x][y-1].check();
      if (x > 0)
      {
        if (y > 0 && blocks[x-1][y-1] != null) blocks[x-1][y-1].check();
        if (blocks[x-1][y] != null) blocks[x-1][y].check();
        if (y < blocks[0].length-1 && blocks[x-1][y+1] != null) blocks[x-1][y+1].check();
      }
      if (y < blocks[0].length-1 && blocks[x][y+1] != null) blocks[x][y+1].check();
      if (x < blocks.length-1)
      {
        if (y > 0 && blocks[x+1][y-1] != null) blocks[x+1][y-1].check();
        if (blocks[x+1][y] != null) blocks[x+1][y].check();
        if (y < blocks[0].length-1 && blocks[x+1][y+1] != null) blocks[x+1][y+1].check();
      }
    }
  }

  float getFriction()
  {
    return friction;
  }

  String getType()
  {
    return type;
  }

  boolean isSolid()
  {
    return solid;
  }
  
  PImage getSprite()
  {
    if (sprite != null) return sprite.get();
    else return null;
  }
}

