public class Bird extends Mob{

  AnimatedImage animatedImage;
  boolean flyingLeft = true;

  final float MINSPEED = 2.0f;
  final float MAXSPEED = 5.0f;

  public Bird(World world){

    //some birds will fly right
    if(random(0, 2) < 1){
      flyingLeft = false;
    }

    //set spawn position and velocity
    position.set(random(0, world.getWidth()), random(100, 350));
    velocity.set(random(MINSPEED, MAXSPEED), 0);

    if(flyingLeft){
      flipSpriteHorizontal = true;  
      velocity.mult(-1);
    }

    //set dragfactors to 1 so we dont slow down by drag
    groundedDragFactor = 1f;
    aerialDragFactor = 1f;

    //disable gravity
    gravityForce = 0f;

    //allow bird to fly of the screen
    worldBorderCheck = false;

    PImage[] frames = new PImage[3];

    for(int i = 0; i < 3; i++){
      frames[i] = ResourceManager.getImage("BirdFlying" + i); 
    }

    //animation speed based on x velocity
    animatedImage = new AnimatedImage(frames, 20 - abs(velocity.x), position, size.x, flipSpriteHorizontal);
  }

  void draw(){
    animatedImage.draw();
  }

  void update(){
    super.update();

    if(flyingLeft && position.x < -32){
        position.x = world.getWidth() + 100;
    }else if(!flyingLeft && position.x > world.getWidth() + 100){
        position.x = -32;
    }

    if(isGrounded){
      delete(this); 
    }
  }

  void takeDamage(float damageTaken){
    super.takeDamage(damageTaken);
    gravityForce = 0.5f; 
  }
}
