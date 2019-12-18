class Jukebox extends Obstacle
{
    int musicNotes = 4;
    int travelDistance = 200;
    boolean destroyed = false;
    int numbers = 4;
    int particleVelocity = 25;
    int particleDelay = 5;
    EmmitingParticleSystem particleSystem;

    Jukebox()
    {
        image = ResourceManager.getImage("Jukebox");
        particleSystem = new EmmitingParticleSystem(position, particleVelocity, particleDelay);
        music();
    }

    void update()
    {
        super.update();
    }
    
        //hihi super secret easter egg, groetjes Jordy :)

    void music()
    {
        AudioManager.playMusic("JukeboxNum" + floor(random(numbers)) + "Music");
    }

    void takeDamage(float damageTaken)
    {
        super.takeDamage(damageTaken);

        delete(this);
    }
}
