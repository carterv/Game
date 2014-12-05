class Player
{
  //draw size
  PVector drawSize;
  //movement vectors
  PVector position, velocity, acceleration;
  
  Player(PVector location)
  {
    drawSize = new PVector(playerWidth,playerHeight);
    
    position = location.get();
    velocity = new PVector();
    acceleration = new PVector(0,0.5);
  }
  
  void update()
  {
    position.add(velocity);
    velocity.add(acceleration);
    //add block friction
    
    this.draw();
  }
  
  void draw()
  {
    fill(255);
    rect(position.x,position.y,drawSize.x,drawSize.y);
  }
  
  boolean collided()
  {
    //fill with block collision detection code
    return false;
  }
  
  //setters and getters
  void setHSpeed(float s)
  {
    velocity.x = s;
  }
  
  void setVSpeed(float s)
  {
    velocity.y = s;
  }
  
  PVector getLocation()
  {
    return position.get();
  }
  
  PVector getSpeed()
  {
    return velocity.get();
  }
}
