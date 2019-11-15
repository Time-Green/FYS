class Meteor extends Movable{

  Meteor(){
    gravityForce = 1.0f; 
    aerialDragFactor = 1.0f; 
    size.set(tileWidth * 2, tileHeight * 2); 
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
