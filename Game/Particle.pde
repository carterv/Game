abstract class Particle
{
  //basic particle properties
  color drawColor;
  int life;
  PVector position;
  PVector velocity;
  
  //particle setup
  Particle(PVector location, color c)
  {
    position = location.get();
    velocity = new PVector(random(2)-1,random(2)-1);
    drawColor = c;
    life = 100;
  }
  
  //update the particle's postion and velocity, decrease life
  void update()
  {
    //gravity
    velocity.y += 0.05;
    //update position
    position.add(velocity);
    //update life countdown
    life -= 1;
  }
  
  //draw the particle
  void draw()
  {
    fill(drawColor);
    ellipse(position.x,position.y,2,2);
  }
  
  //return particle lifespan
  boolean isAlive()
  {
    return life > 0;
  }
}
