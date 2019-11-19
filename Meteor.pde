class Meteor extends Movable{

  private final float MAXHORIZONTALVELOCITY = 20.0;
  private final float MINSIZE = 1.0;
  private final float MAXSIZE = 4.0;

  private float sizeModifier;

  Meteor(){
    sizeModifier = random(MINSIZE, MAXSIZE);
    size.set(tileWidth * sizeModifier, tileHeight * sizeModifier);

    aerialDragFactor = 1.0f;
    velocity.set(random(-MAXHORIZONTALVELOCITY, MAXHORIZONTALVELOCITY), 0);
    image = ResourceManager.getImage("Meteor 2");
  }

  void update(){
    super.update(); 

    if(isGrounded){
      load(new Explosion(position, 200 * sizeModifier)); 
      delete(this); 
    }
  }

  void draw(){
    super.draw(); 
  }
}
