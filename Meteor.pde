class Meteor extends Atom{

Meteor(){
  gravityForce = 1.0f; 
  aerialDragFactor = 1.0f; 
  size = new PVector(tileWidth*2, tileHeight*2); 
  image = ResourceManager.getImage("Meteor 2"); 
//  position = new PVector(random(tilesHorizontal * tileWidth + tileWidth), wallY); 
  
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
