class Jukebox extends Obstacle
{
    int musicNotes = 4;
    int travelDistance = 200;
    boolean destroyed = false;
    int numbers = 4;
    int particleVelocity = 1;
    int particleDelay = 30;
    EmmitingParticleSystem particleSystem;

    Jukebox(PVector spawnPos)
    {
        position.set(spawnPos);

        image = ResourceManager.getImage("Jukebox");

        anchored = true;

        particleSystem = new EmmitingParticleSystem(position, particleVelocity, particleDelay, true);
        load(particleSystem, position);

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
