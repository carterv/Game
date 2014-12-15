abstract class Particle
{
  //basic particle properties
  color drawColor;
  PVector position;
  PVector acceleration;
  PVector velocity;
  
  //particle setup
  Particle(PVector location, color c)
  {
    position = location.get();
    acceleration = new PVector(0,0.05);
    velocity = new PVector(random(2)-1,random(2)-1);
    drawColor = c;
  }
  
  //update the particle's postion and velocity, decrease life
  void update()
  {
    velocity.add(acceleration);
    position.add(velocity);
  }
  
  //draw the particle
  void draw()
  {
    fill(drawColor);
    ellipse(0,0,1,1);
  }
  
  //return particle lifespan
  boolean isAlive()
  {
    return true;
  }
}
