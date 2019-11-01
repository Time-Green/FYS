public class Bird extends Mob{

    AnimatedImage animatedImage;
    boolean flyingLeft = true;

    public Bird(World world){

        //some birds will fly right
        if(random(0, 2) < 1){
            flyingLeft = false;
        }

        //set spawn position and velocity
        position = new PVector(random(0, world.getWidth()), random(150, 300));

        if(flyingLeft){
            velocity = new PVector(random(-5f, -2f), 0);
        }else{
            velocity = new PVector(random(2f, 5f), 0);
        }

        //set dragfactors to 1 so we dont slow down by drag
        groundedDragFactor = 1f;
        aerialDragFactor = 1f;

        //disable gravity
        gravityForce = 0f;

        worldBorderCheck = false;

        PImage[] frames = new PImage[3];

        if(flyingLeft){
            for(int i = 0; i < 3; i++){
                frames[i] = ResourceManager.getImage("BirdFlyingLeft" + i); 
            }
        }else{
            for(int i = 0; i < 3; i++){
                frames[i] = ResourceManager.getImage("BirdFlyingRight" + i); 
            }
        }

        //animation speed based on x velocity
        animatedImage = new AnimatedImage(frames, 10 - abs(velocity.x), position);
    }

    void draw(){
        animatedImage.draw();
    }

    void update(World world){
        super.update(world);

        if(flyingLeft && position.x < -32){
            position.x = world.getWidth() + 100;
        }else if(!flyingLeft && position.x > world.getWidth() + 100){
            position.x = -32;
        }
    }
}
