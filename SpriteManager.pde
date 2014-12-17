class SpriteManager
{
  HashMap<String,PImage> sprites;
  
  SpriteManager()
  {
    sprites = new HashMap<String,PImage>();
    PImage spriteBase = createImage((int)(2*blockSize),(int)(2*blockSize),ARGB);
    PImage sprite = spriteBase.get();
    int w = sprite.width;
    int h = sprite.height;
    
    //block.dirt
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        sprite.pixels[j*w+i] = color(183,112,54); 
      }
    }
    sprites.put("block.dirt",sprite.get());
    sprite = spriteBase.get();
    
    //block.grass
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h/4; j++)
      {
        sprite.pixels[j*h+i] = color(30,175,45); 
      }
    }
    for (int i = 0; i < w; i++)
    {
      for (int j = h/4; j < h; j++)
      {
        sprite.pixels[j*w+i] = color(183,112,54); 
      }
    }
    sprites.put("block.grass",sprite.get());
    sprite = spriteBase.get();
    
    //block.leaf.*.a
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        if ((i < w/3 && j < h/3) || (i >= 2*w/3 && j < h/3) || (i >= w/3 && i < 2*w/3 && j >= h/3 && j < 2*h/3) || (i < w/3 && j >= 2*w/3) || (i >= 2*w/3 && j >= 2*w/3))
        {
          sprite.pixels[j*w+i] = color(33,203,31);
        }
        else
        {
          sprite.pixels[j*w+i] = color(44,157,41,128);
        }
      }
    }
    sprites.put("block.leaf.generated.a",sprite.get());
    sprites.put("block.leaf.placed.a",sprite.get());
    sprite = spriteBase.get();
    
    //block.leaf.*.b
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        if ((i < w/3 && j < h/3) || (i >= 2*w/3 && j < h/3) || (i >= w/3 && i < 2*w/3 && j >= h/3 && j < 2*h/3) || (i < w/3 && j >= 2*w/3) || (i >= 2*w/3 && j >= 2*w/3))
        {
          sprite.pixels[j*w+i] = color(44,157,41,128);
        }
        else
        {
          sprite.pixels[j*w+i] = color(33,203,31);
        }
      }
    }
    sprites.put("block.leaf.generated.b",sprite.get());
    sprites.put("block.leaf.placed.b",sprite.get());
    sprite = spriteBase.get();
    
    //block.log
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
    sprites.put("block.log",sprite.get());
    sprite = spriteBase.get();
    
    //block.sand
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        sprite.pixels[j*w+i] = color(255,209,80);
      }
    }
    sprites.put("block.sand",sprite.get());
    sprite = spriteBase.get();
    
    //block.stone
    for (int i = 0; i < w; i++)
    {
      for (int j = 0; j < h; j++)
      {
        sprite.pixels[j*w+i] = color(128);
      }
    }
    sprites.put("block.stone",sprite.get());
    sprite = spriteBase.get();
  }
  
  PImage getSprite(String type, float drawSize)
  {
    PImage temp = sprites.get(type).get();
    temp.resize((int)drawSize,(int)drawSize);
    return temp.get();
  }
}
