class Meteor extends Movable{

  private final float MAXHORIZONTALVELOCITY = 20.0;

  Meteor(){
    gravityForce = 1.0f; 
    aerialDragFactor = 1.0f; 
    size.set(tileWidth * 2, tileHeight * 2);
    velocity.set(random(-MAXHORIZONTALVELOCITY, MAXHORIZONTALVELOCITY), 0);
    image = ResourceManager.getImage("Meteor 2");
  }

  void update(){
    super.update(); 

    if(isGrounded){
      load(new Explosion(position, 250)); 
      delete(this); 
    }
  }

  void draw(){
    super.draw(); 
  }
}
