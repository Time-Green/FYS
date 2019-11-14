public class BaseParticle extends Atom {

    BaseParticleSystem particleSystem;
    PVector spawnAcceleration;
    float size, sizeDegrade;

    public BaseParticle(BaseParticleSystem parentParticleSystem, PVector spawnLocation, PVector spawnAcc){
        super();

        gravityForce = 0.0f;
        collisionEnabled = false;
        worldBorderCheck = false;
        groundedDragFactor = 1.0f;
        aerialDragFactor = 1.0f;

        spawnAcceleration = spawnAcc;
        particleSystem = parentParticleSystem;

        position.set(spawnLocation);
        acceleration.set(spawnAcceleration);
        size = random(4, 10);
        sizeDegrade = random(0.5, 1);
    }

    void update(){
        super.update();

        updateSize();
    }

    void draw(){
        //super.draw();
        
        rect(position.x - size / 2, position.y - size / 2, size, size);
    }

    private void updateSize(){
        size -= sizeDegrade;
        
        if(size <= 0){
            particleSystem.currentParticleAmount--;
            delete(this);
        }
    }
}
