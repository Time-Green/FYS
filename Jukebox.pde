class Jukebox extends Movable
{
    int musicNotes = 4;
    boolean destroyed = false;
    int numbers = 4;
    float particleVelocity = 1;
    int particleDelay = 30;
    EmmitingParticleSystem particleSystem;

    Jukebox(PVector spawnPos)
    {
        position.set(spawnPos);

        image = ResourceManager.getImage("Jukebox");

        particleSystem = new EmmitingParticleSystem(new PVector(position.x + 10, position.y + 5), particleVelocity, particleDelay, true);
        load(particleSystem);

        music();
    }

    void update()
    {
        super.update();

        // cheeky fix for audio not stopping
        if(position.y < wallOfDeath.position.y)
        {
            takeDamage(1.0f);
        }
    }

    void music()
    {
        AudioManager.loopMusic("JukeboxNum" + floor(random(numbers)) + "Music");
    }

    //we need to delete the jukebox and stop all numbers from playing
    void takeDamage(float damageTaken)
    {
        super.takeDamage(damageTaken);

        for(int i = 0; i < numbers; i++) 
        {
            AudioManager.stopMusic("JukeboxNum" + i + "Music");
        }
        
        delete(particleSystem);
        delete(this);
    }
}