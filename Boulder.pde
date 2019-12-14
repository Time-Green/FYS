class Boulder extends Obstacle {

    private float damage = 20;
    private float horizontal;
    private float vertical;
    private float xSpeed = 10;
    private float ySpeed = 5;
    private float meteorChance = 10;
    private float distAfterWallMin = 100;
    private float distAfterWallMax = 200;

    Boulder() {

    }

    void update() {

        super.update();
    
    }

    void impact() {
    //when a meteor hits the ground it should turn into a boulder
    //but this only happens to big meteors and is a small chance 
    }

    void checkDirect(){
    //check which way the boulder should go
    }

    void collisonPlayer() {
    //check if the boulder hits the player       
    }

    void collison() {
    //check if the boulder is bigger or the wall that it will bump into
    //if the wall is bigger the boulder would explode other wise the meteor will destroy it and go on a small dist.
    }

    


}